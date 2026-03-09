class BoardMember {
  final String? name;
  final String? image;
  final String? role;

  BoardMember({this.name, this.image, this.role});

  factory BoardMember.fromJson(Map<String, dynamic> json) {
    return BoardMember(
      name: json['name'] as String?,
      image: json['image'] as String?,
      role: json['role'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
      'role': role,
    };
  }
}
