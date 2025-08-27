import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/models/product_model.dart';
import 'package:ipaconnect/src/data/utils/remove_nulls.dart';
import '../../../models/promotions_model.dart';
import '../../api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'products_api_service.g.dart';

@riverpod
ProductsApiService productsApiService(Ref ref) {
  final apiService = ref.watch(apiServiceProvider);
  return ProductsApiService(apiService);
}

class ProductsApiService {
  final ApiService _apiService;

  ProductsApiService(this._apiService);

  Future<List<ProductModel>> getProducts({
    required String companyId,
    String? query,
    int pageNo = 1,
    int limit = 10,
  }) async {
    Map<String, String> queryParams = {
      'page_no': pageNo.toString(),
      'limit': limit.toString(),
    };
    if (query != null && query.isNotEmpty) {
      queryParams['search'] = query;
    }
    final response = await _apiService.get(
        '/product?company=$companyId&${Uri(queryParameters: queryParams).query}&status=approved');

    if (response.success && response.data != null) {
      final List<dynamic> data = response.data!['data'];
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  Future<List<ProductModel>> getProductsForUser({
    required String companyId,
    String? query,
    int pageNo = 1,
    int limit = 10,
  }) async {
    Map<String, String> queryParams = {
      'page_no': pageNo.toString(),
      'limit': limit.toString(),
    };
    if (query != null && query.isNotEmpty) {
      queryParams['search'] = query;
    }
    final response = await _apiService.get(
        '/product/for-user?company=$companyId&${Uri(queryParameters: queryParams).query}');

    if (response.success && response.data != null) {
      final List<dynamic> data = response.data!['data'];
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      return [];
    }
  }
Future<bool?> postProduct({
  required String companyId,
  required String name,
  required List<String> specifications,
  required double actualPrice,
  required double discountPrice,
  required List<String> imageUrls,
  required List<String> tags,
  required bool isPublic,
}) async {
  Map<String, dynamic> body = {
    'company': companyId,
    'name': name,
    'specifications': specifications,
    'actual_price': actualPrice,
    'discount_price': discountPrice,
    'images': imageUrls.map((url) => {'url': url}).toList(),
    'tags': tags,
    'is_public': isPublic,
  };

  body = cleanMap(body); 

  final response = await _apiService.post('/product', body);
  log(response.message.toString());
  log(response.data.toString());

  return response.success;
}


  Future<bool> deleteProduct(String productId) async {
    final response = await _apiService.delete('/product/$productId');
    log(response.message.toString());
    log(response.data.toString());
    return response.success;
  }

  Future<bool?> updateProduct({
    required String productId,
    required String companyId,
    required String name,
    required List<String> specifications,
    required double actualPrice,
    required double discountPrice,
    required List<String> imageUrls,
    required List<String> tags,
    required bool isPublic,
  }) async {
    final body = {
      'company': companyId,
      'name': name,
      'specifications': specifications,
      'actual_price': actualPrice,
      'discount_price': discountPrice,
      'images': imageUrls.map((url) => {'url': url}).toList(),
      'tags': tags,
      'is_public': isPublic,
    };
    final response = await _apiService.put('/product/$productId', body);
    log(response.message.toString());
    log(response.data.toString());
    if (response.success && response.data != null) {
      return response.success;
    } else {
      return response.success;
    }
  }

  // Future<Promotion> getProducsById(String id) async {
  //   final response = await _apiService.get('/promotions/$id');

  //   if (response.success && response.data != null) {
  //     return Promotion.fromJson(response.data!['data']);
  //   } else {
  //     throw Exception(response.message ?? 'Failed to fetch promotion');
  //   }
  // }
}

@riverpod
Future<List<ProductModel>> getProducts(Ref ref,
    {int pageNo = 1,
    int limit = 10,
    required String companyId,
    String? query}) async {
  final productsApiService = ref.watch(productsApiServiceProvider);
  return productsApiService.getProducts(
    companyId: companyId,
    query: query,
    pageNo: pageNo,
    limit: limit,
  );
}

@riverpod
Future<List<ProductModel>> getProductsForUser(Ref ref,
    {int pageNo = 1,
    int limit = 10,
    required String companyId,
    String? query}) async {
  final productsApiService = ref.watch(productsApiServiceProvider);
  return productsApiService.getProductsForUser(
    companyId: companyId,
    query: query,
    pageNo: pageNo,
    limit: limit,
  );
}

// @riverpod
// Future<Promotion> promotionById(Ref ref, String id) async {
//   final promotionsService = ref.watch(promotionsApiServiceProvider);
//   return promotionsService.getPromotionById(id);
// }
