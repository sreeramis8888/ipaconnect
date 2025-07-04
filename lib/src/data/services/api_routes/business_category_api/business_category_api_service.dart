import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/models/business_category_model.dart';
import 'package:ipaconnect/src/data/models/chat_model.dart';
import 'package:ipaconnect/src/data/services/api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'business_category_api_service.g.dart';

@riverpod
BusinesscategoryApiService businessCategoryApiService(Ref ref) {
  final apiService = ref.watch(apiServiceProvider);
  return BusinesscategoryApiService(apiService);
}

class BusinesscategoryApiService {
  final ApiService _apiService;

  BusinesscategoryApiService(this._apiService);

  Future<List<BusinessCategoryModel>> getBusinessCategories(
      {int pageNo = 1, int limit = 10}) async {
    final response = await _apiService
        .get('/category?page_no=$pageNo&limit=$limit');

    if (response.success && response.data != null) {
      final List<dynamic> data = response.data!['data'];
      return data.map((json) => BusinessCategoryModel.fromJson(json)).toList();
    } else {
      return [];
    }
  }
}

@riverpod
Future<List<BusinessCategoryModel>> getBusinessCategories(Ref ref,
    {int pageNo = 1, int limit = 10}) async {
  final businessCategoryApiService = ref.watch(businessCategoryApiServiceProvider);
  return businessCategoryApiService.getBusinessCategories(pageNo: pageNo, limit: limit);
}
