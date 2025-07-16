// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      id: json['id'] as String?,
      type: (json['type'] as List<dynamic>?)?.map((e) => e as String).toList(),
      subject: json['subject'] as String?,
      content: json['content'] as String?,
      image: json['image'] as String?,
      link: json['link'] as String?,
      users: (json['users'] as List<dynamic>?)
          ?.map((e) => UserReadStatus.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as String?,
      sendDate: json['send_date'] == null
          ? null
          : DateTime.parse(json['send_date'] as String),
      isAll: json['is_all'] as bool?,
      tag: json['tag'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      if (instance.type case final value?) 'type': value,
      if (instance.subject case final value?) 'subject': value,
      if (instance.content case final value?) 'content': value,
      if (instance.image case final value?) 'image': value,
      if (instance.link case final value?) 'link': value,
      if (instance.users?.map((e) => e.toJson()).toList() case final value?)
        'users': value,
      if (instance.status case final value?) 'status': value,
      if (instance.sendDate?.toIso8601String() case final value?)
        'send_date': value,
      if (instance.isAll case final value?) 'is_all': value,
      if (instance.tag case final value?) 'tag': value,
      if (instance.createdAt?.toIso8601String() case final value?)
        'createdAt': value,
      if (instance.updatedAt?.toIso8601String() case final value?)
        'updatedAt': value,
    };

UserReadStatus _$UserReadStatusFromJson(Map<String, dynamic> json) =>
    UserReadStatus(
      user: json['user'] as String?,
      read: json['read'] as bool?,
    );

Map<String, dynamic> _$UserReadStatusToJson(UserReadStatus instance) =>
    <String, dynamic>{
      if (instance.user case final value?) 'user': value,
      if (instance.read case final value?) 'read': value,
    };
