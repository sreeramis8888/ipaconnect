import 'dart:developer';
import 'package:ipaconnect/src/data/services/api_routes/store_api/store_api_service.dart';
import 'package:ipaconnect/src/data/models/order_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'order_notifier.g.dart';

@riverpod
class OrderNotifier extends _$OrderNotifier {
  List<OrderModel> orders = [];
  bool isLoading = false;
  bool isFirstLoad = true;
  int pageNo = 1;
  final int limit = 10;
  bool hasMore = true;

  @override
  List<OrderModel> build() {
    return [];
  }

  Future<void> fetchMoreOrders() async {
    if (isLoading || !hasMore) return;
    isLoading = true;
    try {
      final refreshedOrders = await ref.read(getOrdersProvider(
        pageNo: pageNo, limit: limit).future);
      if (refreshedOrders.isEmpty) {
        hasMore = false;
      } else {
        orders = [...orders, ...refreshedOrders];
        pageNo++;
        hasMore = refreshedOrders.length >= limit;
      }
      isFirstLoad = false;
      state = orders;
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
    }
  }

  Future<void> refreshOrders() async {
    if (isLoading) return;
    isLoading = true;
    try {
      pageNo = 1;
      final refreshedOrders = await ref.read(getOrdersProvider(
        pageNo: pageNo, limit: limit).future);
      orders = refreshedOrders;
      hasMore = refreshedOrders.length >= limit;
      isFirstLoad = false;
      state = orders;
      log('orders refreshed');
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
    }
  }

  Future<bool> createOrder({
    required String cartId,
    required double amount,
    required String currency,
    required ShippingAddress shippingAddress,
  }) async {
    try {
      final storeApiService = ref.read(storeApiServiceProvider);
      final success = await storeApiService.createOrder(
        cartId: cartId,
        amount: amount,
        currency: currency,
        shippingAddress: shippingAddress,
      );
      if (success) {
        await refreshOrders(); // Refresh orders after creating
      }
      return success;
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
      return false;
    }
  }
} 