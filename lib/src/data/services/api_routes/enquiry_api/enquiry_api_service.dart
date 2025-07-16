import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/services/api_service.dart';
import 'package:ipaconnect/src/data/utils/globals.dart';
import 'package:ipaconnect/src/data/models/enquiry_model.dart';

final enquiryApiServiceProvider = Provider<EnquiryApiService>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return EnquiryApiService(apiService);
});

final getEnquiriesProvider = FutureProvider.family<List<EnquiryModel>, Map<String, int>>((ref, params) async {
  final api = ref.read(enquiryApiServiceProvider);
  return api.getEnquiries(page: params['page']!, limit: params['limit']!);
});

class EnquiryApiService {
  final ApiService _apiService;
  EnquiryApiService(this._apiService);

  Future<bool> postEnquiry({
    required String name,
    required String phone,
    required String email,
    required String message,
  }) async {
    final response = await _apiService.post(
      '/enquiry',
      {
        'user': id,
        'name': name,
        'phone': phone,
        'email': email,
        'message': message,
      },
    );
    log(response.data.toString());
    return response.success;
  }

  Future<List<EnquiryModel>> getEnquiries({required int page, required int limit}) async {
    final response = await _apiService.get('/enquiry?page=$page&limit=$limit');
    if (response.success && response.data != null && response.data!['data'] is List) {
      return (response.data!['data'] as List)
          .map((e) => EnquiryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}
