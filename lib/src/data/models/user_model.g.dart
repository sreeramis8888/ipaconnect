// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      countryCode: json['country_code'] as String?,
      name: json['name'] as String?,
      uid: json['uid'] as String?,
      blockedUsers: (json['blocked_users'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      memberId: json['member_id'] as String?,
      email: json['email'] as String?,
      image: json['image'] as String?,
      phone: json['phone'] as String?,
      fcm: json['fcm'] as String?,
      otp: json['otp'] as String?,
      profession: json['proffession'] as String?,
      location: json['location'] as String?,
      password: json['password'] as String?,
      status: json['status'] as String?,
      isIpaMember: json['is_ipa_member'] as bool?,
      isAdmin: json['is_admin'] as bool?,
      hierarchy: json['hierarchy'] == null
          ? null
          : HierarchyModel.fromJson(json['hierarchy'] as Map<String, dynamic>),
      role: json['role'] as String?,
      lastSeen: json['last_seen'] == null
          ? null
          : DateTime.parse(json['last_seen'] as String),
      online: json['online'] as bool?,
      rejectReason: json['reject_reason'] as String?,
      bio: json['bio'] as String?,
      socialMedia: (json['social_media'] as List<dynamic>?)
          ?.map((e) => UserSocialMedia.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      id: json['_id'] as String?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      if (instance.name case final value?) 'name': value,
      if (instance.uid case final value?) 'uid': value,
      if (instance.memberId case final value?) 'member_id': value,
      if (instance.email case final value?) 'email': value,
      if (instance.image case final value?) 'image': value,
      if (instance.phone case final value?) 'phone': value,
      if (instance.fcm case final value?) 'fcm': value,
      if (instance.otp case final value?) 'otp': value,
      if (instance.profession case final value?) 'proffession': value,
      if (instance.blockedUsers case final value?) 'blocked_users': value,
      if (instance.countryCode case final value?) 'country_code': value,
      if (instance.location case final value?) 'location': value,
      if (instance.password case final value?) 'password': value,
      if (instance.status case final value?) 'status': value,
      if (instance.isIpaMember case final value?) 'is_ipa_member': value,
      if (instance.isAdmin case final value?) 'is_admin': value,
      if (instance.hierarchy case final value?) 'hierarchy': value,
      if (instance.role case final value?) 'role': value,
      if (instance.lastSeen?.toIso8601String() case final value?)
        'last_seen': value,
      if (instance.online case final value?) 'online': value,
      if (instance.rejectReason case final value?) 'reject_reason': value,
      if (instance.bio case final value?) 'bio': value,
      if (instance.socialMedia case final value?) 'social_media': value,
      if (instance.createdAt?.toIso8601String() case final value?)
        'createdAt': value,
      if (instance.updatedAt?.toIso8601String() case final value?)
        'updatedAt': value,
      if (instance.id case final value?) '_id': value,
    };

UserSocialMedia _$UserSocialMediaFromJson(Map<String, dynamic> json) =>
    UserSocialMedia(
      name: json['name'] as String?,
      url: json['url'] as String?,
    );

Map<String, dynamic> _$UserSocialMediaToJson(UserSocialMedia instance) =>
    <String, dynamic>{
      'name': instance.name,
      'url': instance.url,
    };
