import 'package:json_annotation/json_annotation.dart';

part 'job_profile_model.g.dart';

@JsonSerializable()
class JobProfileModel {
  @JsonKey(name: '_id')
  final String? id;
  final String? name;
  final String? designation;
  final String? experience;
  @JsonKey(name: 'notice_period')
  final String? noticePeriod;
  final String? location;
  final String? email;
  final String? phone;
  final String? resume;
  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAt;

  JobProfileModel({
    this.id,
    this.name,
    this.designation,
    this.experience,
    this.noticePeriod,
    this.location,
    this.email,
    this.phone,
    this.resume,
    this.updatedAt,
  });

  factory JobProfileModel.fromJson(Map<String, dynamic> json) => _$JobProfileModelFromJson(json);
  Map<String, dynamic> toJson() => _$JobProfileModelToJson(this);
} 