import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/models/user_model.dart';
import 'package:ipaconnect/src/data/services/api_routes/user_api/user_data/user_data_api.dart';

class UserNotifier extends StateNotifier<AsyncValue<UserModel>> {
  final Ref<AsyncValue<UserModel>> ref;

  UserNotifier(this.ref) : super(const AsyncValue.loading()) {
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    if (mounted) {
      await _fetchUserDetails();
    }
  }

  Future<void> refreshUser() async {
    if (mounted) {
      state = const AsyncValue.loading();
      await _fetchUserDetails();
    }
  }

  Future<void> _fetchUserDetails() async {
    try {
      log('Fetching user details');
      final user = await ref.read(getUserDetailsProvider.future);
      state = AsyncValue.data(user ?? UserModel());
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      log('Error fetching user details: $e');
      log(stackTrace.toString());
    }
  }

  void updateName({
    String? name,
  }) {
    state = state.whenData((user) => user.copyWith(name: name));
  }

  void updateProfession({
    String? profession,
  }) {
    state = state.whenData((user) => user.copyWith(
          profession: profession,
        ));
  }

  void updateBio({
    String? bio,
  }) {
    state = state.whenData((user) => user.copyWith(
          bio: bio,
        ));
  }

  void updateEmail(String? email) {
    state = state.whenData((user) => user.copyWith(email: email));
  }

  // void updateBio(String? bio) {
  //   state = state.whenData((user) => user.copyWith(bio: bio));
  // }

  void updateAddress(String? location) {
    state = state.whenData((user) => user.copyWith(location: location));
  }

  void updateProfilePicture(String? profilePicture) {
    state = state.whenData((user) => user.copyWith(image: profilePicture));
  }

  // void updateAwards(List<Award> awards) {
  //   state = state.whenData((user) => user.copyWith(awards: awards));
  // }

  // void updateCertificate(List<Link> certificates) {
  //   state = state.whenData((user) => user.copyWith(certificates: certificates));
  // }

  void updateSocialMediaEntry(
      List<UserSocialMedia> currentList, String name, String url) {
    final List<UserSocialMedia> updatedList = [...currentList];
    final index = updatedList.indexWhere((item) => item.name == name);

    if (index != -1) {
      // Update existing entry
      updatedList[index] = updatedList[index].copyWith(url: url);
    } else {
      // Add new entry
      updatedList.add(UserSocialMedia(name: name, url: url));
    }

    state = state.whenData((user) => user.copyWith(socialMedia: updatedList));
  }
  // void updateCompanyLogo(String? companyLogo) {
  //   state = state.whenData((user) => user.copyWith(company: Company(logo: companyLogo)));
  // }
  //   void updateCompanyDesignation(String? designation) {
  //   state = state.whenData((user) => user.copyWith(company: Company(designation: designation)));
  // }
  //   void updateCompanyLogo(String? companyLogo) {
  //   state = state.whenData((user) => user.copyWith(company: Company(logo: companyLogo)));
  // }
  //   void updateCompanyLogo(String? companyLogo) {
  //   state = state.whenData((user) => user.copyWith(company: Company(logo: companyLogo)));
  // }

  // void updateSocialMedia(
  //     List<Link> socialmedias, String platform, String newUrl) {
  //   log(newUrl);
  //   if (platform.isNotEmpty) {
  //     final index = socialmedias.indexWhere((item) => item.name == platform);
  //     log('platform:$platform');
  //     if (index != -1) {
  //       if (newUrl.isNotEmpty) {
  //         // Update the existing social media link
  //         final updatedSocialMedia = socialmedias[index].copyWith(link: newUrl);
  //         socialmedias[index] = updatedSocialMedia;
  //       } else {
  //         // Remove the social media link if newUrl is empty
  //         socialmedias.removeAt(index);
  //       }
  //     } else if (newUrl.isNotEmpty) {
  //       // Add new social media link if platform doesn't exist and newUrl is not empty
  //       final newSocialMedia = Link(name: platform, link: newUrl);
  //       socialmedias.add(newSocialMedia);
  //     }

  //     // Update the state with the modified socialmedias list
  //     state = state.whenData((user) => user.copyWith(social: socialmedias));
  //   } else {
  //     // If platform is empty, clear the social media list
  //     state = state.whenData((user) => user.copyWith(social: []));
  //   }

  //   log('Updated Social Media $socialmedias');
  // }

  // void updateVideos(List<Link> videos) {
  //   state = state.whenData((user) => user.copyWith(videos: videos));
  // }

  // void removeVideo(Link videoToRemove) {
  //   state = state.whenData((user) {
  //     final updatedVideo =
  //         user.videos!.where((video) => video != videoToRemove).toList();
  //     return user.copyWith(videos: updatedVideo);
  //   });
  // }

  // void updateWebsite(List<Link> websites) {
  //   state = state.whenData((user) => user.copyWith(websites: websites));
  //   log('website count in updation ${websites.length}');
  // }

  // void removeWebsite(Link websiteToRemove) {
  //   state = state.whenData((user) {
  //     final updatedWebsites = user.websites!
  //         .where((website) => website != websiteToRemove)
  //         .toList();
  //     return user.copyWith(websites: updatedWebsites);
  //   });
  // }

  void updatePhone(String phone) {
    state = state.whenData(
      (user) => user.copyWith(phone: phone),
    );
  }
}

final userProvider =
    StateNotifierProvider<UserNotifier, AsyncValue<UserModel>>((ref) {
  return UserNotifier(ref);
});
