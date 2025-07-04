import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/models/business_category_model.dart';
import 'package:ipaconnect/src/data/models/chat_model.dart';
import 'package:ipaconnect/src/data/models/company_model.dart';
import 'package:ipaconnect/src/data/services/api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'company_api_service.g.dart';

@riverpod
CompanyApiService companyApiService(Ref ref) {
  final apiService = ref.watch(apiServiceProvider);
  return CompanyApiService(apiService);
}

class CompanyApiService {
  final ApiService _apiService;

  CompanyApiService(this._apiService);
Future<List<CompanyModel>> getCompanies({
  int pageNo = 1,
  int limit = 10,
  String? categoryId,
}) async {
  String endpoint = categoryId != null
      ? '/company/category/$categoryId?page_no=$pageNo&limit=$limit'
      : '/company?page_no=$pageNo&limit=$limit';

  final response = await _apiService.get(endpoint);

  if (response.success && response.data != null) {
    final List<dynamic> data = response.data!['data'];
    return data.map((json) => CompanyModel.fromJson(json)).toList();
  } else {
    return [];
  }
}

}

@riverpod
Future<List<CompanyModel>> getCompanies(Ref ref,
    {int pageNo = 1, int limit = 10, String? categoryId}) async {
  final companyApiService = ref.watch(companyApiServiceProvider);
  return companyApiService.getCompanies(pageNo: pageNo, limit: limit,categoryId: categoryId);
}
