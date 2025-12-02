import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/models/user_model.dart';
import 'package:ipaconnect/src/data/services/api_routes/user_api/user_data/user_data_api.dart';
import 'package:ipaconnect/src/data/utils/globals.dart';

class UserNotifier extends StateNotifier<AsyncValue<UserModel>> {
  final Ref<AsyncValue<UserModel>> ref;
  UserModel? _initialUser; // Cache for the initial user value

  UserNotifier(this.ref) : super(const AsyncValue.loading()) {
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    if (mounted) {
      // Wait a bit to ensure global variables are loaded
      await Future.delayed(const Duration(milliseconds: 100));
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
      log('Fetch user token:$token');

      // Check if we have valid authentication state before making API call
      if (!isAuthenticated) {
        log('Invalid authentication state, cannot fetch user details');
        state = const AsyncValue.data(UserModel());
        return;
      }

      final user = await ref.read(getUserDetailsProvider.future);
      if (_initialUser == null && user != null) {
        _initialUser = user;
      }
      state = AsyncValue.data(user ?? UserModel());
      log('User details fetched successfully');
    } catch (e, stackTrace) {
      log('Error fetching user details: $e');
      log('Stack trace: $stackTrace');

      // If we get an authentication error, clear the state and return empty user
      if (e.toString().contains('401') ||
          e.toString().contains('unauthorized') ||
          e.toString().contains('token')) {
        log('Authentication error detected, clearing user state');
        state = const AsyncValue.data(UserModel());
      } else {
        state = AsyncValue.error(e, stackTrace);
      }
    }
  }

  /// Revert all values to the first loaded state
  void revertToInitialState() {
    if (_initialUser != null) {
      state = AsyncValue.data(_initialUser!);
    } else {
      state = const AsyncValue.data(UserModel());
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

  void removeAward(Award awardToRemove) {
    state = state.whenData((user) {
      final updatedAwards =
          user.awards!.where((award) => award != awardToRemove).toList();
      return user.copyWith(awards: updatedAwards);
    });
  }

  void removeCertificate(SubData certificateToRemove) {
    state = state.whenData((user) {
      final updatedCertificate = user.certificates!
          .where((certificate) => certificate != certificateToRemove)
          .toList();
      return user.copyWith(certificates: updatedCertificate);
    });
  }

  void editAward(Award oldAward, Award updatedAward) {
    state = state.whenData((user) {
      final updatedAwards = user.awards!.map((award) {
        final isReplacing = award == oldAward;
        print("Checking Award: ${award.name} -> Replacing? $isReplacing");

        return isReplacing ? updatedAward : award;
      }).toList();

      print(
          "Updated Awards List: ${updatedAwards.map((e) => e.image).toList()}");

      return user.copyWith(awards: updatedAwards);
    });
  }

  void editWebsite(SubData oldWebsite, SubData newWebsite) {
    state = AsyncValue.data(state.value!.copyWith(
        websites: state.value!.websites!
            .map((w) => w == oldWebsite ? newWebsite : w)
            .toList()));
  }

  void editVideo(SubData oldVideo, SubData newVideo) {
    state = AsyncValue.data(state.value!.copyWith(
        videos: state.value!.videos!
            .map((v) => v == oldVideo ? newVideo : v)
            .toList()));
  }

  void editCertificate(SubData oldCertificate, SubData newCertificate) {
    state = AsyncValue.data(state.value!.copyWith(
        certificates: state.value!.certificates!
            .map((c) => c == oldCertificate ? newCertificate : c)
            .toList()));
  }

  void updateVideos(List<SubData> videos) {
    state = state.whenData((user) => user.copyWith(videos: videos));
  }

  void removeVideo(SubData videoToRemove) {
    state = state.whenData((user) {
      final updatedVideo =
          user.videos!.where((video) => video != videoToRemove).toList();
      return user.copyWith(videos: updatedVideo);
    });
  }

  void removeDocument(SubData documentToRemove) {
    state = state.whenData((user) {
      final updatedDocuments = user.documents!
          .where((brochure) => brochure != documentToRemove)
          .toList();
      return user.copyWith(documents: updatedDocuments);
    });
  }

  void updateWebsite(List<SubData> websites) {
    state = state.whenData((user) => user.copyWith(websites: websites));
    log('website count in updation ${websites.length}');
  }

  void removeWebsite(SubData websiteToRemove) {
    state = state.whenData((user) {
      final updatedWebsites = user.websites!
          .where((website) => website != websiteToRemove)
          .toList();
      return user.copyWith(websites: updatedWebsites);
    });
  }

  void updatePhone(String phone) {
    state = state.whenData(
      (user) => user.copyWith(phone: phone),
    );
  }

  void updateCertificate(List<SubData> certificates) {
    state = state.whenData((user) => user.copyWith(certificates: certificates));
  }

  void updateDocuments(List<SubData> documents) {
    state = state.whenData((user) => user.copyWith(documents: documents));
  }

  void updateAwards(List<Award> awards) {
    state = state.whenData((user) => user.copyWith(awards: awards));
  }

  void updateIsFormActivated(bool isFormActivated) {
    state = state
        .whenData((user) => user.copyWith(isFormActivated: isFormActivated));
  }
}

final userProvider =
    StateNotifierProvider<UserNotifier, AsyncValue<UserModel>>((ref) {
  return UserNotifier(ref);
});
