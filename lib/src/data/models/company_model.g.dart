// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanyModel _$CompanyModelFromJson(Map<String, dynamic> json) => CompanyModel(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      overview: json['overview'] as String?,
      category: json['category'] as String?,
      image: json['image'] as String?,
      status: json['status'] as String?,
      location: json['location'] as String?,
      tradeLicenseCopy: json['trade_license_copy'] as String?,
      businessEmirates: $enumDecodeNullable(
          _$BusinessEmiratesEnumMap, json['business_emirates']),
      recommendedBy: json['recommended_by'] as String?,
      nameInTradeLicense: json['name_in_trade_license'] as bool?,
      establishedDate: (json['established_date'] as num?)?.toInt(),
      companySize: json['company_size'] as String?,
      services: (json['services'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      user: CompanyModel._userFromJson(json['user']),
      rating: (json['rating'] as num?)?.toDouble(),
      socialMedia: json['socialMedia'] == null
          ? null
          : SocialMedia.fromJson(json['socialMedia'] as Map<String, dynamic>),
      openingHours: json['opening_hours'] == null
          ? null
          : OpeningHours.fromJson(
              json['opening_hours'] as Map<String, dynamic>),
      contactInfo: json['contact_info'] == null
          ? null
          : ContactInfo.fromJson(json['contact_info'] as Map<String, dynamic>),
      gallery: json['gallery'] == null
          ? null
          : Gallery.fromJson(json['gallery'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CompanyModelToJson(CompanyModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'overview': instance.overview,
      'category': instance.category,
      'image': instance.image,
      'status': instance.status,
      'location': instance.location,
      'trade_license_copy': instance.tradeLicenseCopy,
      'business_emirates': _$BusinessEmiratesEnumMap[instance.businessEmirates],
      'recommended_by': instance.recommendedBy,
      'name_in_trade_license': instance.nameInTradeLicense,
      'established_date': instance.establishedDate,
      'company_size': instance.companySize,
      'services': instance.services,
      'tags': instance.tags,
      'user': instance.user?.toJson(),
      'rating': instance.rating,
      'socialMedia': instance.socialMedia?.toJson(),
      'opening_hours': instance.openingHours?.toJson(),
      'contact_info': instance.contactInfo?.toJson(),
      'gallery': instance.gallery?.toJson(),
    };

const _$BusinessEmiratesEnumMap = {
  BusinessEmirates.dubai: 'dubai',
  BusinessEmirates.abudhabi: 'abudhabi',
  BusinessEmirates.sharjah: 'sharjah',
  BusinessEmirates.ummAlQuwain: 'ummAlQuwain',
  BusinessEmirates.ajman: 'ajman',
  BusinessEmirates.rasAlKhaimah: 'rasAlKhaimah',
  BusinessEmirates.fujairah: 'fujairah',
};

SocialMedia _$SocialMediaFromJson(Map<String, dynamic> json) => SocialMedia(
      twitter: json['twitter'] as String?,
      facebook: json['facebook'] as String?,
      instagram: json['instagram'] as String?,
      linkedin: json['linkedin'] as String?,
    );

Map<String, dynamic> _$SocialMediaToJson(SocialMedia instance) =>
    <String, dynamic>{
      'twitter': instance.twitter,
      'facebook': instance.facebook,
      'instagram': instance.instagram,
      'linkedin': instance.linkedin,
    };

OpeningHours _$OpeningHoursFromJson(Map<String, dynamic> json) => OpeningHours(
      sunday: json['sunday'] as String?,
      monday: json['monday'] as String?,
      tuesday: json['tuesday'] as String?,
      wednesday: json['wednesday'] as String?,
      thursday: json['thursday'] as String?,
      friday: json['friday'] as String?,
      saturday: json['saturday'] as String?,
    );

Map<String, dynamic> _$OpeningHoursToJson(OpeningHours instance) =>
    <String, dynamic>{
      'sunday': instance.sunday,
      'monday': instance.monday,
      'tuesday': instance.tuesday,
      'wednesday': instance.wednesday,
      'thursday': instance.thursday,
      'friday': instance.friday,
      'saturday': instance.saturday,
    };

ContactInfo _$ContactInfoFromJson(Map<String, dynamic> json) => ContactInfo(
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      website: json['website'] as String?,
    );

Map<String, dynamic> _$ContactInfoToJson(ContactInfo instance) =>
    <String, dynamic>{
      'address': instance.address,
      'phone': instance.phone,
      'email': instance.email,
      'website': instance.website,
    };

Gallery _$GalleryFromJson(Map<String, dynamic> json) => Gallery(
      photos: (json['photos'] as List<dynamic>?)
          ?.map((e) => MediaItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      videos: (json['videos'] as List<dynamic>?)
          ?.map((e) => MediaItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GalleryToJson(Gallery instance) => <String, dynamic>{
      'photos': instance.photos?.map((e) => e.toJson()).toList(),
      'videos': instance.videos?.map((e) => e.toJson()).toList(),
    };

MediaItem _$MediaItemFromJson(Map<String, dynamic> json) => MediaItem(
      id: json['_id'] as String?,
      url: json['url'] as String?,
    );

Map<String, dynamic> _$MediaItemToJson(MediaItem instance) => <String, dynamic>{
      '_id': instance.id,
      'url': instance.url,
    };
