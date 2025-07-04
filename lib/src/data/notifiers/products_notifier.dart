import 'dart:developer';
import 'package:ipaconnect/src/data/models/business_category_model.dart';
import 'package:ipaconnect/src/data/models/chat_model.dart';
import 'package:ipaconnect/src/data/models/company_model.dart';
import 'package:ipaconnect/src/data/models/feed_model.dart';
import 'package:ipaconnect/src/data/models/product_model.dart';
import 'package:ipaconnect/src/data/services/api_routes/business_category_api/business_category_api_service.dart';
import 'package:ipaconnect/src/data/services/api_routes/chat_api/chat_api_service.dart';
import 'package:ipaconnect/src/data/services/api_routes/company_api/company_api_service.dart';
import 'package:ipaconnect/src/data/services/api_routes/feed_api/feed_api_service.dart';
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

  @override
  List<ProductModel> build() {
    return [];
  }

  Future<void> fetchMoreProducts(String? companyId) async {
    if (isLoading || !hasMore) return;

    isLoading = true;

    try {
      final refreshedProducts = await ref.read(
          getProductsProvider(pageNo: pageNo, limit: limit, companyId: companyId??'')
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

  Future<void> refreshCompanies(String? companyId) async {
    if (isLoading) return;

    isLoading = true;

    try {
      pageNo = 1;
      final refreshedProducts = await ref.read(
          getProductsProvider(pageNo: pageNo, limit: limit,companyId: companyId??'').future);

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
