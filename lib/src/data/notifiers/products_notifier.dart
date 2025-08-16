import 'dart:developer';
import 'package:ipaconnect/src/data/models/product_model.dart';
import 'package:ipaconnect/src/data/services/api_routes/products_api/products_api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'products_notifier.g.dart';

@riverpod
class ProductsNotifier extends _$ProductsNotifier {
  List<ProductModel> products = [];
  bool isLoading = false;
  bool isFirstLoad = true;
  String? companyId;
  int pageNo = 1;
  final int limit = 14;
  bool hasMore = true;
  String? searchQuery;
  bool isUserProducts = false;
  
  @override
  List<ProductModel> build() {
    return [];
  }

  Future<void> fetchMoreProducts(String? companyId, {bool isUserProducts = false}) async {
    if (isLoading || !hasMore) return;

    isLoading = true;
    this.isUserProducts = isUserProducts;

    try {
      final refreshedProducts = isUserProducts 
        ? await ref.read(getProductsForUserProvider(
            pageNo: pageNo, 
            limit: limit, 
            companyId: companyId ?? '')
          .future)
        : await ref.read(getProductsProvider(
            pageNo: pageNo, 
            limit: limit, 
            companyId: companyId ?? '')
          .future);

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

  Future<void> searchProducts(String query, {required String companyId, bool isUserProducts = false}) async {
    isLoading = true;
    pageNo = 1;
    products = [];
    searchQuery = query;
    this.isUserProducts = isUserProducts;

    try {
      final newProducts = isUserProducts
        ? await ref.read(
          getProductsForUserProvider(
            companyId: companyId,
            pageNo: pageNo,
            limit: limit,
            query: query,
          ).future,
        )
        : await ref.read(
          getProductsProvider(
            companyId: companyId,
            pageNo: pageNo,
            limit: limit,
            query: query,
          ).future,
        );

      products = [...newProducts];
      hasMore = newProducts.length == limit;

      state = [...products];
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
    }
  }

  Future<void> refreshProducts(String? companyId, {bool isUserProducts = false}) async {
    if (isLoading) return;

    isLoading = true;
    this.isUserProducts = isUserProducts;

    try {
      pageNo = 1;
      final refreshedProducts = isUserProducts
        ? await ref.read(getProductsForUserProvider(
            pageNo: pageNo, 
            limit: limit, 
            companyId: companyId ?? '')
          .future)
        : await ref.read(getProductsProvider(
            pageNo: pageNo, 
            limit: limit, 
            companyId: companyId ?? '')
          .future);

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

  void updateProductRating(
      {required String productId, required double newRating}) {
    products = products.map((product) {
      if (product.id == productId) {
        return product.copyWith(rating: newRating);
      }
      return product;
    }).toList();
    state = products;
  }
}
