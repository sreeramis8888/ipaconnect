import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

enum UserStatus { active, inactive, deleted }

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    @JsonKey(name: '_id') String? id,
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
    String? hierarchy, 
    @Default(UserStatus.active)
    @JsonKey(unknownEnumValue: UserStatus.active)
    UserStatus status,
    @JsonKey(name: 'is_ipa_member') @Default(false) bool isIpaMember,
    @JsonKey(name: 'is_admin') @Default(false) bool isAdmin,
    String? role, 
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
