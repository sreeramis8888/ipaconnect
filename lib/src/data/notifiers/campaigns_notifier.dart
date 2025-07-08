import 'dart:developer';
import 'package:ipaconnect/src/data/models/campaign_model.dart';
import 'package:ipaconnect/src/data/models/events_model.dart';
import 'package:ipaconnect/src/data/models/feed_model.dart';
import 'package:ipaconnect/src/data/services/api_routes/campain_api/campaign_api.dart';
import 'package:ipaconnect/src/data/services/api_routes/events_api/events_api.dart';
import 'package:ipaconnect/src/data/services/api_routes/feed_api/feed_api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'campaigns_notifier.g.dart';

@riverpod
class CampaignsNotifier extends _$CampaignsNotifier {
  List<CampaignModel> campaigns = [];
  bool isLoading = false;
  bool isFirstLoad = true;
  int pageNo = 1;
  final int limit = 5;
  bool hasMore = true;

  @override
  List<CampaignModel> build() {
    return [];
  }

  Future<void> fetchMoreCampaigns() async {
    if (isLoading || !hasMore) return;

    isLoading = true;

    try {
      final newCampaigns = await ref
          .read(fetchCampaignsProvider(pageNo: pageNo, limit: limit).future);

      if (newCampaigns.isEmpty) {
        hasMore = false;
      } else {
        campaigns = [...campaigns, ...newCampaigns];
        pageNo++;
        // Only set hasMore to false if we get fewer items than the limit
        hasMore = newCampaigns.length >= limit;
      }

      isFirstLoad = false;
      state = campaigns;
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
    }
  }

  Future<void> refreshCampaigns() async {
    if (isLoading) return;

    isLoading = true;

    try {
      pageNo = 1;
      final refreshedCampaigns = await ref
          .read(fetchCampaignsProvider(pageNo: pageNo, limit: limit).future);

      campaigns = refreshedCampaigns;
      hasMore = refreshedCampaigns.length >= limit;
      isFirstLoad = false;
      state = campaigns;
      log('refreshed');
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
    }
  }
}
