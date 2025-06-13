import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/models/events_model.dart';
import '../../../models/promotions_model.dart';
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
    try {
      final response = await _apiService.get('/events/user');
      final List<dynamic> data = response['data'] as List<dynamic>;
      return data.map((json) => EventsModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch events: $e');
    }
  }

  Future<EventsModel> getEventById(String id) async {
    try {
      final response = await _apiService.get('/events/$id');
      return EventsModel.fromJson(response['data']);
    } catch (e) {
      throw Exception('Failed to fetch events: $e');
    }
  }
}


@riverpod
Future<List<EventsModel>> events(Ref ref) async {
  final eventsService = ref.watch(eventsApiServiceProvider);
  return eventsService.getEvents();
}

@riverpod
Future<EventsModel> promotionById(Ref ref, String id) async {
  final eventsService = ref.watch(eventsApiServiceProvider);
  return eventsService.getEventById(id);
}