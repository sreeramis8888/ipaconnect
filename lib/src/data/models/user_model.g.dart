// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      name: json['name'] as String?,
      uid: json['uid'] as String?,
      memberId: json['member_id'] as String?,
      email: json['email'] as String?,
      image: json['image'] as String?,
      phone: json['phone'] as String?,
      fcm: json['fcm'] as String?,
      otp: json['otp'] as String?,
      profession: json['proffession'] as String?,
      blockedUsers: (json['blocked_users'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      countryCode: json['country_code'] as String?,
      location: json['location'] as String?,
      password: json['password'] as String?,
      status: json['status'] as String?,
      isIpaMember: json['is_ipa_member'] as bool?,
      isAdmin: json['is_admin'] as bool?,
      isFormActivated: json['is_form_activated'] as bool?,
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
      dob: json['dob'] == null ? null : DateTime.parse(json['dob'] as String),
      emirates: json['emirates'] as String?,
      ipaJoinDate: json['ipa_join_date'] == null
          ? null
          : DateTime.parse(json['ipa_join_date'] as String),
      isInstalled: json['is_installed'] as bool?,
      videos: (json['videos'] as List<dynamic>?)
          ?.map((e) => SubData.fromJson(e as Map<String, dynamic>))
          .toList(),
      certificates: (json['certificates'] as List<dynamic>?)
          ?.map((e) => SubData.fromJson(e as Map<String, dynamic>))
          .toList(),
      websites: (json['websites'] as List<dynamic>?)
          ?.map((e) => SubData.fromJson(e as Map<String, dynamic>))
          .toList(),
      documents: (json['documents'] as List<dynamic>?)
          ?.map((e) => SubData.fromJson(e as Map<String, dynamic>))
          .toList(),
      awards: (json['awards'] as List<dynamic>?)
          ?.map((e) => Award.fromJson(e as Map<String, dynamic>))
          .toList(),
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
      if (instance.isFormActivated case final value?)
        'is_form_activated': value,
      if (instance.rejectReason case final value?) 'reject_reason': value,
      if (instance.bio case final value?) 'bio': value,
      if (instance.socialMedia case final value?) 'social_media': value,
      if (instance.createdAt?.toIso8601String() case final value?)
        'createdAt': value,
      if (instance.updatedAt?.toIso8601String() case final value?)
        'updatedAt': value,
      if (instance.id case final value?) '_id': value,
      if (instance.dob?.toIso8601String() case final value?) 'dob': value,
      if (instance.emirates case final value?) 'emirates': value,
      if (instance.ipaJoinDate?.toIso8601String() case final value?)
        'ipa_join_date': value,
      if (instance.isInstalled case final value?) 'is_installed': value,
      if (instance.videos case final value?) 'videos': value,
      if (instance.certificates case final value?) 'certificates': value,
      if (instance.websites case final value?) 'websites': value,
      if (instance.documents case final value?) 'documents': value,
      if (instance.awards case final value?) 'awards': value,
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

SubData _$SubDataFromJson(Map<String, dynamic> json) => SubData(
      name: json['name'] as String?,
      link: json['link'] as String?,
    );

Map<String, dynamic> _$SubDataToJson(SubData instance) => <String, dynamic>{
      'name': instance.name,
      'link': instance.link,
    };

Award _$AwardFromJson(Map<String, dynamic> json) => Award(
      image: json['image'] as String?,
      name: json['name'] as String?,
      authority: json['authority'] as String?,
    );

Map<String, dynamic> _$AwardToJson(Award instance) => <String, dynamic>{
      'image': instance.image,
      'name': instance.name,
      'authority': instance.authority,
    };
