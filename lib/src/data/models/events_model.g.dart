// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Speaker _$SpeakerFromJson(Map<String, dynamic> json) => Speaker(
      name: json['name'] as String?,
      designation: json['designation'] as String?,
      role: json['role'] as String?,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$SpeakerToJson(Speaker instance) => <String, dynamic>{
      'name': instance.name,
      'designation': instance.designation,
      'role': instance.role,
      'image': instance.image,
    };

EventsModel _$EventsModelFromJson(Map<String, dynamic> json) => EventsModel(
      id: json['id'] as String?,
      eventName: json['eventName'] as String?,
      description: json['description'] as String?,
      type: json['type'] as String?,
      image: json['image'] as String?,
      eventStartDate: json['eventStartDate'] == null
          ? null
          : DateTime.parse(json['eventStartDate'] as String),
      eventEndDate: json['eventEndDate'] == null
          ? null
          : DateTime.parse(json['eventEndDate'] as String),
      posterVisibilityStartDate: json['posterVisibilityStartDate'] == null
          ? null
          : DateTime.parse(json['posterVisibilityStartDate'] as String),
      posterVisibilityEndDate: json['posterVisibilityEndDate'] == null
          ? null
          : DateTime.parse(json['posterVisibilityEndDate'] as String),
      platform: json['platform'] as String?,
      link: json['link'] as String?,
      venue: json['venue'] as String?,
      organiserName: json['organiserName'] as String?,
      coordinators: (json['coordinators'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      limit: (json['limit'] as num?)?.toInt(),
      speakers: (json['speakers'] as List<dynamic>?)
          ?.map((e) => Speaker.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as String?,
      rsvp: (json['rsvp'] as List<dynamic>?)?.map((e) => e as String).toList(),
      attendence: (json['attendence'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$EventsModelToJson(EventsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'eventName': instance.eventName,
      'description': instance.description,
      'type': instance.type,
      'image': instance.image,
      'eventStartDate': instance.eventStartDate?.toIso8601String(),
      'eventEndDate': instance.eventEndDate?.toIso8601String(),
      'posterVisibilityStartDate':
          instance.posterVisibilityStartDate?.toIso8601String(),
      'posterVisibilityEndDate':
          instance.posterVisibilityEndDate?.toIso8601String(),
      'platform': instance.platform,
      'link': instance.link,
      'venue': instance.venue,
      'organiserName': instance.organiserName,
      'coordinators': instance.coordinators,
      'limit': instance.limit,
      'speakers': instance.speakers,
      'status': instance.status,
      'rsvp': instance.rsvp,
      'attendence': instance.attendence,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
