// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedModel _$FeedModelFromJson(Map<String, dynamic> json) => FeedModel(
      id: json['_id'] as String?,
      type: json['type'] as String?,
      media: json['media'] as String?,
      link: json['link'] as String?,
      content: json['content'] as String?,
      user: json['user'] == null
          ? null
          : Author.fromJson(json['user'] as Map<String, dynamic>),
      likes: (json['like'] as List<dynamic>?)?.map((e) => e as String).toList(),
      status: json['status'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      comments: (json['comment'] as List<dynamic>?)
          ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FeedModelToJson(FeedModel instance) => <String, dynamic>{
      '_id': instance.id,
      'type': instance.type,
      'media': instance.media,
      'link': instance.link,
      'content': instance.content,
      'user': instance.user?.toJson(),
      'like': instance.likes,
      'status': instance.status,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'comment': instance.comments?.map((e) => e.toJson()).toList(),
    };

Author _$AuthorFromJson(Map<String, dynamic> json) => Author(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      proffession: json['proffession'] as String?,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$AuthorToJson(Author instance) => <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'image': instance.image,
      'proffession': instance.proffession,
    };

FeedUser _$FeedUserFromJson(Map<String, dynamic> json) => FeedUser(
      id: json['_id'] as String?,
      image: json['image'] as String?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$FeedUserToJson(FeedUser instance) => <String, dynamic>{
      '_id': instance.id,
      'image': instance.image,
      'name': instance.name,
    };

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      user: json['user'] == null
          ? null
          : FeedUser.fromJson(json['user'] as Map<String, dynamic>),
      comment: json['comment'] as String?,
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'user': instance.user?.toJson(),
      'comment': instance.comment,
    };
