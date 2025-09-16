// import 'package:flutter/material.dart';
// import 'package:contact_add/contact.dart';
// import 'package:contact_add/contact_add.dart';


// Future<void> saveContact(
//     {required String number,
//     required String firstName,
//     required String email,
//     required BuildContext context}) async {
//   // SnackbarService snackbarService = SnackbarService();
//   // Request permission to access contacts
//   final Contact contact =
//       Contact(firstname: firstName, lastname: '', phone: number, email: email);

//   final bool success = await ContactAdd.addContact(contact);

//   if (success) {
//     // snackbarService.showSnackBar('Contact saved successfully!');
//   } else {
//     // snackbarService.showSnackBar('Contact saving failed!');
//   }
// }


import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter/material.dart';
import 'package:ipaconnect/src/data/models/user_model.dart';
import 'package:ipaconnect/src/data/services/snackbar_service.dart';
Future<void> saveContactWithSocial({
  required String number,
  required String firstName,
  String? email,
  List<UserSocialMedia>? socialMediaList,
}) async {
  SnackbarService snackbarService = SnackbarService();
  if (!await FlutterContacts.requestPermission()) {
    debugPrint("Permission denied to access contacts");
    return;
  }

  final contact = Contact()
    ..name.first = firstName
    ..phones = [Phone(number)];

  if (email != null && email.isNotEmpty) {
    contact.emails = [Email(email)];
  }

  if (socialMediaList != null && socialMediaList.isNotEmpty) {
    contact.socialMedias = socialMediaList.map((sm) {
      final platform = sm.name?.toLowerCase() ?? '';
      SocialMediaLabel label;

      switch (platform) {
        case 'facebook':
          label = SocialMediaLabel.facebook;
          break;
        case 'twitter':
          label = SocialMediaLabel.twitter;
          break;
        case 'instagram':
          label = SocialMediaLabel.instagram;
          break;
        case 'linkedin':
          label = SocialMediaLabel.linkedIn;
          break;
        default:
          label = SocialMediaLabel.custom;
      }

      return SocialMedia(
        sm.url ?? '',
        label: label,
        customLabel: label == SocialMediaLabel.custom ? (sm.name ?? '') : '',
      );
    }).toList();
  }

  try {
    await contact.insert();
    debugPrint("Contact saved: ${contact.name.first}");
    snackbarService.showSnackBar('Contact saved successfully!');
  } catch (e) {
    debugPrint("Error saving contact: $e");
  }
}
