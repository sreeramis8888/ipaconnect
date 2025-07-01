// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      uid: json['uid'] as String?,
      memberId: json['member_id'] as String?,
      email: json['email'] as String?,
      image: json['image'] as String?,
      phone: json['phone'] as String?,
      fcm: json['fcm'] as String?,
      otp: json['otp'] as String?,
      profession: json['proffession'] as String?,
      location: json['location'] as String?,
      password: json['password'] as String?,
      hierarchy: json['hierarchy'] as String?,
      status: json['status'] as String?,
      isIpaMember: json['is_ipa_member'] as bool? ?? false,
      isAdmin: json['is_admin'] as bool? ?? false,
      role: json['role'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'uid': instance.uid,
      'member_id': instance.memberId,
      'email': instance.email,
      'image': instance.image,
      'phone': instance.phone,
      'fcm': instance.fcm,
      'otp': instance.otp,
      'proffession': instance.profession,
      'location': instance.location,
      'password': instance.password,
      'hierarchy': instance.hierarchy,
      'status': instance.status,
      'is_ipa_member': instance.isIpaMember,
      'is_admin': instance.isAdmin,
      'role': instance.role,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
