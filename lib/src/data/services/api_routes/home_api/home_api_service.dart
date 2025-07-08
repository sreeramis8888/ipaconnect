import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/models/home_model.dart';
import 'package:ipaconnect/src/data/services/api_service.dart';

final homeApiServiceProvider = Provider<HomeApiService>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return HomeApiService(apiService);
});

class HomeApiService {
  final ApiService _apiService;

  HomeApiService(this._apiService);

  Future<HomeModel?> getHomeData() async {
    final response = await _apiService.get('/app/home');
    if (response.success && response.data != null) {
      return HomeModel.fromJson(response.data!);
    } else {
      return null;
    }
  }
}

final homeDataProvider = FutureProvider<HomeModel?>((ref) async {
  final homeService = ref.watch(homeApiServiceProvider);
  return homeService.getHomeData();
}); 