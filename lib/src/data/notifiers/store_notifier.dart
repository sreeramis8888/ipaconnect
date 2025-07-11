import 'dart:developer';
import 'package:ipaconnect/src/data/models/store_model.dart';
import 'package:ipaconnect/src/data/services/api_routes/store_api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'store_notifier.g.dart';

@riverpod
class StoreNotifier extends _$StoreNotifier {
  List<StoreModel> products = [];
  bool isLoading = false;
  bool isFirstLoad = true;
  int pageNo = 1;
  final int limit = 14;
  bool hasMore = true;

  @override
  List<StoreModel> build() {
    return [];
  }

  Future<void> fetchMoreProducts() async {
    if (isLoading || !hasMore) return;
    isLoading = true;
    try {
      final refreshedProducts = await ref.read(getStoreProductsProvider(
        pageNo: pageNo, limit: limit).future);
      if (refreshedProducts.isEmpty) {
        hasMore = false;
      } else {
        products = [...products, ...refreshedProducts];
        pageNo++;
        hasMore = refreshedProducts.length >= limit;
      }
      isFirstLoad = false;
      state = products;
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
    }
  }

  Future<void> refreshProducts() async {
    if (isLoading) return;
    isLoading = true;
    try {
      pageNo = 1;
      final refreshedProducts = await ref.read(getStoreProductsProvider(
        pageNo: pageNo, limit: limit).future);
      products = refreshedProducts;
      hasMore = refreshedProducts.length >= limit;
      isFirstLoad = false;
      state = products;
      log('refreshed');
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
    }
  }
} 