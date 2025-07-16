import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class NotificationModel {
  final String? id;

  final List<String>? type;
  final String? subject;
  final String? content;
  final String? image;
  final String? link;

  final List<UserReadStatus>? users;

  final String? status;
  
  @JsonKey(name: 'send_date')
  final DateTime? sendDate;

  @JsonKey(name: 'is_all')
  final bool? isAll;

  final String? tag;

  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;

  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAt;

  NotificationModel({
    this.id,
    this.type,
    this.subject,
    this.content,
    this.image,
    this.link,
    this.users,
    this.status,
    this.sendDate,
    this.isAll,
    this.tag,
    this.createdAt,
    this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
}

@JsonSerializable(includeIfNull: false)
class UserReadStatus {
  final String? user;
  final bool? read;

  UserReadStatus({this.user, this.read});

  factory UserReadStatus.fromJson(Map<String, dynamic> json) =>
      _$UserReadStatusFromJson(json);

  Map<String, dynamic> toJson() => _$UserReadStatusToJson(this);
}
