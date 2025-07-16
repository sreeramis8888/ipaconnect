import 'dart:developer';
import 'package:ipaconnect/src/data/models/enquiry_model.dart';
import 'package:ipaconnect/src/data/services/api_routes/enquiry_api/enquiry_api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'enquiry_notifier.g.dart';

@riverpod
class EnquiryNotifier extends _$EnquiryNotifier {
  List<EnquiryModel> enquiries = [];
  bool isLoading = false;
  bool isFirstLoad = true;
  int pageNo = 1;
  final int limit = 10;
  bool hasMore = true;

  @override
  List<EnquiryModel> build() {
    return [];
  }

  Future<void> fetchMoreEnquiries() async {
    if (isLoading || !hasMore) return;
    isLoading = true;
    try {
      final newEnquiries = await ref.read(getEnquiriesProvider({'page': pageNo, 'limit': limit}).future);
      if (newEnquiries.isEmpty) {
        hasMore = false;
      } else {
        enquiries = [...enquiries, ...newEnquiries];
        pageNo++;
        hasMore = newEnquiries.length >= limit;
      }
      isFirstLoad = false;
      state = enquiries;
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
    }
  }

  Future<void> refreshEnquiries() async {
    if (isLoading) return;
    isLoading = true;
    try {
      pageNo = 1;
      final refreshed = await ref.read(getEnquiriesProvider({'page': pageNo, 'limit': limit}).future);
      enquiries = refreshed;
      hasMore = refreshed.length >= limit;
      isFirstLoad = false;
      state = enquiries;
      log('refreshed');
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
    }
  }
} 