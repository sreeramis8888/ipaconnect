// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
      id: json['_id'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      company: json['company'] as String,
      name: json['name'] as String,
      specifications: (json['specifications'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      actualPrice: (json['actual_price'] as num).toDouble(),
      discountPrice: (json['discount_price'] as num).toDouble(),
      images: (json['images'] as List<dynamic>)
          .map((e) => ProductImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      rating: (json['rating'] as num?)?.toDouble(),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      isPublic: json['is_public'] as bool,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'user': instance.user.toJson(),
      'company': instance.company,
      'name': instance.name,
      'specifications': instance.specifications,
      'rating': instance.rating,
      'actual_price': instance.actualPrice,
      'discount_price': instance.discountPrice,
      'images': instance.images.map((e) => e.toJson()).toList(),
      'tags': instance.tags,
      'is_public': instance.isPublic,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

ProductImage _$ProductImageFromJson(Map<String, dynamic> json) => ProductImage(
      id: json['_id'] as String,
      url: json['url'] as String,
    );

Map<String, dynamic> _$ProductImageToJson(ProductImage instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'url': instance.url,
    };
