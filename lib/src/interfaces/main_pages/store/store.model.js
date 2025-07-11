const mongoose = require("mongoose");

const store_schema = mongoose.Schema(
  {
    name: { type: String, trim: true },
    category: { type: String, trim: true, set: (v) => v.toLowerCase() },
    price: { type: Number },
    currency: { type: String, trim: true, default: "USD" },
    image: { type: String, trim: true },
    description: { type: String, trim: true },
    status: {
      type: Boolean,
      default: true,
    },
    created_by: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
  },
  { timestamps: true }
);

const Store = mongoose.model("Store", store_schema);

module.exports = Store;
