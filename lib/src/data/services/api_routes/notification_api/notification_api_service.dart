import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_api_service.g.dart';

@riverpod
NotificationApiService notificationApiService(Ref ref) {
  final apiService = ref.watch(apiServiceProvider);
  return NotificationApiService(apiService);
}

class NotificationApiService {
  final ApiService _apiService;

  NotificationApiService(this._apiService);

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

      log('Creating notification with data: $requestBody', name: 'Notification API');
      
      final response = await _apiService.post('/notifications', requestBody);

      log('Notification creation response: ${response.data}', name: 'Notification API');
      
      if (response.success && response.data != null) {
        return true;
      } else {
        log('Failed to create notification: ${response.message}', name: 'Notification API');
        return false;
      }
    } catch (e) {
      log('Error creating notification: $e', name: 'Notification API');
      return false;
    }
  }

  Future<bool> createNotificationForAllUsers({
    required String subject,
    required String content,
    List<String>? types,
    String? image,
    String? link,
    String? status,
    DateTime? sendDate,
  }) async {
    try {
      // Send to all users by passing "*" as the first user
      final Map<String, dynamic> requestBody = {
        'users': ['*'], // Backend will handle this to send to all users
        'subject': subject,
        'content': content,
        if (types != null && types.isNotEmpty) 'type': types,
        if (image != null && image.isNotEmpty) 'image': image,
        if (link != null && link.isNotEmpty) 'link': link,
        if (status != null && status.isNotEmpty) 'status': status,
        if (sendDate != null) 'send_date': sendDate.toIso8601String(),
      };

      log('Creating notification for all users with data: $requestBody', name: 'Notification API');
      
      final response = await _apiService.post('/notifications', requestBody);

      log('Notification creation response: ${response.data}', name: 'Notification API');
      
      if (response.success && response.data != null) {
        return true;
      } else {
        log('Failed to create notification: ${response.message}', name: 'Notification API');
        return false;
      }
    } catch (e) {
      log('Error creating notification: $e', name: 'Notification API');
      return false;
    }
  }

  // Helper method to get all users from hierarchies
  Future<List<String>> getUsersFromHierarchies(List<String> hierarchyIds) async {
    // This would need to be implemented based on your hierarchy structure
    // For now, returning empty list - you'll need to implement this based on your backend
    return [];
  }
} 