import 'package:json_annotation/json_annotation.dart';
import 'package:ipaconnect/src/data/models/heirarchy_model.dart';

part 'user_model.g.dart';

@JsonSerializable(includeIfNull: false) 
class UserModel {
  final String? name;
  final String? uid;
  @JsonKey(name: 'member_id') final String? memberId;
  final String? email;
  final String? image;
  final String? phone;
  final String? fcm;
  final String? otp;
  @JsonKey(name: 'proffession') final String? profession;
  @JsonKey(name: 'blocked_users') final List<String>? blockedUsers;
  @JsonKey(name: 'country_code') final String? countryCode;
  final String? location;
  final String? password;
  final String? status;
  @JsonKey(name: 'is_ipa_member') final bool? isIpaMember;
  @JsonKey(name: 'is_admin') final bool? isAdmin;
  final HierarchyModel? hierarchy;
  final String? role;
  @JsonKey(name: 'last_seen') final DateTime? lastSeen;
  final bool? online;
  @JsonKey(name: 'reject_reason') final String? rejectReason;
  final String? bio;
  @JsonKey(name: 'social_media') final List<UserSocialMedia>? socialMedia;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  @JsonKey(name: '_id') final String? id;

  const UserModel({this.countryCode,
    this.name,
    this.uid,
    this.blockedUsers,
    this.memberId,
    this.email,
    this.image,
    this.phone,
    this.fcm,
    this.otp,
    this.profession,
    this.location,
    this.password,
    this.status,
    this.isIpaMember,
    this.isAdmin,
    this.hierarchy,
    this.role,
    this.lastSeen,
    this.online,
    this.rejectReason,
    this.bio,
    this.socialMedia,
    this.createdAt,
    this.updatedAt,
    this.id,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? name,
    String? uid,
    String? memberId,
    String? email,
    String? image,
    String? phone,
    String? fcm,
    String? otp,
    String? profession,
    String? location,
    String? password,
    String? status,
    bool? isIpaMember,
    bool? isAdmin,
    HierarchyModel? hierarchy,
    String? role,
    DateTime? lastSeen,
    bool? online,
    String? rejectReason,
    String? bio,
    List<UserSocialMedia>? socialMedia,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? id,
  }) {
    return UserModel(
      name: name ?? this.name,
      uid: uid ?? this.uid,
      memberId: memberId ?? this.memberId,
      email: email ?? this.email,
      image: image ?? this.image,
      phone: phone ?? this.phone,
      fcm: fcm ?? this.fcm,
      otp: otp ?? this.otp,
      profession: profession ?? this.profession,
      location: location ?? this.location,
      password: password ?? this.password,
      status: status ?? this.status,
      isIpaMember: isIpaMember ?? this.isIpaMember,
      isAdmin: isAdmin ?? this.isAdmin,
      hierarchy: hierarchy ?? this.hierarchy,
      role: role ?? this.role,
      lastSeen: lastSeen ?? this.lastSeen,
      online: online ?? this.online,
      rejectReason: rejectReason ?? this.rejectReason,
      bio: bio ?? this.bio,
      socialMedia: socialMedia ?? this.socialMedia,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      id: id ?? this.id,
    );
  }
}

@JsonSerializable()
class UserSocialMedia {
  final String? name;
  final String? url;

  UserSocialMedia({
    this.name,
    this.url,
  });

  factory UserSocialMedia.fromJson(Map<String, dynamic> json) => _$UserSocialMediaFromJson(json);
  Map<String, dynamic> toJson() => _$UserSocialMediaToJson(this);

  UserSocialMedia copyWith({
    String? name,
    String? url,
  }) {
    return UserSocialMedia(
      name: name ?? this.name,
      url: url ?? this.url,
    );
  }
}
