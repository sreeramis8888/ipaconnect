import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Model to hold registration data temporarily
class RegistrationData {
  final String? name;
  final String? email;
  final DateTime? dob;
  final Uint8List? profileImage;
  final String? phone;
  final String? whatsappNo;
  final String? emiratesIdCopy;
  final String? passportCopy;
  final String? profession;
  final String? location;

  RegistrationData({
    this.name,
    this.email,
    this.dob,
    this.profileImage,
    this.phone,
    this.whatsappNo,
    this.emiratesIdCopy,
    this.passportCopy,
    this.profession,
    this.location,
  });

  // Create a copy with new values
  RegistrationData copyWith({
    String? name,
    String? email,
    DateTime? dob,
    Uint8List? profileImage,
    String? phone,
    String? whatsappNo,
    String? emiratesIdCopy,
    String? passportCopy,
    String? profession,
    String? location,
  }) {
    return RegistrationData(
      name: name ?? this.name,
      email: email ?? this.email,
      dob: dob ?? this.dob,
      profileImage: profileImage ?? this.profileImage,
      phone: phone ?? this.phone,
      whatsappNo: whatsappNo ?? this.whatsappNo,
      emiratesIdCopy: emiratesIdCopy ?? this.emiratesIdCopy,
      passportCopy: passportCopy ?? this.passportCopy,
      profession: profession ?? this.profession,
      location: location ?? this.location,
    );
  }

  // Clear all data
  RegistrationData clear() {
    return RegistrationData();
  }

  @override
  String toString() {
    return 'RegistrationData(name: $name, email: $email, dob: $dob, phone: $phone, whatsappNo: $whatsappNo, profession: $profession, location: $location)';
  }
}

// Provider to hold registration data
final registrationDataProvider =
    StateNotifierProvider<RegistrationDataNotifier, RegistrationData>((ref) {
  return RegistrationDataNotifier();
});

class RegistrationDataNotifier extends StateNotifier<RegistrationData> {
  RegistrationDataNotifier() : super(RegistrationData());

  // Update individual fields
  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void updateDob(DateTime dob) {
    state = state.copyWith(dob: dob);
  }

  void updateProfileImage(Uint8List? image) {
    state = state.copyWith(profileImage: image);
  }

  void updatePhone(String phone) {
    state = state.copyWith(phone: phone);
  }

  void updateWhatsappNo(String whatsapp) {
    state = state.copyWith(whatsappNo: whatsapp);
  }

  void updateEmiratesIdCopy(String url) {
    state = state.copyWith(emiratesIdCopy: url);
  }

  void updatePassportCopy(String url) {
    state = state.copyWith(passportCopy: url);
  }

  void updateProfession(String profession) {
    state = state.copyWith(profession: profession);
  }

  void updateLocation(String location) {
    state = state.copyWith(location: location);
  }

  // Update all data at once
  void updateAllData({
    String? name,
    String? email,
    DateTime? dob,
    Uint8List? profileImage,
    String? phone,
    String? whatsappNo,
    String? emiratesIdCopy,
    String? passportCopy,
    String? profession,
    String? location,
  }) {
    state = state.copyWith(
      name: name,
      email: email,
      dob: dob,
      profileImage: profileImage,
      phone: phone,
      whatsappNo: whatsappNo,
      emiratesIdCopy: emiratesIdCopy,
      passportCopy: passportCopy,
      profession: profession,
      location: location,
    );
  }

  // Clear all data
  void clear() {
    state = state.clear();
  }
}
