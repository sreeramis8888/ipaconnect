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


  Future<EventsModel> postEvent({
    required String eventName,
    required String description,
    required String type,
    required String image,
    required DateTime eventStartDate,
    required DateTime eventEndDate,
    required DateTime posterVisibilityStartDate,
    required DateTime posterVisibilityEndDate,
    required String organiserName,
    required int limit,
    required List<Map<String, dynamic>> speakers,
    String? platform,
    String? link,
    String? venue,
    List<String>? coordinators,
    String? status,
    List<String>? rsvp,
    List<String>? attendence,
    bool? isIpaOfficial,
    String? createdBy,
  }) async {
    // Build the request body, omitting nulls
    final Map<String, dynamic> data = {
      'event_name': eventName,
      'description': description,
      'type': type,
      'image': image,
      'event_start_date': eventStartDate.toIso8601String(),
      'event_end_date': eventEndDate.toIso8601String(),
      'poster_visibility_start_date': posterVisibilityStartDate.toIso8601String(),
      'poster_visibility_end_date': posterVisibilityEndDate.toIso8601String(),
      'organiser_name': organiserName,
      'limit': limit,
      'speakers': speakers,
    };
    if (platform != null && platform.isNotEmpty) data['platform'] = platform;
    if (link != null && link.isNotEmpty) data['link'] = link;
    if (venue != null && venue.isNotEmpty) data['venue'] = venue;
    if (coordinators != null && coordinators.isNotEmpty) data['coordinators'] = coordinators;
    if (status != null && status.isNotEmpty) data['status'] = status;
    if (rsvp != null && rsvp.isNotEmpty) data['rsvp'] = rsvp;
    if (attendence != null && attendence.isNotEmpty) data['attendence'] = attendence;
    if (isIpaOfficial != null) data['is_ipa_official'] = isIpaOfficial;
    if (createdBy != null && createdBy.isNotEmpty) data['created_by'] = createdBy;

    final response = await _apiService.post('/events', data);
    if (response.success && response.data != null && response.data!['data'] != null) {
      return EventsModel.fromJson(response.data!['data']);
    } else {
      SnackbarService().showSnackBar(
        response.message ?? 'Failed to create event',
        type: SnackbarType.error,
      );
      throw Exception(response.message ?? 'Failed to create event');
    }
  }

  Future<List<EventsModel>> fetchMyCreatedEvents() async {
    final response = await _apiService.get('/events?self_event=true');
    if (response.success && response.data != null) {
      final List<dynamic> data = response.data!['data'];
      return data.map((json) => EventsModel.fromJson(json)).toList();
    } else {
      SnackbarService().showSnackBar(
          response.message ?? 'Failed to fetch my created events',
          type: SnackbarType.error);
      throw Exception(response.message ?? 'Failed to fetch my created events');
    }
  }

  Future<EventsModel> updateEvent({
    required String eventId,
    required String eventName,
    required String description,
    required String type,
    required String image,
    required DateTime eventStartDate,
    required DateTime eventEndDate,
    required DateTime posterVisibilityStartDate,
    required DateTime posterVisibilityEndDate,
    required String organiserName,
    required int limit,
    required List<Map<String, dynamic>> speakers,
    String? platform,
    String? link,
    String? venue,
    List<String>? coordinators,
    String? status,
    List<String>? rsvp,
    List<String>? attendence,
    bool? isIpaOfficial,
    String? createdBy,
  }) async {
    // Build the request body, omitting nulls
    final Map<String, dynamic> data = {
      'event_name': eventName,
      'description': description,
      'type': type,
      'image': image,
      'event_start_date': eventStartDate.toIso8601String(),
      'event_end_date': eventEndDate.toIso8601String(),
      'poster_visibility_start_date': posterVisibilityStartDate.toIso8601String(),
      'poster_visibility_end_date': posterVisibilityEndDate.toIso8601String(),
      'organiser_name': organiserName,
      'limit': limit,
      'speakers': speakers,
    };
    if (platform != null && platform.isNotEmpty) data['platform'] = platform;
    if (link != null && link.isNotEmpty) data['link'] = link;
    if (venue != null && venue.isNotEmpty) data['venue'] = venue;
    if (coordinators != null && coordinators.isNotEmpty) data['coordinators'] = coordinators;
    if (status != null && status.isNotEmpty) data['status'] = status;
    if (rsvp != null && rsvp.isNotEmpty) data['rsvp'] = rsvp;
    if (attendence != null && attendence.isNotEmpty) data['attendence'] = attendence;
    if (isIpaOfficial != null) data['is_ipa_official'] = isIpaOfficial;
    if (createdBy != null && createdBy.isNotEmpty) data['created_by'] = createdBy;

    final response = await _apiService.put('/events/$eventId', data);
    if (response.success && response.data != null && response.data!['data'] != null) {
      return EventsModel.fromJson(response.data!['data']);
    } else {
      SnackbarService().showSnackBar(
        response.message ?? 'Failed to update event',
        type: SnackbarType.error,
      );
      throw Exception(response.message ?? 'Failed to update event');
    }
  }

  Future<bool> deleteEvent(String eventId) async {
    final response = await _apiService.delete('/events/$eventId');
    if (response.success) {
      SnackbarService().showSnackBar('Event deleted successfully');
      return true;
    } else {
      SnackbarService().showSnackBar(
        response.message ?? 'Failed to delete event',
        type: SnackbarType.error,
      );
      return false;
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

@riverpod
Future<List<EventsModel>> fetchMyCreatedEvents(FetchMyCreatedEventsRef ref) async {
  final eventsApiService = ref.watch(eventsApiServiceProvider);
  return eventsApiService.fetchMyCreatedEvents();
}
