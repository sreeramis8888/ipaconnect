class BoardMember {
  final String? id;
  final String? name;
  final String? image;
  final String? role;
  final String? company;
  final int? priority;

  BoardMember(
      {this.id, this.name, this.image, this.role, this.company, this.priority});

  factory BoardMember.fromJson(Map<String, dynamic> json) {
    return BoardMember(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      image: json['image'] as String?,
      role: json['role'] as String?,
      company: json['company'] as String?,
      priority: json['priority'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'image': image,
      'role': role,
      'company': company,
      'priority': priority,
    };
  }
}
