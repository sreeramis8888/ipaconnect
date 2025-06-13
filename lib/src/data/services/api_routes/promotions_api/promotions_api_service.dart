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
    try {
      final response = await _apiService.get('/promotions/user');
      final List<dynamic> data = response['data'] as List<dynamic>;
      return data.map((json) => Promotion.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch promotions: $e');
    }
  }

  Future<Promotion> getPromotionById(String id) async {
    try {
      final response = await _apiService.get('/promotions/$id');
      return Promotion.fromJson(response['data']);
    } catch (e) {
      throw Exception('Failed to fetch promotion: $e');
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