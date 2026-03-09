import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/models/board_member_model.dart';
import 'package:ipaconnect/src/data/services/api_service.dart';

final leadershipApiServiceProvider = Provider<LeadershipApiService>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return LeadershipApiService(apiService);
});

class LeadershipApiService {
  final ApiService _apiService;

  LeadershipApiService(this._apiService);

  Future<List<BoardMember>> getLeadershipData(String type) async {
    final response =
        await _apiService.get('/website/pages/founders?type=$type');
    if (response.success && response.data != null) {
      final List<dynamic> data = response.data!['data'] ?? [];
      final members = data.map((json) => BoardMember.fromJson(json)).toList();
      members.sort((a, b) => (a.priority ?? 0).compareTo(b.priority ?? 0));
      return members;
    } else {
      return [];
    }
  }
}

final leadershipDataProvider =
    FutureProvider.family<List<BoardMember>, String>((ref, type) async {
  final leadershipService = ref.watch(leadershipApiServiceProvider);
  return leadershipService.getLeadershipData(type);
});
