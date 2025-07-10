import 'package:ipaconnect/src/data/models/user_model.dart';

class RatingModel {
  final String id;
  final String targetId;
  final String targetType;
  final int rating;
  final String review;
  final DateTime createdAt;
  final UserModel user;

  RatingModel({
    required this.id,
    required this.targetId,
    required this.targetType,
    required this.rating,
    required this.review,
    required this.createdAt,
    required this.user,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
        id: json['_id']?.toString() ?? '',
        targetId: json['targetId']?.toString() ?? '',
        targetType: json['targetType']?.toString() ?? '',
        rating: json['rating'] is int
            ? json['rating']
            : int.tryParse(json['rating']?.toString() ?? '') ?? 0,
        review: json['comment']?.toString() ?? '',
        createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
            DateTime.now(),
        user: json['user'] != null && json['user'] is Map<String, dynamic>
            ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
            : UserModel());
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': {
        '_id': user.id,
        'name': user.name,
      },
      'targetId': targetId,
      'targetType': targetType,
      'rating': rating,
      'review': review,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
