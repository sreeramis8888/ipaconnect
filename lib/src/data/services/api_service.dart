import 'dart:convert';
import 'dart:developer';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_service.g.dart';

class ApiResponse<T> {
  final bool success;
  final T? data;
  final int? statusCode;
  final String? message;

  ApiResponse({
    required this.success,
    this.data,
    this.statusCode,
    this.message,
  });

  factory ApiResponse.success(T data, [int? statusCode]) {
    return ApiResponse(success: true, data: data, statusCode: statusCode);
  }

  factory ApiResponse.error(String message, [int? statusCode]) {
    return ApiResponse(
        success: false, message: message, statusCode: statusCode);
  }
}

class ApiService {
  final String baseUrl;
  final http.Client _client;

  ApiService({
    required this.baseUrl,
    http.Client? client,
  }) : _client = client ?? http.Client();

  Future<ApiResponse<Map<String, dynamic>>> get(String endpoint) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      log(name: 'HITTING API','$baseUrl$endpoint');
      final decoded = json.decode(response.body);

      if (response.statusCode == 200) {
        return ApiResponse.success(decoded, response.statusCode);
      } else {
        final message = decoded['message'] ?? 'Failed to load data';
        return ApiResponse.error(message, response.statusCode);
      }
    } catch (e) {
      return ApiResponse.error('Failed to connect to the server: $e');
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> post(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(data),
      );

      final decoded = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.success(decoded, response.statusCode);
      } else {
        final message = decoded['message'] ?? 'Failed to post data';
        return ApiResponse.error(message, response.statusCode);
      }
    } catch (e) {
      return ApiResponse.error('Failed to connect to the server: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}

@riverpod
ApiService apiService(Ref ref) {
  return ApiService(
    baseUrl: dotenv.env['BASE_URL'] ?? '',
  );
}
