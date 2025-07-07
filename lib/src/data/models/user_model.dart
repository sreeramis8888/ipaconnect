import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';


@freezed
abstract class UserModel with _$UserModel {
  factory UserModel({
    String? name,
    String? uid,
    @JsonKey(name: 'member_id') String? memberId,
    String? email,
    String? image,
    String? phone,
    String? fcm,
    String? otp,
    @JsonKey(name: 'proffession') String? profession,
    String? location,
    String? password,
    String? status,
    @JsonKey(name: 'is_ipa_member') bool? isIpaMember,
    @JsonKey(name: 'is_admin') bool? isAdmin,
    String? hierarchy, // ObjectId
    String? role, // ObjectId
    @JsonKey(name: 'last_seen') DateTime? lastSeen,
    bool? online,
    @JsonKey(name: 'reject_reason') String? rejectReason,
    String? bio,
    @JsonKey(name: 'social_media')
    List<SocialMedia>? socialMedia,
    @JsonKey(name: 'createdAt') DateTime? createdAt,
    @JsonKey(name: 'updatedAt') DateTime? updatedAt,
  @JsonKey(name: '_id') String? id,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

@freezed
abstract class SocialMedia with _$SocialMedia {
  factory SocialMedia({
    String? name,
    String? url,
  }) = _SocialMedia;

  factory SocialMedia.fromJson(Map<String, dynamic> json) =>
      _$SocialMediaFromJson(json);
}
