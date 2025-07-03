class EventsModel {
  final String? id;
  final String? eventName;
  final String? description;
  final String? type;
  final String? image;
  final DateTime? eventStartDate;
  final DateTime? eventEndDate;
  final DateTime? posterVisibilityStartDate;
  final DateTime? posterVisibilityEndDate;
  final String? platform;
  final String? link;
  final String? venue;
  final String? organiserName;
  final List<String>? coordinators;
  final int? limit;
  final List<Speaker>? speakers;
  final String? status;
  final List<String>? rsvp;
  final List<String>? attendence;
  final bool? isIpaOfficial;
  final String? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  EventsModel({
    this.id,
    this.eventName,
    this.description,
    this.type,
    this.image,
    this.eventStartDate,
    this.eventEndDate,
    this.posterVisibilityStartDate,
    this.posterVisibilityEndDate,
    this.platform,
    this.link,
    this.venue,
    this.organiserName,
    this.coordinators,
    this.limit,
    this.speakers,
    this.status,
    this.rsvp,
    this.attendence,
    this.isIpaOfficial,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory EventsModel.fromJson(Map<String, dynamic> json) {
    return EventsModel(
      id: json['_id']?.toString(),
      eventName: json['event_name'],
      description: json['description'],
      type: json['type'],
      image: json['image'],
      eventStartDate: json['event_start_date'] != null
          ? DateTime.tryParse(json['event_start_date'])
          : null,
      eventEndDate: json['event_end_date'] != null
          ? DateTime.tryParse(json['event_end_date'])
          : null,
      posterVisibilityStartDate: json['poster_visibility_start_date'] != null
          ? DateTime.tryParse(json['poster_visibility_start_date'])
          : null,
      posterVisibilityEndDate: json['poster_visibility_end_date'] != null
          ? DateTime.tryParse(json['poster_visibility_end_date'])
          : null,
      platform: json['platform'],
      link: json['link'],
      venue: json['venue'],
      organiserName: json['organiser_name'],
      coordinators: (json['coordinators'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      limit: json['limit'],
      speakers: (json['speakers'] as List<dynamic>?)
          ?.map((e) => Speaker.fromJson(e))
          .toList(),
      status: json['status'],
      rsvp: (json['rsvp'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      attendence:
          (json['attendence'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      isIpaOfficial: json['is_ipa_official'] ?? false,
      createdBy: json['created_by']?.toString(),
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
      'event_name': eventName,
      'description': description,
      'type': type,
      'image': image,
      'event_start_date': eventStartDate?.toIso8601String(),
      'event_end_date': eventEndDate?.toIso8601String(),
      'poster_visibility_start_date':
          posterVisibilityStartDate?.toIso8601String(),
      'poster_visibility_end_date':
          posterVisibilityEndDate?.toIso8601String(),
      'platform': platform,
      'link': link,
      'venue': venue,
      'organiser_name': organiserName,
      'coordinators': coordinators,
      'limit': limit,
      'speakers': speakers?.map((e) => e.toJson()).toList(),
      'status': status,
      'rsvp': rsvp,
      'attendence': attendence,
      'is_ipa_official': isIpaOfficial,
      'created_by': createdBy,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class Speaker {
  final String? name;
  final String? designation;
  final String? role;
  final String? image;

  Speaker({
    this.name,
    this.designation,
    this.role,
    this.image,
  });

  factory Speaker.fromJson(Map<String, dynamic> json) {
    return Speaker(
      name: json['name'],
      designation: json['designation'],
      role: json['role'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'designation': designation,
      'role': role,
      'image': image,
    };
  }
}
