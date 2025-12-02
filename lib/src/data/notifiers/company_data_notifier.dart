import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Model to hold company creation data temporarily
class CompanyData {
  final String? name;
  final String? status;
  final String? overview;
  final String? category;
  final String? image;
  final int? establishedDate;
  final String? companySize;
  final List<String>? services;
  final String? location;
  final bool? nameInTradeLicense;
  final String? recommendedBy;
  final String? businessEmirate;
  final List<String>? tags;

  // Opening Hours
  final String? sunday;
  final String? monday;
  final String? tuesday;
  final String? wednesday;
  final String? thursday;
  final String? friday;
  final String? saturday;

  // Contact Info
  final String? address;
  final String? phone;
  final String? email;
  final String? website;

  // Gallery
  final List<String>? galleryPhotoUrls;
  final List<String>? videoUrls;

  // Trade License
  final String? tradeLicenseUrl;

  CompanyData({
    this.name,
    this.status,
    this.overview,
    this.category,
    this.image,
    this.establishedDate,
    this.companySize,
    this.services,
    this.location,
    this.nameInTradeLicense,
    this.recommendedBy,
    this.businessEmirate,
    this.tags,
    this.sunday,
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
    this.address,
    this.phone,
    this.email,
    this.website,
    this.galleryPhotoUrls,
    this.videoUrls,
    this.tradeLicenseUrl,
  });

  // Create a copy with new values
  CompanyData copyWith({
    String? name,
    String? status,
    String? overview,
    String? category,
    String? image,
    int? establishedDate,
    String? companySize,
    List<String>? services,
    String? location,
    bool? nameInTradeLicense,
    String? recommendedBy,
    String? businessEmirate,
    List<String>? tags,
    String? sunday,
    String? monday,
    String? tuesday,
    String? wednesday,
    String? thursday,
    String? friday,
    String? saturday,
    String? address,
    String? phone,
    String? email,
    String? website,
    List<String>? galleryPhotoUrls,
    List<String>? videoUrls,
    String? tradeLicenseUrl,
  }) {
    return CompanyData(
      name: name ?? this.name,
      status: status ?? this.status,
      overview: overview ?? this.overview,
      category: category ?? this.category,
      image: image ?? this.image,
      establishedDate: establishedDate ?? this.establishedDate,
      companySize: companySize ?? this.companySize,
      services: services ?? this.services,
      location: location ?? this.location,
      nameInTradeLicense: nameInTradeLicense ?? this.nameInTradeLicense,
      recommendedBy: recommendedBy ?? this.recommendedBy,
      businessEmirate: businessEmirate ?? this.businessEmirate,
      tags: tags ?? this.tags,
      sunday: sunday ?? this.sunday,
      monday: monday ?? this.monday,
      tuesday: tuesday ?? this.tuesday,
      wednesday: wednesday ?? this.wednesday,
      thursday: thursday ?? this.thursday,
      friday: friday ?? this.friday,
      saturday: saturday ?? this.saturday,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      website: website ?? this.website,
      galleryPhotoUrls: galleryPhotoUrls ?? this.galleryPhotoUrls,
      videoUrls: videoUrls ?? this.videoUrls,
      tradeLicenseUrl: tradeLicenseUrl ?? this.tradeLicenseUrl,
    );
  }

  // Clear all data
  CompanyData clear() {
    return CompanyData();
  }

  @override
  String toString() {
    return 'CompanyData(name: $name, category: $category, location: $location, businessEmirate: $businessEmirate)';
  }
}

// Provider to hold company data
final companyDataProvider =
    StateNotifierProvider<CompanyDataNotifier, CompanyData>((ref) {
  return CompanyDataNotifier();
});

class CompanyDataNotifier extends StateNotifier<CompanyData> {
  CompanyDataNotifier() : super(CompanyData());

  // Update individual fields
  void updateName(String? name) {
    state = state.copyWith(name: name);
  }

  void updateStatus(String? status) {
    state = state.copyWith(status: status);
  }

  void updateOverview(String? overview) {
    state = state.copyWith(overview: overview);
  }

