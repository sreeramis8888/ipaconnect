const response_handler = require("../../helpers/response_handler");
const Store = require("./store.model");
const validations = require("../../validations");
const Order = require("./order.model");
const handle_stripe_customer = require("../../utils/handle_stripe_customer");
const stripe = require("../../config/stripe");
const Cart = require("./cart.model");

exports.get_stores = async (req, res) => {
  try {
    const { page_no = 1, limit = 10, search } = req.query;
    const skip_count = limit * (page_no - 1);
    const filter = {};
    if (search) {
      filter.name = { $regex: search, $options: "i" };
    }
    const total_count = await Store.countDocuments(filter);
    const stores = await Store.find(filter)
      .skip(skip_count)
      .limit(limit)
      .sort({ createdAt: -1, _id: -1 });
    return response_handler(
      res,
      200,
      "Stores fetched successfully",
      stores,
      total_count
    );
  } catch (error) {
    return response_handler(res, 500, `Internal Server Error ${error.message}`);
  }
};

exports.create_store = async (req, res) => {
  try {
    const create_store_validator = validations.create_store.validate(req.body, {
      abortEarly: true,
    });
    if (create_store_validator.error) {
      return response_handler(
        res,
        400,
        `${create_store_validator.error.details[0].message}`
      );
    }
    req.body.created_by = req.user_id;
    const store = await Store.create(req.body);
    return response_handler(res, 200, "Store created successfully", store);
  } catch (error) {
    return response_handler(res, 500, `Internal Server Error ${error.message}`);
  }
};

exports.get_store_by_id = async (req, res) => {
  try {
    const { id } = req.params;
    if (!id) {
      return response_handler(res, 400, "Store ID is required");
    }
    const store = await Store.findById(id);
    if (!store) {
      return response_handler(res, 400, "Store not found");
    }
    return response_handler(res, 200, "Store fetched successfully", store);
  } catch (error) {
    return response_handler(res, 500, `Internal Server Error ${error.message}`);
  }
};

exports.update_store = async (req, res) => {
  try {
    const { id } = req.params;
    if (!id) {
      return response_handler(res, 400, "Store ID is required");
    }
    const update_store_validator = validations.update_store.validate(req.body, {
      abortEarly: true,
    });
    if (update_store_validator.error) {
      return response_handler(
        res,
        400,
        `${update_store_validator.error.details[0].message}`
      );
    }
    const store = await Store.findByIdAndUpdate(id, req.body, {
      new: true,
    });
    if (!store) {
      return response_handler(res, 400, "Store not found");
    }
    return response_handler(res, 200, "Store updated successfully", store);
  } catch (error) {
    return response_handler(res, 500, `Internal Server Error ${error.message}`);
  }
};

exports.delete_store = async (req, res) => {
  try {
    const { id } = req.params;
    if (!id) {
      return response_handler(res, 400, "Store ID is required");
    }
    const store = await Store.findByIdAndDelete(id);
    if (!store) {
      return response_handler(res, 400, "Store not found");
    }
    return response_handler(res, 200, "Store deleted successfully", store);
  } catch (error) {
    return response_handler(res, 500, `Internal Server Error ${error.message}`);
  }
};

exports.get_store_categories = async (req, res) => {
  try {
    const store_categories = await Store.distinct("category");
    return response_handler(
      res,
      200,
      "Store categories fetched successfully",
      store_categories
    );
  } catch (error) {
    return response_handler(res, 500, `Internal Server Error ${error.message}`);
  }
};

exports.create_order = async (req, res) => {
  try {
    const create_order_validator = validations.create_order.validate(req.body, {
      abortEarly: true,
    });
    if (create_order_validator.error) {
      return response_handler(
        res,
        400,
        `${create_order_validator.error.details[0].message}`
      );
    }
    const customer_id = await handle_stripe_customer(req.user_id);
    const payment_intent = await stripe.paymentIntents.create({
      amount: req.body.amount * 100,
      currency: req.body.currency,
      customer: customer_id,
      metadata: {
        purpose: "order",
      },
    });
    req.body.payment_id = payment_intent.id;
    const cart = await Cart.findById(req.body.cart);
    if (!cart) {
      return response_handler(res, 400, "Cart not found");
    }
    if (cart.products.length === 0) {
      return response_handler(res, 400, "Cart is empty");
    }
    if (cart.products.length > 1) {
      for (let i = 0; i < cart.products.length; i++) {
        req.body.store = cart.products[i].store;
        req.body.quantity = cart.products[i].quantity;
        const product = await Store.findById(req.body.store).select("price");
        req.body.amount = product.price * req.body.quantity;
        await Order.create(req.body);
      }
    }
    return response_handler(res, 200, "Order created successfully");
  } catch (error) {
    return response_handler(res, 500, `Internal Server Error ${error.message}`);
  }
};

