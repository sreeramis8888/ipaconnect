import 'package:ipaconnect/src/data/models/campaign_model.dart';
import 'package:ipaconnect/src/data/models/events_model.dart';
import 'package:ipaconnect/src/data/models/news_model.dart';
import 'package:ipaconnect/src/data/models/promotions_model.dart';


class HomeModel {
  final List<Promotion> banners;
  final EventsModel? event;
  final List<Promotion> posters;
  final List<NewsModel> news;
  final List<Promotion> notices;
  final CampaignModel? campaign;
  final List<Promotion> videos;

  HomeModel({
    required this.banners,
    required this.event,
    required this.posters,
    required this.news,
    required this.notices,
    required this.campaign,
    required this.videos,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return HomeModel(
      banners: (data['banners'] as List<dynamic>? ?? []).map((e) => Promotion.fromJson(e)).toList(),
      event: data['event'] != null ? EventsModel.fromJson(data['event']) : null,
      posters: (data['posters'] as List<dynamic>? ?? []).map((e) => Promotion.fromJson(e)).toList(),
      news: (data['news'] as List<dynamic>? ?? []).map((e) => NewsModel.fromJson(e)).toList(),
      notices: (data['notices'] as List<dynamic>? ?? []).map((e) => Promotion.fromJson(e)).toList(),
      campaign: data['campaign'] != null ? CampaignModel.fromJson(data['campaign']) : null,
      videos: (data['videos'] as List<dynamic>? ?? []).map((e) => Promotion.fromJson(e)).toList(),
    );
  }
} 