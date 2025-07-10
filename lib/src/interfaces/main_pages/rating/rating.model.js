const mongoose = require("mongoose");

const rating_schema = mongoose.Schema(
  {
    user: { type: mongoose.Schema.Types.ObjectId, ref: "Users" },
    rating: { type: Number, enum: [1, 2, 3, 4, 5] },
    comment: { type: String, trim: true },
    to_model: { type: String, trim: true, enum: ["Company", "Product"] },
    to: { type: mongoose.Schema.Types.ObjectId, refPath: "to_model" },
  },
  { timestamps: true }
);

const Rating = mongoose.model("Rating", rating_schema);

module.exports = Rating;