  void updateCategory(String? category) {
    state = state.copyWith(category: category);
  }

  void updateImage(String? image) {
    state = state.copyWith(image: image);
  }

  void updateEstablishedDate(int? establishedDate) {
    state = state.copyWith(establishedDate: establishedDate);
  }

  void updateCompanySize(String? companySize) {
    state = state.copyWith(companySize: companySize);
  }

  void updateServices(List<String>? services) {
    state = state.copyWith(services: services);
  }

  void updateLocation(String? location) {
    state = state.copyWith(location: location);
  }

  void updateNameInTradeLicense(bool? nameInTradeLicense) {
    state = state.copyWith(nameInTradeLicense: nameInTradeLicense);
  }

  void updateRecommendedBy(String? recommendedBy) {
    state = state.copyWith(recommendedBy: recommendedBy);
  }

  void updateBusinessEmirate(String? businessEmirate) {
    state = state.copyWith(businessEmirate: businessEmirate);
  }

  void updateTags(List<String>? tags) {
    state = state.copyWith(tags: tags);
  }

  // Opening Hours updates
  void updateSunday(String? sunday) {
    state = state.copyWith(sunday: sunday);
  }

  void updateMonday(String? monday) {
    state = state.copyWith(monday: monday);
  }

  void updateTuesday(String? tuesday) {
    state = state.copyWith(tuesday: tuesday);
  }

  void updateWednesday(String? wednesday) {
    state = state.copyWith(wednesday: wednesday);
  }

  void updateThursday(String? thursday) {
    state = state.copyWith(thursday: thursday);
  }

  void updateFriday(String? friday) {
    state = state.copyWith(friday: friday);
  }

  void updateSaturday(String? saturday) {
    state = state.copyWith(saturday: saturday);
  }

  // Contact Info updates
  void updateAddress(String? address) {
    state = state.copyWith(address: address);
  }

  void updatePhone(String? phone) {
    state = state.copyWith(phone: phone);
  }

  void updateEmail(String? email) {
    state = state.copyWith(email: email);
  }

  void updateWebsite(String? website) {
    state = state.copyWith(website: website);
  }

  // Gallery updates
  void updateGalleryPhotoUrls(List<String>? galleryPhotoUrls) {
    state = state.copyWith(galleryPhotoUrls: galleryPhotoUrls);
  }

  void updateVideoUrls(List<String>? videoUrls) {
    state = state.copyWith(videoUrls: videoUrls);
  }

  void updateTradeLicenseUrl(String? tradeLicenseUrl) {
    state = state.copyWith(tradeLicenseUrl: tradeLicenseUrl);
  }

  // Update all data at once
  void updateAllData({
    String? name,
    String? status,
    String? overview,
    String? category,
    String? image,
    int? establishedDate,
    String? companySize,
    List<String>? services,
    String? location,
    bool? nameInTradeLicense,
    String? recommendedBy,
    String? businessEmirate,
    List<String>? tags,
    String? sunday,
    String? monday,
    String? tuesday,
    String? wednesday,
    String? thursday,
    String? friday,
    String? saturday,
    String? address,
    String? phone,
    String? email,
    String? website,
    List<String>? galleryPhotoUrls,
    List<String>? videoUrls,
    String? tradeLicenseUrl,
  }) {
    state = state.copyWith(
      name: name,
      status: status,
      overview: overview,
      category: category,
      image: image,
      establishedDate: establishedDate,
      companySize: companySize,
      services: services,
      location: location,
      nameInTradeLicense: nameInTradeLicense,
      recommendedBy: recommendedBy,
      businessEmirate: businessEmirate,
      tags: tags,
      sunday: sunday,
      monday: monday,
      tuesday: tuesday,
      wednesday: wednesday,
      thursday: thursday,
      friday: friday,
      saturday: saturday,
      address: address,
      phone: phone,
      email: email,
      website: website,
      galleryPhotoUrls: galleryPhotoUrls,
      videoUrls: videoUrls,
      tradeLicenseUrl: tradeLicenseUrl,
    );
  }

  // Clear all data
  void clear() {
    state = state.clear();
  }
}
