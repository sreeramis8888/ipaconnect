import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PaymentNavState { idle, showSubscription, showSuccess }

final paymentNavProvider = StateProvider<PaymentNavState>((ref) => PaymentNavState.idle);

final paymentResultProvider = StateProvider<Map<String, dynamic>?>((ref) => null); 