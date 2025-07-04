// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobProfileModel _$JobProfileModelFromJson(Map<String, dynamic> json) =>
    JobProfileModel(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      designation: json['designation'] as String?,
      experience: json['experience'] as String?,
      noticePeriod: json['notice_period'] as String?,
      location: json['location'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      resume: json['resume'] as String?,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$JobProfileModelToJson(JobProfileModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'designation': instance.designation,
      'experience': instance.experience,
      'notice_period': instance.noticePeriod,
      'location': instance.location,
      'email': instance.email,
      'phone': instance.phone,
      'resume': instance.resume,
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
