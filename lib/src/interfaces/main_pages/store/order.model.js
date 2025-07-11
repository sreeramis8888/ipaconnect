const mongoose = require("mongoose");

const order_schema = mongoose.Schema(
  {
    user: { type: mongoose.Schema.Types.ObjectId, ref: "Users" },
    store: { type: mongoose.Schema.Types.ObjectId, ref: "Store" },
    amount: { type: Number },
    quantity: { type: Number },
    currency: { type: String, trim: true, default: "USD" },
    shipping_address: {
      name: { type: String, trim: true },
      phone: { type: String, trim: true },
      address: { type: String, trim: true },
      city: { type: String, trim: true },
      state: { type: String, trim: true },
      country: { type: String, trim: true },
      pincode: { type: String, trim: true },
      is_saved: { type: Boolean, default: false },
    },
    payment_id: { type: String, trim: true },
    receipt: { type: String, trim: true },
    status: {
      type: String,
      trim: true,
      enum: ["pending", "ordered", "placed", "completed", "failed"],
      default: "pending",
    },
  },
  { timestamps: true }
);

const Order = mongoose.model("Order", order_schema);

module.exports = Order;
