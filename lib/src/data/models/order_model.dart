import 'package:ipaconnect/src/data/models/store_model.dart';
import 'package:ipaconnect/src/data/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_model.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderModel {
  @JsonKey(name: '_id')
  final String? id;

  final UserModel? user;
  final StoreModel? store;
  final double? amount;
  final int? quantity;
  final String? currency;

  @JsonKey(name: 'shipping_address')
  final ShippingAddress? shippingAddress;

  @JsonKey(name: 'payment_id')
  final String? paymentId;
  final String? receipt;
  final String? status;

  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;

  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAt;

  OrderModel({
    this.id,
    this.user,
    this.store,
    this.amount,
    this.quantity,
    this.currency,
    this.shippingAddress,
    this.paymentId,
    this.receipt,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);

  OrderModel copyWith({
    String? id,
    UserModel? user,
    StoreModel? store,
    double? amount,
    int? quantity,
    String? currency,
    ShippingAddress? shippingAddress,
    String? paymentId,
    String? receipt,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      user: user ?? this.user,
      store: store ?? this.store,
      amount: amount ?? this.amount,
      quantity: quantity ?? this.quantity,
      currency: currency ?? this.currency,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      paymentId: paymentId ?? this.paymentId,
      receipt: receipt ?? this.receipt,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ShippingAddress {
  final String? name;
  final String? phone;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? pincode;

  @JsonKey(name: 'is_saved')
  final bool? isSaved;

  ShippingAddress({
    this.name,
    this.phone,
    this.address,
    this.city,
    this.state,
    this.country,
    this.pincode,
    this.isSaved,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) =>
      _$ShippingAddressFromJson(json);

  Map<String, dynamic> toJson() => _$ShippingAddressToJson(this);

  ShippingAddress copyWith({
    String? name,
    String? phone,
    String? address,
    String? city,
    String? state,
    String? country,
    String? pincode,
    bool? isSaved,
  }) {
    return ShippingAddress(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      pincode: pincode ?? this.pincode,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}
