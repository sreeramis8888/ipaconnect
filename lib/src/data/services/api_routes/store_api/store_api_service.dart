import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/models/store_model.dart';
import 'package:ipaconnect/src/data/models/cart_model.dart';
import 'package:ipaconnect/src/data/models/order_model.dart';
import '../../api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'store_api_service.g.dart';

@riverpod
StoreApiService storeApiService(Ref ref) {
  final apiService = ref.watch(apiServiceProvider);
  return StoreApiService(apiService);
}

class StoreApiService {
  final ApiService _apiService;
  final String _tag = '[StoreApiService]';

  StoreApiService(this._apiService);

  void _log(String message) {
    log('$_tag $message');
  }

  // Store Products
  Future<List<StoreModel>> getStoreProducts({
    int pageNo = 1,
    int limit = 14,
    String? search,
  }) async {
    String endpoint = '/store?page_no=$pageNo&limit=$limit';
    if (search != null && search.isNotEmpty) {
      endpoint += '&search=$search';
    }

    _log('GET $endpoint');
    try {
      final response = await _apiService.get(endpoint);
      _log('Response: ${response.success}, message: ${response.message}');

      if (response.success && response.data != null) {
        final List<dynamic> data = response.data!['data'];
        return data.map((json) => StoreModel.fromJson(json)).toList();
      }
    } catch (e, st) {
      _log('Error: $e\n$st');
    }
    return [];
  }

  Future<StoreModel?> getStoreById(String id) async {
    _log('GET /store/$id');
    try {
      final response = await _apiService.get('/store/$id');
      _log('Response: ${response.success}, message: ${response.message}');
      if (response.success && response.data != null) {
        return StoreModel.fromJson(response.data!['data']);
      }
    } catch (e, st) {
      _log('Error: $e\n$st');
    }
    return null;
  }

  Future<List<String>> getStoreCategories() async {
    _log('GET /store/categories');
    try {
      final response = await _apiService.get('/store/categories');
      _log('Response: ${response.success}, message: ${response.message}');
      if (response.success && response.data != null) {
        final List<dynamic> data = response.data!['data'];
        return data.map((e) => e.toString()).toList();
      }
    } catch (e, st) {
      _log('Error: $e\n$st');
    }
    return [];
  }

  // Cart Operations
  Future<CartModel?> getCart() async {
    _log('GET /store/cart');
    try {
      final response = await _apiService.get('/store/cart');
      _log('Response: ${response.success}, message: ${response.message}');
      if (response.success && response.data != null) {
        return CartModel.fromJson(response.data!['data']);
      }
    } catch (e, st) {
      _log('Error: $e\n$st');
    }
    return null;
  }

  Future<bool> addToCart(String storeId, int quantity) async {
    _log('POST /store/add-to-cart/$storeId');
    try {
      final response =
          await _apiService.post('/store/add-to-cart/$storeId', {});
      _log('Response: ${response.success}, message: ${response.message}');
      return response.success;
    } catch (e, st) {
      _log('Error: $e\n$st');
    }
    return false;
  }

  Future<bool> removeFromCart(String storeId) async {
    _log('POST /store/remove-from-cart/$storeId');
    try {
      final response =
          await _apiService.post('/store/remove-from-cart/$storeId', {});
      _log('Response: ${response.success}, message: ${response.message}');
      return response.success;
    } catch (e, st) {
      _log('Error: $e\n$st');
    }
    return false;
  }

  Future<bool> incrementQuantity(String cartId, String storeId) async {
    _log('POST /store/increment-quantity/$cartId');
    try {
      final response =
          await _apiService.post('/store/increment-quantity/$cartId', {
        'store': storeId,
      });
      _log('Response: ${response.success}, message: ${response.message}');
      return response.success;
    } catch (e, st) {
      _log('Error: $e\n$st');
    }
    return false;
  }

  Future<bool> decrementQuantity(String cartId, String storeId) async {
    _log('POST /store/decrement-quantity/$cartId');
    try {
      final response =
          await _apiService.post('/store/decrement-quantity/$cartId', {
        'store': storeId,
      });
      _log('Response: ${response.success}, message: ${response.message}');
      return response.success;
    } catch (e, st) {
      _log('Error: $e\n$st');
    }
    return false;
  }

  // Order Operations
  Future<List<OrderModel>> getOrders({int pageNo = 1, int limit = 10}) async {
    _log('GET /store/orders?page_no=$pageNo&limit=$limit');
    try {
      final response =
          await _apiService.get('/store/orders?page_no=$pageNo&limit=$limit');
      _log('Response: ${response.success}, message: ${response.message}');
      if (response.success && response.data != null) {
        final List<dynamic> data = response.data!['data'];
        return data.map((e) => OrderModel.fromJson(e)).toList();
      }
    } catch (e, st) {
      _log('Error: $e\n$st');
    }
    return [];
  }

  Future<dynamic> createOrder({
    required String cartId,
    required double amount,
    required String currency,
    required ShippingAddress shippingAddress,
  }) async {
    _log('POST /store/order with cartId: $cartId, amount: $amount');
    try {
      // Remove is_saved if null
      final shippingAddressMap = shippingAddress.toJson();
      if (shippingAddressMap['is_saved'] == null) {
        shippingAddressMap.remove('is_saved');
      }
      final response = await _apiService.post('/store/order', {
        'cart': cartId,
        'amount': amount,
        'currency': currency,
        'shipping_address': shippingAddressMap,
      });
      log('Address: [${shippingAddressMap}');
      _log(
          'Response:  [${response.success}, message:  [${response.message},data:   [${response.data}');
      return response.data; // Return the data field (should contain payment_intent)
    } catch (e, st) {
      _log('Error: $e\n$st');
    }
    return null;
  }

  // Saved Addresses
  Future<List<ShippingAddress>> getSavedShippingAddress() async {
    _log('GET /store/order/saved-shipping-address');
    try {
      final response =
          await _apiService.get('/store/order/saved-shipping-address');
      _log('Response: ${response.success}, message: ${response.message}');
      if (response.success && response.data != null) {
        final List<dynamic> data = response.data!['data'];
        return data.map((e) => ShippingAddress.fromJson(e)).toList();
      }
    } catch (e, st) {
      _log('Error: $e\n$st');
    }
    return [];
  }

  Future<bool> updateStore(String id, Map<String, dynamic> data) async {
    _log('PUT /store/$id with data: $data');
    try {
      final response = await _apiService.put('/store/$id', data);
      _log('Response: ${response.success}, message: ${response.message}');
      return response.success;
    } catch (e, st) {
      _log('Error: $e\n$st');
    }
    return false;
  }

  Future<bool> deleteStore(String id) async {
    _log('DELETE /store/$id');
    try {
      final response = await _apiService.delete('/store/$id');
      _log('Response: ${response.success}, message: ${response.message}');
      return response.success;
    } catch (e, st) {
      _log('Error: $e\n$st');
    }
    return false;
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
Future<List<ShippingAddress>> getSavedShippingAddress(Ref ref) async {
  final storeApiService = ref.watch(storeApiServiceProvider);
  return storeApiService.getSavedShippingAddress();
}
