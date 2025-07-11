import 'package:json_annotation/json_annotation.dart';
import 'store_model.dart';

part 'cart_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CartProduct {
  final StoreModel? store;
  final int? quantity;

  CartProduct({
    this.store,
    this.quantity,
  });

  factory CartProduct.fromJson(Map<String, dynamic> json) =>
      _$CartProductFromJson(json);

  Map<String, dynamic> toJson() => _$CartProductToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CartModel {
   @JsonKey(name: '_id')
  final String? id;
  final String? user;
  final List<CartProduct>? products;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CartModel({
    this.id,
    this.user,
    this.products,
    this.createdAt,
    this.updatedAt,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) =>
      _$CartModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartModelToJson(this);
} 