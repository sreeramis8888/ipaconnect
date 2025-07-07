import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/models/business_category_model.dart';
import 'package:ipaconnect/src/data/models/chat_model.dart';
import 'package:ipaconnect/src/data/models/company_model.dart';
import 'package:ipaconnect/src/data/services/api_service.dart';
import 'package:ipaconnect/src/data/services/snackbar_service.dart';
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

  Future<List<CompanyModel>> getCompaniesByUserId({
    required String userId,
    int pageNo = 1,
    int limit = 10,
  }) async {
    String endpoint = '/company/user/$userId?page_no=$pageNo&limit=$limit';
    final response = await _apiService.get(endpoint);
    if (response.success && response.data != null) {
      final List<dynamic> data = response.data!['data'];
      return data.map((json) => CompanyModel.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  Future<bool> createCompany(Map<String, dynamic> data) async {
    SnackbarService snackbarService = SnackbarService();
    final response = await _apiService.post('/company', data);
    log(response.message.toString());
    if (response.success && response.data != null) {
      snackbarService.showSnackBar('Company Created Successfully');
      return true;
    } else {
      snackbarService.showSnackBar('Failed to Create Company');
      return false;
    }
  }

  Future<bool> updateCompany(String id, Map<String, dynamic> data) async {
    SnackbarService snackbarService = SnackbarService();
    final response = await _apiService.put('/company/$id', data);
    log(response.message.toString());
    if (response.success && response.data != null) {
      snackbarService.showSnackBar('Company Updated Successfully');
      return true;
    } else {
      snackbarService.showSnackBar('Failed to Update Company',
          type: SnackbarType.error);
      return false;
    }
  }

  Future<bool> deleteCompany(String id) async {
    SnackbarService snackbarService = SnackbarService();
    final response = await _apiService.delete('/company/$id');
    log(response.message.toString());
    if (response.success) {
      snackbarService.showSnackBar('Company Deleted Successfully');
      return true;
    } else {
      snackbarService.showSnackBar('Failed to Delete Company');
      return false;
    }
  }
}

@riverpod
Future<List<CompanyModel>> getCompanies(Ref ref,
    {int pageNo = 1, int limit = 10, String? categoryId}) async {
  final companyApiService = ref.watch(companyApiServiceProvider);
  return companyApiService.getCompanies(
      pageNo: pageNo, limit: limit, categoryId: categoryId);
}

@riverpod
Future<List<CompanyModel>> getCompaniesByUserId(Ref ref,
    {required String userId, int pageNo = 1, int limit = 10}) async {
  final companyApiService = ref.watch(companyApiServiceProvider);
  return companyApiService.getCompaniesByUserId(
      userId: userId, pageNo: pageNo, limit: limit);
}
