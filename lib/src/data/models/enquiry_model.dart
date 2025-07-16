class EnquiryModel {
  final String? id;
  final String? user;
  final String? name;
  final String? phone;
  final String? email;
  final String? message;
  final DateTime? createdAt;

  EnquiryModel({
    this.id,
    this.user,
    this.name,
    this.phone,
    this.email,
    this.message,
    this.createdAt,
  });

  factory EnquiryModel.fromJson(Map<String, dynamic> json) => EnquiryModel(
        id: json['_id'] as String?,
        user: json['user'] as String?,
        name: json['name'] as String?,
        phone: json['phone'] as String?,
        email: json['email'] as String?,
        message: json['message'] as String?,
        createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'user': user,
        'name': name,
        'phone': phone,
        'email': email,
        'message': message,
        'createdAt': createdAt?.toIso8601String(),
      };
} 