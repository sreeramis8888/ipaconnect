import 'package:json_annotation/json_annotation.dart';

part 'events_model.g.dart';

@JsonSerializable()
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

  factory Speaker.fromJson(Map<String, dynamic> json) =>
      _$SpeakerFromJson(json);
  Map<String, dynamic> toJson() => _$SpeakerToJson(this);
}

@JsonSerializable()
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
    this.createdAt,
    this.updatedAt,
  });

  factory EventsModel.fromJson(Map<String, dynamic> json) =>
      _$EventsModelFromJson(json);

  Map<String, dynamic> toJson() => _$EventsModelToJson(this);

  static const List<String> types = [
    'Online',
    'Offline',
  ];

  static const List<String> statuses = [
    'pending',
    'live',
    'completed',
    'cancelled',
  ];
}
