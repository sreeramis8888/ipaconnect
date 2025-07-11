const express = require("express");
const store_controller = require("./store.controller");
const check_access = require("../../middlewares/check_access");
const log_activity = require("../../middlewares/log_activity");
const auth_verify = require("../../middlewares/auth_verify");
const router = express.Router();

router.use(auth_verify);
router
  .route("/")
  .get(
    check_access("store_management_view"),
    log_activity("view_store"),
    store_controller.get_stores
  )
  .post(
    check_access("store_management_modify"),
    log_activity("create_store"),
    store_controller.create_store
  );

router.get(
  "/categories",
  check_access("store_management_view"),
  log_activity("view_store_categories"),
  store_controller.get_store_categories
);

router.get(
  "/orders",
  check_access("store_management_view"),
  log_activity("view_orders"),
  store_controller.get_orders
);

router.post(
  "/order",
  check_access("store_management_modify"),
  log_activity("create_order"),
  store_controller.create_order
);

router.get(
  "/order/saved-shipping-address",
  log_activity("view_saved_shipping_address"),
  store_controller.get_saved_shipping_address
);

router.get("/cart", log_activity("view_cart"), store_controller.get_cart);

router.post(
  "/add-to-cart/:id",
  log_activity("add_to_cart"),
  store_controller.add_to_cart
);

router.post(
  "/remove-from-cart/:id",
  log_activity("remove_from_cart"),
  store_controller.remove_from_cart
);

router.post(
  "/increment-quantity/:id",
  log_activity("increment_quantity"),
  store_controller.increment_quantity
);

router.post(
  "/decrement-quantity/:id",
  log_activity("decrement_quantity"),
  store_controller.decrement_quantity
);

router
  .route("/:id")
  .get(
    check_access("store_management_view"),
    log_activity("view_store"),
    store_controller.get_store_by_id
  )
  .put(
    check_access("store_management_modify"),
    log_activity("update_store"),
    store_controller.update_store
  )
  .delete(
    check_access("store_management_modify"),
    log_activity("delete_store"),
    store_controller.delete_store
  );

module.exports = router;
