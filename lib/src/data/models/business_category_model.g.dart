// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusinessCategoryModel _$BusinessCategoryModelFromJson(
        Map<String, dynamic> json) =>
    BusinessCategoryModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String?,
      v: (json['__v'] as num?)?.toInt(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      companyCount: (json['company_count'] as num?)?.toInt(),
      status: json['status'] as bool?,
    );

Map<String, dynamic> _$BusinessCategoryModelToJson(
        BusinessCategoryModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'icon': instance.icon,
      '__v': instance.v,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'company_count': instance.companyCount,
      'status': instance.status,
    };
