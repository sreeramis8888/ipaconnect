import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:ipaconnect/src/data/models/campaign_model.dart';
import 'package:ipaconnect/src/data/services/snackbar_service.dart';
import 'package:ipaconnect/src/data/services/api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
part 'campaign_api.g.dart';

class CampaignApiService {
  final ApiService apiService;
  final SnackbarService snackbarService;

  CampaignApiService(
      {required this.apiService, SnackbarService? snackbarService})
      : snackbarService = snackbarService ?? SnackbarService();

  Future<List<CampaignModel>> fetchCampaigns(   {required int page, required int limit}) async {
    try {
      final response = await apiService.get('/campaign');
      final decoded = response.data;
      if (response.success && response.statusCode == 200) {
        final List<dynamic> data = decoded?['data'] ?? [];
        return data.map((e) => CampaignModel.fromJson(e)).toList();
      } else {
        throw Exception(decoded?['message'] ??
            response.message ??
            'Failed to fetch campaigns');
      }
    } catch (e) {
      log(e.toString(), name: 'CAMPAIGN FETCH FAILED');
      return [];
    }
  }

}

@riverpod
CampaignApiService campaignApiService(Ref ref) {
  final apiService = ref.watch(apiServiceProvider);
  return CampaignApiService(apiService: apiService);
}

@riverpod
Future<List<CampaignModel>> fetchCampaigns(Ref ref, {int pageNo = 1, int limit = 10}) {
  final campaignApi = ref.watch(campaignApiServiceProvider);
  return campaignApi.fetchCampaigns(page:  pageNo, limit: limit);
}

