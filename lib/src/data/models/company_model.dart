import 'package:ipaconnect/src/data/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'company_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CompanyModel {
  @JsonKey(name: '_id')
  final String? id;
  final String? name;
  final String? overview;
  final String? category;
  final String? image;
  final String? status;

  @JsonKey(name: 'established_date')
  final int? establishedDate;

  @JsonKey(name: 'company_size')
  final String? companySize;

  final List<String>? services;
  final List<String>? tags;

  final UserModel? user;

  final double? rating;

  final SocialMedia? socialMedia;

  @JsonKey(name: 'opening_hours')
  final OpeningHours? openingHours;

  @JsonKey(name: 'contact_info')
  final ContactInfo? contactInfo;

  final Gallery? gallery;

  CompanyModel({
    this.id,
    this.name,
    this.overview,
    this.category,
    this.image,
    this.status,
    this.establishedDate,
    this.companySize,
    this.services,
    this.tags,
    this.user,
    this.rating,
    this.socialMedia,
    this.openingHours,
    this.contactInfo,
    this.gallery,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) =>
      _$CompanyModelFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyModelToJson(this);

  CompanyModel copyWith({
    String? id,
    String? name,
    String? overview,
    String? category,
    String? image,
    String? status,
    int? establishedDate,
    String? companySize,
    List<String>? services,
    List<String>? tags,
    UserModel? user,
    double? rating,
    SocialMedia? socialMedia,
    OpeningHours? openingHours,
    ContactInfo? contactInfo,
    Gallery? gallery,
  }) {
    return CompanyModel(
      id: id ?? this.id,
      name: name ?? this.name,
      overview: overview ?? this.overview,
      category: category ?? this.category,
      image: image ?? this.image,
      status: status ?? this.status,
      establishedDate: establishedDate ?? this.establishedDate,
      companySize: companySize ?? this.companySize,
      services: services ?? this.services,
      tags: tags ?? this.tags,
      user: user ?? this.user,
      rating: rating ?? this.rating,
      socialMedia: socialMedia ?? this.socialMedia,
      openingHours: openingHours ?? this.openingHours,
      contactInfo: contactInfo ?? this.contactInfo,
      gallery: gallery ?? this.gallery,
    );
  }
}

@JsonSerializable()
class SocialMedia {
  final String? twitter;
  final String? facebook;
  final String? instagram;
  final String? linkedin;

  SocialMedia({
    this.twitter,
    this.facebook,
    this.instagram,
    this.linkedin,
  });

  factory SocialMedia.fromJson(Map<String, dynamic> json) =>
      _$SocialMediaFromJson(json);

  Map<String, dynamic> toJson() => _$SocialMediaToJson(this);
}

@JsonSerializable()
class OpeningHours {
  final String? sunday;
  final String? monday;
  final String? tuesday;
  final String? wednesday;
  final String? thursday;
  final String? friday;
  final String? saturday;

  OpeningHours({
    this.sunday,
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
  });

  factory OpeningHours.fromJson(Map<String, dynamic> json) =>
      _$OpeningHoursFromJson(json);

  Map<String, dynamic> toJson() => _$OpeningHoursToJson(this);
}

@JsonSerializable()
class ContactInfo {
  final String? address;
  final String? phone;
  final String? email;
  final String? website;

  ContactInfo({
    this.address,
    this.phone,
    this.email,
    this.website,
  });

  factory ContactInfo.fromJson(Map<String, dynamic> json) =>
      _$ContactInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ContactInfoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Gallery {
  final List<MediaItem>? photos;
  final List<MediaItem>? videos;

  Gallery({this.photos, this.videos});

  factory Gallery.fromJson(Map<String, dynamic> json) =>
      _$GalleryFromJson(json);

  Map<String, dynamic> toJson() => _$GalleryToJson(this);
}

@JsonSerializable()
class MediaItem {
  @JsonKey(name: '_id')
  final String? id;
  final String? url;
  //heading for non-youtube videos
  final String? text;

  MediaItem({this.id, this.url, this.text});

  factory MediaItem.fromJson(Map<String, dynamic> json) =>
      _$MediaItemFromJson(json);

  Map<String, dynamic> toJson() => _$MediaItemToJson(this);
}
