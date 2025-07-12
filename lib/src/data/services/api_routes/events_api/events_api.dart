import 'dart:convert';
import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/models/attendance_user_model.dart';
import 'package:ipaconnect/src/data/models/events_model.dart';
import 'package:ipaconnect/src/data/services/api_service.dart';
import 'package:ipaconnect/src/data/services/snackbar_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'events_api.g.dart';

@riverpod
EventsApiService eventsApiService(Ref ref) {
  final apiService = ref.watch(apiServiceProvider);
  return EventsApiService(apiService);
}

class EventsApiService {
  final ApiService _apiService;
  EventsApiService(this._apiService);

  Future<EventsModel> fetchEventById(String id) async {
    final response = await _apiService.get('/events/single/$id');
    if (response.success && response.data != null) {
      final dynamic data = response.data!['data'];
      return EventsModel.fromJson(data);
    } else {
      SnackbarService().showSnackBar(
          response.message ?? 'Failed to fetch event',
          type: SnackbarType.error);
      throw Exception(response.message ?? 'Failed to fetch event');
    }
  }

  Future<AttendanceUserListModel> fetchEventAttendance(String eventId) async {
    final response = await _apiService.get('/events/attend/$eventId');
    if (response.success && response.data != null) {
      final dynamic data = response.data!['data'];
      return AttendanceUserListModel.fromJson(data);
    } else {
      SnackbarService().showSnackBar(
          response.message ?? 'Failed to fetch attendance',
          type: SnackbarType.error);
      throw Exception(response.message ?? 'Failed to fetch attendance');
    }
  }

  Future<List<EventsModel>> fetchMyEvents() async {
    final response = await _apiService.get('/events/registered-events');
    if (response.success && response.data != null) {
      final List<dynamic> data = response.data!['data'];
      return data.map((json) => EventsModel.fromJson(json)).toList();
    } else {
      SnackbarService().showSnackBar(
          response.message ?? 'Failed to fetch my events',
          type: SnackbarType.error);
      throw Exception(response.message ?? 'Failed to fetch my events');
    }
  }

  Future<void> markEventAsRSVP(String eventId) async {
    final response = await _apiService.patch('/events/$eventId', null);
    if (response.success) {
      SnackbarService().showSnackBar('Event Registered successfully');
    } else {
      SnackbarService().showSnackBar(response.message ?? 'Failed to mark RSVP',
          type: SnackbarType.error);
      throw Exception(response.message ?? 'Failed to register ');
    }
  }

  Future<AttendanceUserModel?> markAttendanceEvent({
    required String eventId,
    required String userId,
  }) async {
    final response =
        await _apiService.post('/events/attend/$eventId', {'userId': userId});
    if (response.success && response.data != null) {
      final dynamic data = response.data!['data'];
      return AttendanceUserModel.fromJson(data);
    } else {
      SnackbarService().showSnackBar(
          response.message ?? 'Failed to mark attendance',
          type: SnackbarType.error);
      return null;
    }
  }

  Future<List<EventsModel>> fetchEventsPaginated(
      {required int page, required int limit}) async {
    final response =
        await _apiService.get('/events?page_no=$page&limit=$limit');
    if (response.success && response.data != null) {
      final List<dynamic> data = response.data!['data'];
      return data.map((json) => EventsModel.fromJson(json)).toList();
    } else {
      SnackbarService().showSnackBar(
          response.message ?? 'Failed to fetch events',
          type: SnackbarType.error);
      return [];
    }
  }
}

@riverpod
Future<List<EventsModel>> fetchEvents(Ref ref,
    {int pageNo = 1, int limit = 10}) async {
  final eventsApiService = ref.watch(eventsApiServiceProvider);
  return eventsApiService.fetchEventsPaginated(page: pageNo, limit: limit);
}

@riverpod
Future<EventsModel> fetchEventById(FetchEventByIdRef ref,
    {required String id}) async {
  final eventsApiService = ref.watch(eventsApiServiceProvider);
  return eventsApiService.fetchEventById(id);
}

@riverpod
Future<AttendanceUserListModel> fetchEventAttendance(
    FetchEventAttendanceRef ref,
    {required String eventId}) async {
  final eventsApiService = ref.watch(eventsApiServiceProvider);
  return eventsApiService.fetchEventAttendance(eventId);
}

@riverpod
Future<List<EventsModel>> fetchMyEvents(FetchMyEventsRef ref) async {
  final eventsApiService = ref.watch(eventsApiServiceProvider);
  return eventsApiService.fetchMyEvents();
}
