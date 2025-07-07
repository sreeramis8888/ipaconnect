import 'dart:developer';
import 'package:ipaconnect/src/data/models/company_model.dart';
import 'package:ipaconnect/src/data/services/api_routes/company_api/company_api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_companies_notifier.g.dart';

@riverpod
class UserCompaniesNotifier extends _$UserCompaniesNotifier {
  List<CompanyModel> companies = [];
  bool isLoading = false;
  bool isFirstLoad = true;
  int pageNo = 1;
  final int limit = 14;
  bool hasMore = true;

  @override
  List<CompanyModel> build(String userId) {
    this.userId = userId;
    return [];
  }

  Future<void> fetchMoreCompanies(String userId) async {
    if (isLoading || !hasMore) return;
    isLoading = true;
    try {
      final newCompanies = await ref.read(
        getCompaniesByUserIdProvider(
                userId: userId, pageNo: pageNo, limit: limit)
            .future,
      );
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

  Future<void> refreshCompanies(String userId) async {
    if (isLoading) return;
    isLoading = true;
    try {
      pageNo = 1;
      final refreshedCompanies = await ref.read(
        getCompaniesByUserIdProvider(
                userId: userId, pageNo: pageNo, limit: limit)
            .future,
      );
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
}
