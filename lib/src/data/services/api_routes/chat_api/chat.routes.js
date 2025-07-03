const express = require("express");
const chat_controller = require("./chat.controller");
const log_activity = require("../../middlewares/log_activity");
const auth_verify = require("../../middlewares/auth_verify");
const router = express.Router();

router.use(auth_verify);

router.get(
  "/conversation",
  log_activity("view_conversations"),
  chat_controller.get_conversations
);
router.post(
  "/conversations",
  log_activity("create_conversation"),
  chat_controller.create1to1
);
router.post(
  "/group",
  log_activity("create_group"),
  chat_controller.create_group
);
router.post(
  "/send-message",
  log_activity("send_message"),
  chat_controller.send_message
);
router.patch(
  "/messages/delivered",
  log_activity("delivered_message"),
  chat_controller.mark_delivered
);
router.patch(
  "/messages/seen",
  log_activity("seen_message"),
  chat_controller.mark_seen
);

module.exports = router;
