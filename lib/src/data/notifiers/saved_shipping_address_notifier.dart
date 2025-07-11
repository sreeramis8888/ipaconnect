import 'package:ipaconnect/src/data/models/order_model.dart';
import 'package:ipaconnect/src/data/services/api_routes/store_api/store_api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'saved_shipping_address_notifier.g.dart';

@riverpod
class SavedShippingAddressNotifier extends _$SavedShippingAddressNotifier {
  @override
  Future<List<ShippingAddress>> build() async {
    final service = ref.watch(storeApiServiceProvider);
    return await service.getSavedShippingAddress();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final service = ref.watch(storeApiServiceProvider);
      return await service.getSavedShippingAddress();
    });
  }
}
