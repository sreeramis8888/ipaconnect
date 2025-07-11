import 'package:json_annotation/json_annotation.dart';

part 'cart_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CartModel {
  @JsonKey(name: '_id')
  final String? id;

  final String? user;
  final List<CartProduct>? products;
  
  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;
  
  @JsonKey(name: 'updatedAt')
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

  CartModel copyWith({
    String? id,
    String? user,
    List<CartProduct>? products,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CartModel(
      id: id ?? this.id,
      user: user ?? this.user,
      products: products ?? this.products,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

@JsonSerializable(explicitToJson: true)
class CartProduct {
  final String? store;
  final int? quantity;

  CartProduct({
    this.store,
    this.quantity,
  });

  factory CartProduct.fromJson(Map<String, dynamic> json) =>
      _$CartProductFromJson(json);

  Map<String, dynamic> toJson() => _$CartProductToJson(this);

  CartProduct copyWith({
    String? store,
    int? quantity,
  }) {
    return CartProduct(
      store: store ?? this.store,
      quantity: quantity ?? this.quantity,
    );
  }
} 