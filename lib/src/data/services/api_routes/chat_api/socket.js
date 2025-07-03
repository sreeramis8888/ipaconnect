const jwt = require("jsonwebtoken");
const Users = require("../modules/users/users.model");
const Message = require("../modules/chat/messages.model");
const Conversation = require("../modules/chat/conversations.model");
const response_handler = require("../helpers/response_handler");

const online_users = new Map();
const is_online = (uid) => online_users.has(uid.toString());
const recipients = (memberIds, senderId) =>
  memberIds.filter((id) => id.toString() !== senderId.toString());

async function broadcast_status(io, user_id, online) {
  const conv_ids = await Conversation.find({ members: user_id }).distinct(
    "_id"
  );
  conv_ids.forEach((room) =>
    io.to(room.toString()).emit("user:status", { user_id, online })
  );
}

async function join_all_rooms(socket) {
  const conv_ids = await Conversation.find({
    members: socket.user_id,
  }).distinct("_id");
  conv_ids.forEach((id) => socket.join(id.toString()));
  return conv_ids;
}

async function send_initial_statuses(socket) {
  const convs = await Conversation.find({ members: socket.user_id })
    .select("members")
    .lean();
  const sent = new Set();
  for (const conv of convs) {
    for (const id of conv.members) {
      const uid = id.toString();
      if (uid !== socket.user_id && is_online(uid) && !sent.has(uid)) {
        socket.emit("user:status", { user_id: uid, online: true });
        sent.add(uid);
      }
    }
  }
}

exports.setup_socket = (io) => {
  io.use(async (socket, next) => {
    try {
      const { api_key, token } = socket.handshake.auth;
      if (!api_key || api_key !== process.env.API_KEY)
        return response_handler(socket, 401, "Invalid API key");
      if (!token) return response_handler(socket, 401, "No token provided");

      const { user_id } = jwt.verify(token, process.env.JWT_SECRET);
      socket.user_id = user_id;

      await Users.findByIdAndUpdate(user_id, { online: true });
      (
        online_users.get(user_id) ||
        online_users.set(user_id, new Set()).get(user_id)
      ).add(socket.id);

      next();
    } catch (err) {
      return response_handler(socket, 500, "Failed to authenticate token");
    }
  });

  io.on("connection", (socket) => {
    console.log("[WS] connected:", socket.user_id);
    socket.join(socket.user_id.toString());
    join_all_rooms(socket).catch(console.error);
    broadcast_status(io, socket.user_id, true).catch(console.error);
    send_initial_statuses(socket).catch(console.error);

    socket.on("conversations:subscribe", async (ack) => {
      try {
        const rooms = await join_all_rooms(socket);
        const conversations = await Conversation.find({ _id: { $in: rooms } })
          .sort({ updatedAt: -1 })
          .populate({
            path: "last_message",
            select: "message status createdAt sender",
          })
          .populate("members", "name image")
          .lean();

        const enriched = await Promise.all(
          conversations.map(async (conv) => {
            const unread_count = await Message.countDocuments({
              conversation: conv._id,
              sender: { $ne: socket.user_id },
              seen_by: { $ne: socket.user_id },
            });
            return { ...conv, unread_count };
          })
        );

        socket.emit("conversations:list", enriched);
        ack?.(null, rooms);
      } catch (e) {
        console.error("subscribe error →", e.message);
        ack?.("Failed to subscribe");
      }
    });

    socket.on("chat:join", (conversation_id, ack) => {
      socket.join(conversation_id);
      Conversation.findById(conversation_id)
        .select("members")
        .then(({ members }) => {
          const statuses = members.map((id) => ({
            user_id: id.toString(),
            online: is_online(id),
          }));
          socket.emit("user:status", statuses);
          ack?.();
        })
        .catch(console.error);
    });

    socket.on(
      "chat:history",
      async ({ conversation_id, page = 1, limit = 20 }, cb) => {
        try {
          const skip = (page - 1) * limit;
          const messages = await Message.find({ conversation: conversation_id })
            .sort({ createdAt: -1 })
            .skip(skip)
            .limit(limit)
            .lean();
          const total_count = await Message.countDocuments({
            conversation: conversation_id,
          });
          cb?.(null, messages.reverse(), total_count);
        } catch (err) {
          console.error("history error →", err.message);
          cb?.("Failed to load history");
        }
      }
    );

    socket.on("chat:typing", ({ conversation_id, is_typing }) => {
      socket.to(conversation_id).emit("chat:typing", {
        user_id: socket.user_id,
        conversation_id,
        is_typing,
      });
    });

    socket.on("chat:message", async (payload, ack) => {
      try {
        const { conversation_id, message, attachments = [] } = payload;
        const conv = await Conversation.findById(conversation_id).select(
          "members"
        );

        let msg = await Message.create({
          conversation: conversation_id,
          sender: socket.user_id,
          message,
          attachments,
          status: "sent",
          seen_by: [socket.user_id],
        });

        const online_receivers = recipients(
          conv.members,
          socket.user_id
        ).filter(is_online);
        if (online_receivers.length) {
          msg.delivered_by = online_receivers;
          msg.status = "delivered";
          await msg.save();
        }

        const updated_conv = await Conversation.findByIdAndUpdate(
          conversation_id,
          {
            last_message: msg._id,
          }
        );
        io.to(conversation_id).emit("chat:message", msg);
        io.to(conversation_id).emit("conversation:latest", {
          conversation_id,
          text: msg.message,
          status: msg.status,
          members: updated_conv.members,
        });
        ack?.(null, msg);
      } catch (e) {
        ack?.(`Message send failed: ${e.message}`);
      }
    });

    socket.on("chat:delivered", async ({ message_id }) => {
      try {
        const msg = await Message.findByIdAndUpdate(
          message_id,
          {
            $addToSet: { delivered_by: socket.user_id },
            $set: { status: "delivered" },
          },
          { new: true }
        );
        io.to(msg.sender.toString()).emit("chat:delivered", msg);
        io.to(msg.conversation.toString()).emit("conversation:latest", {
          conversation_id: msg.conversation.toString(),
          text: msg.message,
          status: msg.status,
        });
      } catch (e) {
        console.error("deliver error →", e.message);
      }
    });

    socket.on("chat:seen", async ({ message_id }) => {
      try {
        const msg = await Message.findByIdAndUpdate(
          message_id,
          { $addToSet: { seen_by: socket.user_id } },
          { new: true }
        );
        const conv = await Conversation.findById(msg.conversation).select(
          "members"
        );
        const all_seen = msg.seen_by.length === conv.members.length;
        if (all_seen && msg.status !== "seen") {
          msg.status = "seen";
          await msg.save();
        } else if (msg.status === "sent") {
          msg.status = "delivered";
          await msg.save();
        }
        io.to(msg.sender.toString()).emit("chat:seen", msg);
        io.to(conv._id.toString()).emit("conversation:latest", {
          conversation_id: conv._id.toString(),
          text: msg.message,
          status: msg.status,
        });
      } catch (e) {
        console.error("seen error →", e.message);
      }
    });

    socket.on("disconnect", async () => {
      const set = online_users.get(socket.user_id);
      if (set) {
        set.delete(socket.id);
        if (set.size === 0) {
          online_users.delete(socket.user_id);
          await Users.findByIdAndUpdate(socket.user_id, {
            online: false,
            last_seen: new Date(),
          });
          broadcast_status(io, socket.user_id, false).catch(console.error);
        }
      }
      console.log("[WS] disconnected:", socket.user_id);
    });
  });
};
