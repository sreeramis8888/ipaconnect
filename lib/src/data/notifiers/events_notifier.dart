import 'dart:developer';
import 'package:ipaconnect/src/data/models/events_model.dart';
import 'package:ipaconnect/src/data/models/feed_model.dart';
import 'package:ipaconnect/src/data/services/api_routes/events_api/events_api.dart';
import 'package:ipaconnect/src/data/services/api_routes/feed_api/feed_api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'events_notifier.g.dart';

@riverpod
class EventsNotifier extends _$EventsNotifier {
  List<EventsModel> events = [];
  bool isLoading = false;
  bool isFirstLoad = true;
  int pageNo = 1;
  final int limit = 5;
  bool hasMore = true;

  @override
  List<EventsModel> build() {
    return [];
  }

  Future<void> fetchMoreEVents() async {
    if (isLoading || !hasMore) return;

    isLoading = true;

    try {
      final newEvents = await ref
          .read(fetchEventsProvider(pageNo: pageNo, limit: limit).future);

      if (newEvents.isEmpty) {
        hasMore = false;
      } else {
        events = [...events, ...newEvents];
        pageNo++;
        // Only set hasMore to false if we get fewer items than the limit
        hasMore = newEvents.length >= limit;
      }

      isFirstLoad = false;
      state = events;
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
    }
  }

  Future<void> refreshEvents() async {
    if (isLoading) return;

    isLoading = true;

    try {
      pageNo = 1;
      final refreshedEvents = await ref
          .read(fetchEventsProvider(pageNo: pageNo, limit: limit).future);

      events = refreshedEvents;
      hasMore = refreshedEvents.length >= limit;
      isFirstLoad = false;
      state = events;
      log('refreshed');
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
    }
  }

  Future<void> fetchMyCreatedEvents() async {
    if (isLoading) return;
    isLoading = true;
    try {
      pageNo = 1;
      final myCreatedEvents = await ref.read(fetchMyCreatedEventsProvider.future);
      events = myCreatedEvents;
      hasMore = false; // No pagination for my created events for now
      isFirstLoad = false;
      state = events;
      log('Fetched my created events');
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
    }
  }
}
