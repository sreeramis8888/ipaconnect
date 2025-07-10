const express = require("express");
const rating_controller = require("./rating.controller");
const check_access = require("../../middlewares/check_access");
const log_activity = require("../../middlewares/log_activity");
const router = express.Router();

router.post(
  "/",
  check_access("rating_management_modify"),
  log_activity("create_rating"),
  rating_controller.create_rating
);

router.get(
  "/by-entity/:id",
  check_access("rating_management_view"),
  log_activity("view_rating"),
  rating_controller.get_ratings_by_entity
);

router
  .route("/:id")
  .get(
    check_access("rating_management_view"),
    log_activity("view_rating"),
    rating_controller.get_rating_by_id
  )
  .put(
    check_access("rating_management_modify"),
    log_activity("update_rating"),
    rating_controller.update_rating
  )
  .delete(
    check_access("rating_management_modify"),
    log_activity("delete_rating"),
    rating_controller.delete_rating
  );

module.exports = router;
