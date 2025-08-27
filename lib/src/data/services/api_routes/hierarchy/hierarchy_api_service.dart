import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/models/heirarchy_model.dart';
import 'package:ipaconnect/src/data/models/product_model.dart';
import 'package:ipaconnect/src/data/models/user_model.dart';
import '../../../models/promotions_model.dart';
import '../../api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'hierarchy_api_service.g.dart';

@riverpod
HierarchyApiService hierarchyApiService(Ref ref) {
  final apiService = ref.watch(apiServiceProvider);
  return HierarchyApiService(apiService);
}

class HierarchyApiService {
  final ApiService _apiService;

  HierarchyApiService(this._apiService);

  Future<List<HierarchyModel>> getHierarchy() async {
    final response = await _apiService.get('/hierarchy');

    if (response.success && response.data != null) {
      final List<dynamic> data = response.data!['data'];
      log(data.toString());
      return data.map((json) => HierarchyModel.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  Future<List<UserModel>> getHierarchyUsers(
      {required String hierarchyId,
      required int page,
      required int limit}) async {
    final response = await _apiService
        .get('/users/hierarchy/$hierarchyId?page_no=$page&limit=$limit');

    if (response.success && response.data != null) {
      final List<dynamic> data = response.data!['data'];

      return data.map((json) => UserModel.fromJson(json)).toList();
    } else {
      return [];
    }
  }
}

@riverpod
Future<List<HierarchyModel>> getHierarchy(
  Ref ref,
) async {
  final hierarchyApiService = ref.watch(hierarchyApiServiceProvider);
  return hierarchyApiService.getHierarchy();
}

@riverpod
Future<List<UserModel>> getHierarchyUsers(Ref ref,
    {required String hierarchyId,
    required int page,
    required int limit}) async {
  final hierarchyApiService = ref.watch(hierarchyApiServiceProvider);
  return hierarchyApiService.getHierarchyUsers(
      hierarchyId: hierarchyId, limit: limit, page: page);
}
