class RatingModel {
  final String id;
  final String userId;
  final String userName;
  final String targetId;
  final String targetType;
  final int rating;
  final String review;
  final DateTime createdAt;

  RatingModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.targetId,
    required this.targetType,
    required this.rating,
    required this.review,
    required this.createdAt,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      id: json['_id'] ?? '',
      userId: json['user'] ?? '',
      userName: json['user']?['name'] ?? '',
      targetId: json['targetId'] ?? '',
      targetType: json['targetType'] ?? '',
      rating: json['rating'] ?? 0,
      review: json['review'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': {
        '_id': userId,
        'name': userName,
      },
      'targetId': targetId,
      'targetType': targetType,
      'rating': rating,
      'review': review,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
