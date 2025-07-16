import 'package:ipaconnect/src/data/models/user_model.dart';

class HierarchyModel {
  final String? id;
  final String? name;
  final String? description;
  final String? status;
  final List<UserModel>? admins;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? image;
  HierarchyModel({
    this.id,
    this.name,
    this.description,
    this.status,
    this.image,
    this.admins,
    this.createdAt,
    this.updatedAt,
  });

  factory HierarchyModel.fromJson(Map<String, dynamic> json) {
    return HierarchyModel(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      image: json['image'] as String?,
      description: json['description'] as String?,
      status: json['status'] as String?,
      admins: (json['admins'] as List<dynamic>?)
          ?.map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'image': image,
      'description': description,
      'status': status,
      'admins': admins?.map((e) => e.toJson()).toList(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
