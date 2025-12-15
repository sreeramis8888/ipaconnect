import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/models/notification_model.dart';
import '../../api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_api_service.g.dart';

@riverpod
NotificationApiService notificationApiService(Ref ref) {
  final apiService = ref.watch(apiServiceProvider);
  return NotificationApiService(apiService);
}

@riverpod
Future<List<NotificationModel>> fetchNotifications(Ref ref) async {
  final service = ref.watch(notificationApiServiceProvider);
  return service.fetchNotifications(
    markRead: false,
    includeRead: false,
    limit: 10,
    pageNo: 1,
  );
}

class NotificationApiService {
  final ApiService _apiService;

  NotificationApiService(this._apiService);
  Future<List<NotificationModel>> fetchNotifications({
    bool markRead = false,
    bool includeRead = false,
    int limit = 10,
    int pageNo = 1,
  }) async {
    try {
      // Build query parameters
      final queryParams = <String, String>{
        'mark_read': markRead.toString(),
        'include_read': includeRead.toString(),
        'limit': limit.toString(),
        'page_no': pageNo.toString(),
      };

      // Build URL with query parameters
      final queryString = queryParams.entries
          .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
          .join('&');
      final url = '/notifications/user?$queryString';

      log('Fetching notifications with params: $queryString',
          name: 'Notification API');

      final response = await _apiService.get(url);
      if (response.success && response.data != null) {
        final List<dynamic> data = response.data!['data'];
        List<NotificationModel> notifications = [];
        for (var item in data) {
          notifications.add(NotificationModel.fromJson(item));
        }
        return notifications;
      } else {
        final message = response.message ?? 'Failed to fetch notifications';
        throw Exception(message);
      }
    } catch (e) {
      log('Error fetching notifications: $e', name: 'Notification API');
      rethrow;
    }
  }

  Future<bool> createNotification({
    required List<String> userIds,
    required String subject,
    required String content,
    List<String>? types,
    String? image,
    String? link,
    String? status,
    DateTime? sendDate,
  }) async {
    try {
      // Prepare the request body according to backend schema
      final Map<String, dynamic> requestBody = {
        'users': userIds,
        'subject': subject,
        'content': content,
        if (types != null && types.isNotEmpty) 'type': types,
        if (image != null && image.isNotEmpty) 'image': image,
        if (link != null && link.isNotEmpty) 'link': link,
        if (status != null && status.isNotEmpty) 'status': status,
        if (sendDate != null) 'send_date': sendDate.toIso8601String(),
      };

      log('Creating notification with data: $requestBody',
          name: 'Notification API');

      final response = await _apiService.post('/notifications', requestBody);

      log('Notification creation response: ${response.data}',
          name: 'Notification API');

      if (response.success && response.data != null) {
        return true;
      } else {
        log('Failed to create notification: ${response.message}',
            name: 'Notification API');
        return false;
      }
    } catch (e) {
      log('Error creating notification: $e', name: 'Notification API');
      return false;
    }
  }

  Future<bool> sendNotifcationToHierarchy({
    required String subject,
    required String content,
    List<String>? types,
    String? image,
    String? link,
    String? status,
    DateTime? sendDate,
  }) async {
    try {
      final Map<String, dynamic> requestBody = {
        'users': ['*'],
        'subject': subject,
        'content': content,
        if (types != null && types.isNotEmpty) 'type': types,
        if (image != null && image.isNotEmpty) 'image': image,
        if (link != null && link.isNotEmpty) 'link': link,
        if (status != null && status.isNotEmpty) 'status': status,
        if (sendDate != null) 'send_date': sendDate.toIso8601String(),
      };

      log('Creating notification for all users with data: $requestBody',
          name: 'Notification API');

      final response = await _apiService.post('/notifications', requestBody);

      log('Notification creation response: ${response.data}',
          name: 'Notification API');

      if (response.success && response.data != null) {
        return true;
      } else {
        log('Failed to create notification: ${response.message}',
            name: 'Notification API');
        return false;
      }
    } catch (e) {
      log('Error creating notification: $e', name: 'Notification API');
      return false;
    }
  }

  /// Delete a notification by ID
  Future<bool> deleteNotification(String notificationId) async {
    try {
      if (notificationId.isEmpty) {
        log('Notification ID cannot be empty', name: 'Notification API');
        return false;
      }

      log('Deleting notification with ID: $notificationId',
          name: 'Notification API');

      final response =
          await _apiService.delete('/notifications/$notificationId');

      if (response.success) {
        log('Notification deleted successfully', name: 'Notification API');
        return true;
      } else {
        log('Failed to delete notification: ${response.message}',
            name: 'Notification API');
        return false;
      }
    } catch (e) {
      log('Error deleting notification: $e', name: 'Notification API');
      return false;
    }
  }

  /// Mark notifications as read using the fetch method with mark_read parameter
  /// This leverages the backend's built-in mark as read functionality
  Future<List<NotificationModel>> fetchAndMarkAsRead({
    bool includeRead = false,
    int limit = 10,
    int pageNo = 1,
  }) async {
    try {
      // Build query parameters with mark_read set to true
      final queryParams = <String, String>{
        'mark_read': 'true', // Automatically mark as read
        'include_read': includeRead.toString(),
        'limit': limit.toString(),
        'page_no': pageNo.toString(),
      };

      // Build URL with query parameters
      final queryString = queryParams.entries
          .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
          .join('&');
      final url = '/notifications/user?$queryString';

      log('Fetching and marking notifications as read with params: $queryString',
          name: 'Notification API');

      final response = await _apiService.get(url);
      if (response.success && response.data != null) {
        final List<dynamic> data = response.data!['data'];
        List<NotificationModel> notifications = [];
        for (var item in data) {
          notifications.add(NotificationModel.fromJson(item));
        }
        log('Notifications fetched and marked as read successfully',
            name: 'Notification API');
        return notifications;
      } else {
        final message = response.message ?? 'Failed to fetch notifications';
        throw Exception(message);
      }
    } catch (e) {
      log('Error fetching and marking notifications as read: $e',
          name: 'Notification API');
      rethrow;
    }
  }
}
