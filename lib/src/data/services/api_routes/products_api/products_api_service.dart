import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/models/product_model.dart';
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

  Future<List<ProductModel>> getProducts({required String companyId}) async {
    final response = await _apiService.get('/product?company=$companyId');

    if (response.success && response.data != null) {
      final List<dynamic> data = response.data!['data'];
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  Future<ProductModel?> postProduct({
    required String userId,
    required String userName,
    required String companyId,
    required String name,
    required String description,
    required double actualPrice,
    required double discountPrice,
    required List<String> imageUrls,
    required List<String> tags,
    required bool isPublic,
    required String status,
  }) async {
    final body = {
      'user': {
        '_id': userId,
        'name': userName,
      },
      'company': companyId,
      'name': name,
      'description': description,
      'actual_price': actualPrice,
      'discount_price': discountPrice,
      'images': imageUrls.map((url) => {'url': url}).toList(),
      'tags': tags,
      'is_public': isPublic,
      'status': status,
    };
    final response = await _apiService.post('/product', body);
    if (response.success && response.data != null) {
      return ProductModel.fromJson(response.data!['data']);
    } else {
      return null;
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
    {int pageNo = 1, int limit = 10, required String companyId}) async {
  final productsApiService = ref.watch(productsApiServiceProvider);
  return productsApiService.getProducts(companyId: companyId);
}

// @riverpod
// Future<Promotion> promotionById(Ref ref, String id) async {
//   final promotionsService = ref.watch(promotionsApiServiceProvider);
//   return promotionsService.getPromotionById(id);
// }
