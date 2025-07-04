import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductModel {
  @JsonKey(name: '_id')
  final String id;

  final UserRef user;
  final String company;
  final String name;
  final String description;

  @JsonKey(name: 'actual_price')
  final double actualPrice;

  @JsonKey(name: 'discount_price')
  final double discountPrice;

  final List<ProductImage> images;
  final List<String> tags;

  @JsonKey(name: 'is_public')
  final bool isPublic;

  final String status;

  final DateTime createdAt;
  final DateTime updatedAt;

  ProductModel({
    required this.id,
    required this.user,
    required this.company,
    required this.name,
    required this.description,
    required this.actualPrice,
    required this.discountPrice,
    required this.images,
    required this.tags,
    required this.isPublic,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}

@JsonSerializable()
class UserRef {
  @JsonKey(name: '_id')
  final String id;
  final String name;

  UserRef({required this.id, required this.name});

  factory UserRef.fromJson(Map<String, dynamic> json) =>
      _$UserRefFromJson(json);

  Map<String, dynamic> toJson() => _$UserRefToJson(this);
}

@JsonSerializable()
class ProductImage {
  @JsonKey(name: '_id')
  final String id;
  final String url;

  ProductImage({required this.id, required this.url});

  factory ProductImage.fromJson(Map<String, dynamic> json) =>
      _$ProductImageFromJson(json);

  Map<String, dynamic> toJson() => _$ProductImageToJson(this);
}
