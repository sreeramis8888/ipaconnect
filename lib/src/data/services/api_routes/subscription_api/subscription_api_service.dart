import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/services/api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'subscription_api_service.g.dart';

class SubscriptionApiService {
  final ApiService _apiService;
  SubscriptionApiService(this._apiService);

  Future<Map<String, dynamic>?> fetchSubscription() async {
    final response = await _apiService.get('/subscriptions');
    log('Subscription API response: \\${response.data}');
    if (response.success && response.data != null) {
      return response.data!['data'] ?? response.data;
    }
    return null;
  }

  Future<Map<String, dynamic>?> createSubscriptionPayment({
    required String subscriptionId,
    required double amount,
    required String currency,
    required String paymentMethod,
  }) async {
    try {
      final response = await _apiService.post('/subscriptions/create-payment', {
        'subscription': subscriptionId,
        'amount': amount,
        'currency': currency,
        'payment_method': paymentMethod,
      });
      log('Create Subscription Payment response: [${response.success}, message: [${response.message}], data: [${response.data}]');
      if (response.success) {
        return response.data;
      }
    } catch (e, st) {
      log('Error in createSubscriptionPayment: $e\n$st');
    }
    return null;
  }
}

@riverpod
SubscriptionApiService subscriptionApiService(Ref ref) {
  final apiService = ref.watch(apiServiceProvider);
  return SubscriptionApiService(apiService);
}

@riverpod
Future<Map<String, dynamic>?> fetchSubscription(Ref ref) async {
  final service = ref.watch(subscriptionApiServiceProvider);
  return service.fetchSubscription();
}

@riverpod
Future<Map<String, dynamic>?> createSubscriptionPayment(
  Ref ref, {
  required String subscriptionId,
  required double amount,
  required String currency,
  required String paymentMethod,
}) async {
  final service = ref.watch(subscriptionApiServiceProvider);
  return service.createSubscriptionPayment(
    subscriptionId: subscriptionId,
    amount: amount,
    currency: currency,
    paymentMethod: paymentMethod,
  );
}
