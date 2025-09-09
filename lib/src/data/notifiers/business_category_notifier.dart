import 'dart:developer';
import 'package:ipaconnect/src/data/models/business_category_model.dart';
import 'package:ipaconnect/src/data/models/chat_model.dart';
import 'package:ipaconnect/src/data/models/feed_model.dart';
import 'package:ipaconnect/src/data/services/api_routes/business_category_api/business_category_api_service.dart';
import 'package:ipaconnect/src/data/services/api_routes/chat_api/chat_api_service.dart';
import 'package:ipaconnect/src/data/services/api_routes/feed_api/feed_api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'business_category_notifier.g.dart';

@riverpod
class BusinessCategoryNotifier extends _$BusinessCategoryNotifier {
  List<BusinessCategoryModel> categories = [];
  bool isLoading = false;
  bool isFirstLoad = true;
  int pageNo = 1;
  final int limit = 50;
  bool hasMore = true;
  String? searchQuery;
  @override
  List<BusinessCategoryModel> build() {
    return [];
  }

  // Future<void> fetchMoreCategories() async {
  //   if (isLoading || !hasMore) return;

  //   isLoading = true;

  //   try {
  //     final newCategories = await ref.read(
  //         getBusinessCategoriesProvider(pageNo: pageNo, limit: limit).future);

  //     if (newCategories.isEmpty) {
  //       hasMore = false;
  //     } else {
  //       categories = [...categories, ...newCategories];
  //       pageNo++;
  //       hasMore = newCategories.length >= limit;
  //     }

  //     isFirstLoad = false;
  //     state = categories;
  //   } catch (e, stackTrace) {
  //     log(e.toString());
  //     log(stackTrace.toString());
  //   } finally {
  //     isLoading = false;
  //   }
  // }

  Future<void> fetchMoreCategories() async {
    if (isLoading || !hasMore) return;

    isLoading = true;

    try {
      final newCategories = await ref.read(
        getBusinessCategoriesProvider(pageNo: pageNo, limit: limit).future,
      );

      // FILTER ONLY ACTIVE CATEGORIES
      final activeCategories = newCategories.where((c) => c.status == true).toList();

      if (activeCategories.isEmpty) {
        hasMore = false;
      } else {
        categories = [...categories, ...activeCategories];
        pageNo++;
        hasMore = activeCategories.length >= limit;
      }

      isFirstLoad = false;
      state = categories;
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
    }
  }


  Future<void> refreshCategories() async {
    if (isLoading) return;

    isLoading = true;

    try {
      pageNo = 1;
      final refreshedCategories = await ref.read(
          getBusinessCategoriesProvider(pageNo: pageNo, limit: limit).future);

      // FILTER ONLY ACTIVE CATEGORIES
      categories = refreshedCategories.where((c) => c.status == true).toList();
      hasMore = categories.length >= limit;
      isFirstLoad = false;
      state = categories;
      log('refreshed');
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
    }
  }


  
  Future<void> searchCategories(String query,
     ) async {
    isLoading = true;
    pageNo = 1;
    categories = [];
    searchQuery = query;

    try {
      final newCategories = await ref.read(
        getBusinessCategoriesProvider(
          pageNo: pageNo,
          limit: limit,
          query: query,
        ).future,
      );
  //FILTER ONLY ACTIVE CATEGORIES
      final activeCategories = newCategories.where((c) => c.status == true).toList();

      categories = [...activeCategories];
      hasMore = activeCategories.length == limit;
      state = [...categories];
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
    }
  }
  
}
