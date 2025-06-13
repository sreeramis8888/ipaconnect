import 'package:json_annotation/json_annotation.dart';

part 'news_model.g.dart';

@JsonSerializable()
class NewsModel {
  final String? category;
  final String? title;
  final String? content;
  final String? media;
  final String? status;
  final String? pdf;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  NewsModel({
    this.category,
    this.title,
    this.content,
    this.media,
    this.status,
    this.pdf,
    this.createdAt,
    this.updatedAt,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) =>
      _$NewsModelFromJson(json);

  Map<String, dynamic> toJson() => _$NewsModelToJson(this);

  static const List<String> categories = [
    'Latest',
    'Current Affairs',
    'Trending',
    'History',
    'Entertainment',
    'Volunteering',
    'Events/ Programmes',
  ];

  static const List<String> statuses = [
    'published',
    'unpublished',
  ];
} 