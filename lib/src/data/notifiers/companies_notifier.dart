import 'dart:developer';
import 'package:ipaconnect/src/data/models/business_category_model.dart';
import 'package:ipaconnect/src/data/models/chat_model.dart';
import 'package:ipaconnect/src/data/models/company_model.dart';
import 'package:ipaconnect/src/data/models/feed_model.dart';
import 'package:ipaconnect/src/data/services/api_routes/business_category_api/business_category_api_service.dart';
import 'package:ipaconnect/src/data/services/api_routes/chat_api/chat_api_service.dart';
import 'package:ipaconnect/src/data/services/api_routes/company_api/company_api_service.dart';
import 'package:ipaconnect/src/data/services/api_routes/feed_api/feed_api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'companies_notifier.g.dart';

@riverpod
class CompaniesNotifier extends _$CompaniesNotifier {
  List<CompanyModel> companies = [];
  bool isLoading = false;
  bool isFirstLoad = true;
  String? categoryId;
  int pageNo = 1;
  final int limit = 14;
  bool hasMore = true;
  String? searchQuery;
  @override
  List<CompanyModel> build() {
    return [];
  }

  Future<void> fetchMoreCompanies(String? categoryId) async {
    if (isLoading || !hasMore) return;

    isLoading = true;

    try {
      final newCompanies = await ref.read(getCompaniesProvider(
              pageNo: pageNo, limit: limit, categoryId: categoryId)
          .future);

      if (newCompanies.isEmpty) {
        hasMore = false;
      } else {
        companies = [...companies, ...newCompanies];
        pageNo++;
        hasMore = newCompanies.length >= limit;
      }

      isFirstLoad = false;
      state = companies;
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
    }
  }

  Future<void> searchCompanies(String query,
      {required String categoryId}) async {
    isLoading = true;
    pageNo = 1;
    companies = [];
    searchQuery = query;

    try {
      final newCompanies = await ref.read(
        getCompaniesProvider(
          categoryId: categoryId,
          pageNo: pageNo,
          limit: limit,
          query: query,
        ).future,
      );

      companies = [...newCompanies];
      hasMore = newCompanies.length == limit;
      isFirstLoad = false;
      state = [...companies];
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
    }
  }

  Future<void> refreshCompanies() async {
    if (isLoading) return;

    isLoading = true;

    try {
      pageNo = 1;
      final refreshedCompanies = await ref.read(getCompaniesProvider(
              pageNo: pageNo, limit: limit, categoryId: categoryId)
          .future);

      companies = refreshedCompanies;
      hasMore = refreshedCompanies.length >= limit;
      isFirstLoad = false;
      state = companies;
      log('refreshed');
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
    }
  }

  void updateCompanyRating(
      {required String companyId, required double newRating}) {
    companies = companies.map((company) {
      if (company.id == companyId) {
        return company.copyWith(rating: newRating);
      }
      return company;
    }).toList();
    state = companies;
  }
}
