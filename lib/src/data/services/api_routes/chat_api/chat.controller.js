const response_handler = require("../../helpers/response_handler");
const Conversation = require("./conversations.model");
const Message = require("./messages.model");

exports.get_conversations = async (req, res) => {
  try {
    const { user_id } = req;
    const conversations = await Conversation.find({ members: user_id })
      .populate("members", "name online last_seen")
      .populate("last_message");
    return response_handler(
      res,
      200,
      "Conversations fetched successfully",
      conversations
    );
  } catch (error) {
    return response_handler(res, 500, `Internal Server Error ${error.message}`);
  }
};

exports.create1to1 = async (req, res) => {
  try {
    const { recipient_id } = req.body;
    if (!recipient_id)
      return response_handler(res, 400, "Recipient ID is required");
    const members = [req.user_id, recipient_id];
    let conversation = await Conversation.findOne({
      is_group: false,
      members: { $all: members },
      members: { $size: 2 },
    });
    if (!conversation) {
      conversation = await Conversation.create({
        name: "1to1",
        is_group: false,
        members,
        admins: [req.user_id],
      });
    }
    return response_handler(
      res,
      200,
      "Conversation created successfully",
      conversation
    );
  } catch (error) {
    return response_handler(res, 500, `Internal Server Error ${error.message}`);
  }
};

exports.create_group = async (req, res) => {
  try {
    const { name, members, admins } = req.body;
    if (!name) return response_handler(res, 400, "Group name is required");
    if (members.length < 2)
      return response_handler(res, 400, "Members are required");
    const unique_members = Array.from(new Set([...members, req.user_id]));
    const unique_admins = Array.from(new Set([...(admins || []), req.user_id]));
    const conversation = await Conversation.create({
      name,
      is_group: true,
      members: unique_members,
      admins: unique_admins,
    });
    return response_handler(
      res,
      200,
      "Group created successfully",
      conversation
    );
  } catch (error) {
    return response_handler(res, 500, `Internal Server Error ${error.message}`);
  }
};

exports.send_message = async (req, res) => {
  try {
    const { conversation_id, message, attachments } = req.body;
    if (!conversation_id)
      return response_handler(res, 400, "Conversation ID is required");
    if (!message) return response_handler(res, 400, "Message is required");
    const msg = await Message.create({
      conversation: conversation_id,
      sender: req.user_id,
      message,
      ...(attachments && { attachments }),
    });
    await Conversation.findByIdAndUpdate(conversation_id, {
      last_message: msg._id,
    });
    req.io.to(conversation_id).emit("chat:message", msg);
    return response_handler(res, 200, "Message sent successfully", msg);
  } catch (error) {
    return response_handler(res, 500, `Internal Server Error ${error.message}`);
  }
};

exports.mark_delivered = async (req, res) => {
  try {
    const { message_id } = req.body;
    if (!message_id)
      return response_handler(res, 400, "Message ID is required");
    const msg = await Message.findById(message_id);
    if (!msg) return response_handler(res, 400, "Message not found");
    await Message.findByIdAndUpdate(
      message_id,
      { status: "delivered" },
      { new: true }
    );
    req.io.to(msg.conversation.toString()).emit("chat:delivered", msg);
    return response_handler(res, 200, "Message marked as delivered", msg);
  } catch (error) {
    return response_handler(res, 500, `Internal Server Error ${error.message}`);
  }
};

exports.mark_seen = async (req, res) => {
  try {
    const { message_id } = req.body;
    if (!message_id) return response_handler(res, 400, "message_id required");

    let msg = await Message.findByIdAndUpdate(
      message_id,
      { $addToSet: { seen_by: req.user_id } },
      { new: true }
    );
    if (!msg) return response_handler(res, 404, "Message not found");

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

    req.io.to(conv._id.toString()).emit("chat:seen", msg);
    return response_handler(res, 200, "Marked seen", msg);
  } catch (error) {
    return response_handler(res, 500, `Internal Server Error ${error.message}`);
  }
};
