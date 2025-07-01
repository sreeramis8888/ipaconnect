import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/models/news_model.dart';
import '../../api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'news_api_service.g.dart';

class NewsApiService {
  final ApiService _apiService;

  NewsApiService(this._apiService);

  Future<List<NewsModel>> getNews() async {
    final response = await _apiService.get('/news/user');

    if (response.success && response.data != null) {
      final List<dynamic> data = response.data!['data'];
      return data.map((json) => NewsModel.fromJson(json)).toList();
    } else {
      throw Exception(response.message ?? 'Unknown error occurred while fetching news');
    }
  }
}

@riverpod
NewsApiService newsApiService(Ref ref) {
  final apiService = ref.watch(apiServiceProvider);
  return NewsApiService(apiService);
}

@riverpod
Future<List<NewsModel>> news(Ref ref) async {
  final newsService = ref.watch(newsApiServiceProvider);
  return newsService.getNews();
}
