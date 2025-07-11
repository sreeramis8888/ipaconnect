const mongoose = require("mongoose");

const cart_schema = mongoose.Schema(
  {
    user: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
    products: [
      {
        store: { type: mongoose.Schema.Types.ObjectId, ref: "Store" },
        quantity: { type: Number },
      },
    ],
  },
  { timestamps: true }
);

const Cart = mongoose.model("Cart", cart_schema);

module.exports = Cart;
