import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/models/news_model.dart';
import '../../api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'news_api_service.g.dart';


@riverpod
PromotionsApiService newsApiService(Ref ref) {
  final apiService = ref.watch(apiServiceProvider);
  return PromotionsApiService(apiService);
}

class PromotionsApiService {
  final ApiService _apiService;

  PromotionsApiService(this._apiService);

  Future<List<NewsModel>> getNews() async {
    try {
      final response = await _apiService.get('/news/user');
      final List<dynamic> data = response['data'] as List<dynamic>;
      return data.map((json) => NewsModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch events: $e');
    }
  }
}


@riverpod
Future<List<NewsModel>> news(Ref ref) async {
  final newsService = ref.watch(newsApiServiceProvider);
  return newsService.getNews();
}

