import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../api_service.dart';

final authApiServiceProvider = Provider<AuthApiService>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return AuthApiService(apiService);
});

class AuthApiService {
  final ApiService _apiService;

  AuthApiService(this._apiService);

  Future<String> login(String phone) async {
    final response = await _apiService.post('/auth/login', {'phone': phone});
    if (response.success && response.data != null) {
      // The OTP is returned in response.data['data']
      return response.data!['data'].toString();
    } else {
      throw Exception(response.message ?? 'Failed to send OTP');
    }
  }

  Future<String> verifyOtp(String phone, String otp) async {
    final response = await _apiService.post('/auth/verify', {'phone': phone, 'otp': otp});
    if (response.success && response.data != null) {
      return response.data!['data'].toString();
    } else {
      throw Exception(response.message ?? 'Failed to verify OTP');
    }
  }
}
