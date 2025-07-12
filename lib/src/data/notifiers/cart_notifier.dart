import 'dart:developer';
import 'package:ipaconnect/src/data/services/api_routes/store_api/store_api_service.dart';
import 'package:ipaconnect/src/data/models/cart_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cart_notifier.g.dart';

@riverpod
class CartNotifier extends _$CartNotifier {
  CartModel? cart;
  bool isLoading = false;
  bool isFirstLoad = true;
  @override
  CartModel? build() {
    return null;
  }

  Future<void> fetchCart() async {
    if (isLoading) return;
    isLoading = true;
    try {
      final cartData = await ref.read(getCartProvider.future);
      cart = cartData;
      isFirstLoad = false;
      state = cart;
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
    }
  }

  Future<bool> addToCart(String storeId, int quantity) async {
    try {
      final storeApiService = ref.read(storeApiServiceProvider);
      final success = await storeApiService.addToCart(storeId, quantity);
      if (success) {
        await fetchCart();
      }
      return success;
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
      return false;
    }
  }

  Future<bool> removeFromCart(String storeId) async {
    try {
      final storeApiService = ref.read(storeApiServiceProvider);
      final success = await storeApiService.removeFromCart(storeId);
      if (success) {
        await fetchCart(); // Refresh cart after removing
      }
      return success;
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
      return false;
    }
  }

  Future<bool> incrementQuantity(String cartId, String storeId) async {
    try {
      final storeApiService = ref.read(storeApiServiceProvider);
      final success = await storeApiService.incrementQuantity(cartId, storeId);
      if (success) {
        await fetchCart();
      }
      return success;
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
      return false;
    }
  }

  Future<bool> decrementQuantity(String cartId, String storeId) async {
    try {
      final storeApiService = ref.read(storeApiServiceProvider);
      final success = await storeApiService.decrementQuantity(cartId, storeId);
      if (success) {
        await fetchCart(); // Refresh cart after decrementing
      }
      return success;
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
      return false;
    }
  }

  int getCartItemCount() {
    if (cart?.products == null || cart!.products!.isEmpty) return 0;
    return cart!.products!.length;
  }

  double getCartTotal() {
    if (cart?.products == null || cart!.products!.isEmpty) return 0.0;
    double total = 0.0;
    for (var product in cart!.products!) {
      final price = product.store?.price ?? 0.0;
      final quantity = product.quantity ?? 0;
      total += price * quantity;
    }
    return total;
  }
}
