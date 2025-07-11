import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ipaconnect/src/data/models/heirarchy_model.dart';

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
    HierarchyModel? hierarchy,
    String? role, 
    @JsonKey(name: 'last_seen') DateTime? lastSeen,
    bool? online,
    @JsonKey(name: 'reject_reason') String? rejectReason,
    String? bio,
    @JsonKey(name: 'social_media')
    List<UserSocialMedia>? socialMedia,
    @JsonKey(name: 'createdAt') DateTime? createdAt,
    @JsonKey(name: 'updatedAt') DateTime? updatedAt,
  @JsonKey(name: '_id') String? id,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

@freezed
abstract class UserSocialMedia with _$UserSocialMedia {
  factory UserSocialMedia({
    String? name,
    String? url,
  }) = _UserSocialMedia;

  factory UserSocialMedia.fromJson(Map<String, dynamic> json) =>
      _$UserSocialMediaFromJson(json);
}
