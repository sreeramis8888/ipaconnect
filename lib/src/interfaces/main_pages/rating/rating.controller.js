const response_handler = require("../../helpers/response_handler");
const Rating = require("./rating.model");
const validations = require("../../validations");

exports.create_rating = async (req, res) => {
  try {
    const create_rating_validator = validations.create_rating.validate(
      req.body,
      {
        abortEarly: true,
      }
    );
    if (create_rating_validator.error) {
      return response_handler(
        res,
        400,
        `Invalid input: ${create_rating_validator.error}`
      );
    }
    req.body.user = req.user_id;
    const rating = await Rating.create(req.body);
    return response_handler(res, 200, "Rating created successfully", rating);
  } catch (error) {
    return response_handler(res, 500, `Internal Server Error ${error.message}`);
  }
};

exports.get_ratings_by_entity = async (req, res) => {
  try {
    const { id } = req.params;
    if (!id) {
      return response_handler(res, 400, "Entity ID is required");
    }
    const { page, limit, entity } = req.query;
    const skip_count = limit * (page - 1);
    const filter = {
      to: id,
      to_model: entity,
    };
    const total_count = await Rating.countDocuments(filter);
    const ratings = await Rating.find(filter)
      .skip(skip_count)
      .limit(limit)
      .sort({ createdAt: -1, _id: -1 });
    return response_handler(
      res,
      200,
      "Ratings fetched successfully",
      ratings,
      total_count
    );
  } catch (error) {
    return response_handler(res, 500, `Internal Server Error ${error.message}`);
  }
};

exports.get_rating_by_id = async (req, res) => {
  try {
    const { id } = req.params;
    if (!id) {
      return response_handler(res, 400, "Rating ID is required");
    }
    const rating = await Rating.findById(id);
    return response_handler(res, 200, "Rating fetched successfully", rating);
  } catch (error) {
    return response_handler(res, 500, `Internal Server Error ${error.message}`);
  }
};

exports.update_rating = async (req, res) => {
  try {
    const { id } = req.params;
    if (!id) {
      return response_handler(res, 400, "Rating ID is required");
    }
    const rating = await Rating.findByIdAndUpdate(id, req.body, { new: true });
    return response_handler(res, 200, "Rating updated successfully", rating);
  } catch (error) {
    return response_handler(res, 500, `Internal Server Error ${error.message}`);
  }
};

exports.delete_rating = async (req, res) => {
  try {
    const { id } = req.params;
    if (!id) {
      return response_handler(res, 400, "Rating ID is required");
    }
    const rating = await Rating.findByIdAndDelete(id);
    return response_handler(res, 200, "Rating deleted successfully", rating);
  } catch (error) {
    return response_handler(res, 500, `Internal Server Error ${error.message}`);
  }
};