exports.add_to_cart = async (req, res) => {
  try {
    const { id } = req.params;
    if (!id) {
      return response_handler(res, 400, "Store ID is required");
    }
    const add_to_cart_validator = validations.add_to_cart.validate(req.body, {
      abortEarly: true,
    });
    if (add_to_cart_validator.error) {
      return response_handler(
        res,
        400,
        `${add_to_cart_validator.error.details[0].message}`
      );
    }
    const store = await Store.findById(id);
    if (!store) {
      return response_handler(res, 400, "Store not found");
    }
    let cart = await Cart.findOne({ user: req.user_id });
    if (!cart) {
      cart = await Cart.create({ user: req.user_id });
    }
    cart.products.push({ store: id, quantity: req.body.quantity });
    await cart.save();
    return response_handler(res, 200, "Product added to cart successfully");
  } catch (error) {
    return response_handler(res, 500, `Internal Server Error ${error.message}`);
  }
};

exports.remove_from_cart = async (req, res) => {
  try {
    const { id } = req.params;
    if (!id) {
      return response_handler(res, 400, "Cart ID is required");
    }
    const cart = await Cart.findById(id);
    if (!cart) {
      return response_handler(res, 400, "Cart not found");
    }
    cart.products = cart.products.filter((product) => product.store != id);
    await cart.save();
    return response_handler(res, 200, "Product removed from cart successfully");
  } catch (error) {
    return response_handler(res, 500, `Internal Server Error ${error.message}`);
  }
};

exports.increment_quantity = async (req, res) => {
  try {
    const { id } = req.params;
    if (!id) {
      return response_handler(res, 400, "Cart ID is required");
    }
    if (!req.body.store) {
      return response_handler(res, 400, "Store ID is required");
    }
    const cart = await Cart.findById(id);
    if (!cart) {
      return response_handler(res, 400, "Cart not found");
    }
    const product = cart.products.find(
      (product) => product.store == req.body.store
    );
    if (!product) {
      return response_handler(res, 400, "Product not found in cart");
    }
    product.quantity += 1;
    await cart.save();
    return response_handler(
      res,
      200,
      "Product quantity incremented successfully"
    );
  } catch (error) {
    return response_handler(res, 500, `Internal Server Error ${error.message}`);
  }
};

exports.decrement_quantity = async (req, res) => {
  try {
    const { id } = req.params;
    if (!id) {
      return response_handler(res, 400, "Cart ID is required");
    }
    if (!req.body.store) {
      return response_handler(res, 400, "Store ID is required");
    }
    const cart = await Cart.findById(id);
    if (!cart) {
      return response_handler(res, 400, "Cart not found");
    }
    const product = cart.products.find(
      (product) => product.store == req.body.store
    );
    if (!product) {
      return response_handler(res, 400, "Product not found in cart");
    }
    product.quantity -= 1;
    if (product.quantity <= 0) {
      cart.products = cart.products.filter(
        (product) => product.store != req.body.store
      );
    }
    await cart.save();
    return response_handler(
      res,
      200,
      "Product quantity decremented successfully"
    );
  } catch (error) {
    return response_handler(res, 500, `Internal Server Error ${error.message}`);
  }
};

exports.get_cart = async (req, res) => {
  try {
    const user = req.user_id;
    const cart = await Cart.findOne({ user: user }).populate("products.store");
    return response_handler(res, 200, "Cart fetched successfully", cart);
  } catch (error) {
    return response_handler(res, 500, `Internal Server Error ${error.message}`);
  }
};

exports.get_orders = async (req, res) => {
  try {
    const { page_no = 1, limit = 10 } = req.query;
    const skip_count = limit * (page_no - 1);
    const filter = {};
    if (!req.user.is_admin) {
      filter.user = req.user_id;
    }
    const total_count = await Order.countDocuments(filter);
    const orders = await Order.find(filter)
      .populate("user", "name image")
      .populate("store", "name image")
      .skip(skip_count)
      .limit(limit)
      .sort({ createdAt: -1, _id: -1 });
    const mapped_data = orders.map((order) => {
      return {
        ...order._doc,
        user_name: order.user.name,
        store_name: order.store.name,
      };
    });
    return response_handler(
      res,
      200,
      "Orders fetched successfully",
      mapped_data,
      total_count
    );
  } catch (error) {
    return response_handler(res, 500, `Internal Server Error ${error.message}`);
  }
};

exports.get_saved_shipping_address = async (req, res) => {
  try {
    const user = req.user_id;
    const shipping_address = await Order.find({
      user: user,
      "shipping_address.is_saved": true,
    });
    return response_handler(
      res,
      200,
      "Shipping address fetched successfully",
      shipping_address
    );
  } catch (error) {
    return response_handler(res, 500, `Internal Server Error ${error.message}`);
  }
};
