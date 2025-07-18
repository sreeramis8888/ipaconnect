import 'package:ipaconnect/src/data/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductModel {
  @JsonKey(name: '_id')
  final String id;

  final UserModel user;
  final String company;
  final String name;
  final List<String> specifications;
  final double? rating;
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
    required this.specifications,
    required this.actualPrice,
    required this.discountPrice,
    required this.images,
    required this.rating,
    required this.tags,
    required this.isPublic,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

  ProductModel copyWith({
    String? id,
    UserModel? user,
    String? company,
    String? name,
    List<String>? specifications,
    double? rating,
    double? actualPrice,
    double? discountPrice,
    List<ProductImage>? images,
    List<String>? tags,
    bool? isPublic,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      user: user ?? this.user,
      company: company ?? this.company,
      name: name ?? this.name,
      specifications: specifications ?? this.specifications,
      rating: rating ?? this.rating,
      actualPrice: actualPrice ?? this.actualPrice,
      discountPrice: discountPrice ?? this.discountPrice,
      images: images ?? this.images,
      tags: tags ?? this.tags,
      isPublic: isPublic ?? this.isPublic,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
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
