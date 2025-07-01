import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/models/events_model.dart';
import '../../api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'events_api_service.g.dart';

@riverpod
EventsApiService eventsApiService(Ref ref) {
  final apiService = ref.watch(apiServiceProvider);
  return EventsApiService(apiService);
}

class EventsApiService {
  final ApiService _apiService;

  EventsApiService(this._apiService);

  Future<List<EventsModel>> getEvents() async {
    final response = await _apiService.get('/events/user');

    if (response.success && response.data != null) {
      final List<dynamic> data = response.data!['data'];
      return data.map((json) => EventsModel.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  Future<EventsModel?> getEventById(String id) async {
    final response = await _apiService.get('/events/$id');

    if (response.success && response.data != null) {
      return EventsModel.fromJson(response.data!['data']);
    } else {
      return null;
    }
  }
}

@riverpod
Future<List<EventsModel>> events(Ref ref) async {
  final eventsService = ref.watch(eventsApiServiceProvider);
  return eventsService.getEvents();
}

@riverpod
Future<EventsModel?> eventById(Ref ref, String id) async {
  final eventsService = ref.watch(eventsApiServiceProvider);
  return eventsService.getEventById(id);
}
