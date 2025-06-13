// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsModel _$NewsModelFromJson(Map<String, dynamic> json) => NewsModel(
      category: json['category'] as String?,
      title: json['title'] as String?,
      content: json['content'] as String?,
      media: json['media'] as String?,
      status: json['status'] as String?,
      pdf: json['pdf'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$NewsModelToJson(NewsModel instance) => <String, dynamic>{
      'category': instance.category,
      'title': instance.title,
      'content': instance.content,
      'media': instance.media,
      'status': instance.status,
      'pdf': instance.pdf,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
