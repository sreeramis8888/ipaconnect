class AnalyticsModel {
  final String? id;
  final String? type;
  final SenderReceiver? sender;
  final SenderReceiver? receiver;
  final String? title;
  final String? description;
  final int? amount;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Referral? referral;
  final String? contact;
  final String? meetingLink;
  final String? location;
  final String? time;

  AnalyticsModel({
    this.id,
    this.type,
    this.sender,
    this.receiver,
    this.title,
    this.description,
    this.amount,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.referral,
    this.contact,
    this.meetingLink,
    this.location,
    this.time,
  });

  factory AnalyticsModel.fromJson(Map<String, dynamic> json) {
    return AnalyticsModel(
      id: json['_id'] as String?,
      type: json['type'] as String?,
      sender: json['sender'] != null ? SenderReceiver.fromJson(json['sender']) : null,
      receiver: json['receiver'] != null ? SenderReceiver.fromJson(json['receiver']) : null,
      title: json['title'] as String?,
      description: json['description'] as String?,
      amount: json['amount'] as int?,
      status: json['status'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
      referral: json['referral'] != null ? Referral.fromJson(json['referral']) : null,
      contact: json['contact'] as String?,
      meetingLink: json['meetingLink'] as String?,
      location: json['location'] as String?,
      time: json['time'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'type': type,
      'sender': sender?.toJson(),
      'receiver': receiver?.toJson(),
      'title': title,
      'description': description,
      'amount': amount,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'referral': referral?.toJson(),
      'contact': contact,
      'meetingLink': meetingLink,
      'location': location,
      'time': time,
    };
  }

  AnalyticsModel copyWith({
    String? id,
    String? type,
    SenderReceiver? sender,
    SenderReceiver? receiver,
    String? title,
    String? description,
    int? amount,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    Referral? referral,
    String? contact,
    String? meetingLink,
    String? location,
    String? time,
  }) {
    return AnalyticsModel(
      id: id ?? this.id,
      type: type ?? this.type,
      sender: sender ?? this.sender,
      receiver: receiver ?? this.receiver,
      title: title ?? this.title,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      referral: referral ?? this.referral,
      contact: contact ?? this.contact,
      meetingLink: meetingLink ?? this.meetingLink,
      location: location ?? this.location,
      time: time ?? this.time,
    );
  }
}

class SenderReceiver {
  final String? id;
  final String? name;
  final String? image;

  SenderReceiver({
    this.id,
    this.name,
    this.image,
  });

  factory SenderReceiver.fromJson(Map<String, dynamic> json) {
    return SenderReceiver(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      image: json['image'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'image': image,
    };
  }
}

class Referral {
  final String name;
  final String email;
  final String phone;
  final String address;
  final String info;

  Referral({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.info,
  });

  factory Referral.fromJson(Map<String, dynamic> json) {
    return Referral(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      info: json['info'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'info': info,
    };
  }
}
