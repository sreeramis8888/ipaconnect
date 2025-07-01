import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/promotions_model.dart';
import '../../api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'promotions_api_service.g.dart';

@riverpod
PromotionsApiService promotionsApiService(Ref ref) {
  final apiService = ref.watch(apiServiceProvider);
  return PromotionsApiService(apiService);
}

class PromotionsApiService {
  final ApiService _apiService;

  PromotionsApiService(this._apiService);

  Future<List<Promotion>> getPromotions() async {
    final response = await _apiService.get('/promotions/user');

    if (response.success && response.data != null) {
      final List<dynamic> data = response.data!['data'];
      return data.map((json) => Promotion.fromJson(json)).toList();
    } else {
      throw Exception(response.message ?? 'Failed to fetch promotions');
    }
  }

  Future<Promotion> getPromotionById(String id) async {
    final response = await _apiService.get('/promotions/$id');

    if (response.success && response.data != null) {
      return Promotion.fromJson(response.data!['data']);
    } else {
      throw Exception(response.message ?? 'Failed to fetch promotion');
    }
  }
}

@riverpod
Future<List<Promotion>> promotions(Ref ref) async {
  final promotionsService = ref.watch(promotionsApiServiceProvider);
  return promotionsService.getPromotions();
}

@riverpod
Future<Promotion> promotionById(Ref ref, String id) async {
  final promotionsService = ref.watch(promotionsApiServiceProvider);
  return promotionsService.getPromotionById(id);
}
