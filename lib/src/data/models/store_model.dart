import 'package:json_annotation/json_annotation.dart';

part 'store_model.g.dart';

@JsonSerializable(explicitToJson: true)
class StoreModel {
  @JsonKey(name: '_id')
  final String? id;

  final String? name;
  final String? category;
  final double? price;
  final String? currency;
  final String? image;
  final String? description;
  final bool? status;
  
  @JsonKey(name: 'created_by')
  final String? createdBy;
  
  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;
  
  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAt;

  StoreModel({
    this.id,
    this.name,
    this.category,
    this.price,
    this.currency,
    this.image,
    this.description,
    this.status,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) =>
      _$StoreModelFromJson(json);

  Map<String, dynamic> toJson() => _$StoreModelToJson(this);

  StoreModel copyWith({
    String? id,
    String? name,
    String? category,
    double? price,
    String? currency,
    String? image,
    String? description,
    bool? status,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StoreModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      image: image ?? this.image,
      description: description ?? this.description,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
} 