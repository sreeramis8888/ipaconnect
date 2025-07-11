import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/models/store_model.dart';
import 'package:ipaconnect/src/data/models/cart_model.dart';
import 'package:ipaconnect/src/data/models/order_model.dart';
import '../api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'store_api_service.g.dart';

@riverpod
StoreApiService storeApiService(Ref ref) {
  final apiService = ref.watch(apiServiceProvider);
  return StoreApiService(apiService);
}

class StoreApiService {
  final ApiService _apiService;

  StoreApiService(this._apiService);

  // Store Products
  Future<List<StoreModel>> getStoreProducts(
      {int pageNo = 1, int limit = 14, String? search}) async {
    String endpoint = '/store?page_no=$pageNo&limit=$limit';
    if (search != null && search.isNotEmpty) {
      endpoint += '&search=$search';
    }

    final response = await _apiService.get(endpoint);
    if (response.success && response.data != null) {
      final List<dynamic> data = response.data!['data'];
      return data.map((json) => StoreModel.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  Future<StoreModel?> getStoreById(String id) async {
    final response = await _apiService.get('/store/$id');
    if (response.success && response.data != null) {
      return StoreModel.fromJson(response.data!['data']);
    } else {
      return null;
    }
  }

  Future<List<String>> getStoreCategories() async {
    final response = await _apiService.get('/store/categories');
    if (response.success && response.data != null) {
      final List<dynamic> data = response.data!['data'];
      return data.map((category) => category.toString()).toList();
    } else {
      return [];
    }
  }

  // Cart Operations
  Future<CartModel?> getCart() async {
    final response = await _apiService.get('/store/cart');
    if (response.success && response.data != null) {
      return CartModel.fromJson(response.data!['data']);
    } else {
      return null;
    }
  }

  Future<bool> addToCart(String storeId, int quantity) async {
    final response = await _apiService.post('/store/add-to-cart/$storeId', {});
    log(response.message.toString());
    return response.success;
  }

  Future<bool> removeFromCart(String storeId) async {
    final response =
        await _apiService.post('/store/remove-from-cart/$storeId', {});
    return response.success;
  }

  Future<bool> incrementQuantity(String cartId, String storeId) async {
    final response =
        await _apiService.post('/store/increment-quantity/$cartId', {
      'store': storeId,
    });
    return response.success;
  }

  Future<bool> decrementQuantity(String cartId, String storeId) async {
    final response =
        await _apiService.post('/store/decrement-quantity/$cartId', {
      'store': storeId,
    });
    return response.success;
  }

  // Order Operations
  Future<List<OrderModel>> getOrders({int pageNo = 1, int limit = 10}) async {
    final response =
        await _apiService.get('/store/orders?page_no=$pageNo&limit=$limit');
    if (response.success && response.data != null) {
      final List<dynamic> data = response.data!['data'];
      return data.map((order) => OrderModel.fromJson(order)).toList();
    } else {
      return [];
    }
  }

  Future<bool> createOrder({
    required String cartId,
    required double amount,
    required String currency,
    required ShippingAddress shippingAddress,
  }) async {
    final response = await _apiService.post('/store/order', {
      'cart': cartId,
      'amount': amount,
      'currency': currency,
      'shipping_address': shippingAddress.toJson(),
    });
    return response.success;
  }

  // Address Operations
  Future<List<OrderModel>> getSavedShippingAddress() async {
    final response =
        await _apiService.get('/store/order/saved-shipping-address');
    if (response.success && response.data != null) {
      final List<dynamic> data = response.data!['data'];
      return data.map((address) => OrderModel.fromJson(address)).toList();
    } else {
      return [];
    }
  }

  // Store Management (Admin)
  Future<bool> createStore({
    required String name,
    required String category,
    required double price,
    required String description,
    String? image,
    String currency = 'USD',
  }) async {
    final response = await _apiService.post('/store', {
      'name': name,
      'category': category,
      'price': price,
      'description': description,
      'image': image,
      'currency': currency,
    });
    return response.success;
  }

  Future<bool> updateStore(String id, Map<String, dynamic> data) async {
    final response = await _apiService.put('/store/$id', data);
    return response.success;
  }

  Future<bool> deleteStore(String id) async {
    final response = await _apiService.delete('/store/$id');
    return response.success;
  }
}

@riverpod
Future<List<StoreModel>> getStoreProducts(Ref ref,
    {int pageNo = 1, int limit = 14, String? search}) async {
  final storeApiService = ref.watch(storeApiServiceProvider);
  return storeApiService.getStoreProducts(
      pageNo: pageNo, limit: limit, search: search);
}

@riverpod
Future<CartModel?> getCart(Ref ref) async {
  final storeApiService = ref.watch(storeApiServiceProvider);
  return storeApiService.getCart();
}

@riverpod
Future<List<OrderModel>> getOrders(Ref ref,
    {int pageNo = 1, int limit = 10}) async {
  final storeApiService = ref.watch(storeApiServiceProvider);
  return storeApiService.getOrders(pageNo: pageNo, limit: limit);
}

@riverpod
Future<List<String>> getStoreCategories(Ref ref) async {
  final storeApiService = ref.watch(storeApiServiceProvider);
  return storeApiService.getStoreCategories();
}

@riverpod
Future<List<OrderModel>> getSavedShippingAddress(Ref ref) async {
  final storeApiService = ref.watch(storeApiServiceProvider);
  return storeApiService.getSavedShippingAddress();
}
