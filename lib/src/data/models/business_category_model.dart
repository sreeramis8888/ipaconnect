import 'package:json_annotation/json_annotation.dart';

part 'business_category_model.g.dart';

@JsonSerializable()
class BusinessCategoryModel {
  @JsonKey(name: '_id')
  final String id;

  final String name;
  final String? icon;

  @JsonKey(name: '__v')
  final int? v;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  @JsonKey(name: 'company_count')
  final int? companyCount;

  final bool? status;

  BusinessCategoryModel({
    required this.id,
    required this.name,
    this.icon,
    this.v,
    this.createdAt,
    this.updatedAt,
    this.companyCount,
    this.status
  });

  factory BusinessCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$BusinessCategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$BusinessCategoryModelToJson(this);

  BusinessCategoryModel copyWith({
    String? id,
    String? name,
    String? icon,
    int? v,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? companyCount,
    bool? status,
  }) {
    return BusinessCategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      v: v ?? this.v,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      companyCount: companyCount ?? this.companyCount,
      status: status ?? this.status,
    );
  }
}
