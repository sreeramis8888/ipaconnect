import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/models/user_model.dart';
import 'package:ipaconnect/src/data/notifiers/user_notifier.dart';
import 'package:ipaconnect/src/data/services/api_routes/user_api/user_data/user_data_api.dart';
import 'package:ipaconnect/src/data/services/image_upload.dart';
import 'package:ipaconnect/src/data/services/navigation_service.dart';
import 'package:ipaconnect/src/data/services/snackbar_service.dart';
import 'package:ipaconnect/src/data/utils/globals.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_button.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_round_button.dart';
import 'package:ipaconnect/src/interfaces/components/cards/award_card.dart';
import 'package:ipaconnect/src/interfaces/components/cards/certificate_card.dart';
import 'package:ipaconnect/src/interfaces/components/cards/custom_websiteVideo_card.dart';
import 'package:ipaconnect/src/interfaces/components/cards/document_card.dart';
import 'package:ipaconnect/src/interfaces/components/custom_widgets/social_media_editor.dart';
import 'package:ipaconnect/src/interfaces/components/loading/loading_indicator.dart';
import 'package:ipaconnect/src/interfaces/components/modals/add_award.dart';
import 'package:ipaconnect/src/interfaces/components/modals/add_certificate.dart';
import 'package:ipaconnect/src/interfaces/components/modals/add_document.dart';
import 'package:ipaconnect/src/interfaces/components/modals/add_website_video.dart';
import 'package:ipaconnect/src/interfaces/components/shimmers/edit_user_shimmer.dart';
import 'package:ipaconnect/src/interfaces/components/textFormFields/custom_text_form_field.dart';
import 'package:path/path.dart' as Path;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'package:ipaconnect/src/interfaces/additional_screens/crop_image_screen.dart';
import 'package:custom_image_crop/custom_image_crop.dart';

class EditUser extends ConsumerStatefulWidget {
  const EditUser({super.key});

  @override
  ConsumerState<EditUser> createState() => _EditUserState();
}

class _EditUserState extends ConsumerState<EditUser> {
  List<Map<String, TextEditingController>> companyDetailsControllers = [];
  bool _didSave = false; // Track if the user saved
  @override
  void initState() {
    super.initState();
    _didSave = false; // Reset flag on init
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController secondaryPhoneController =
      TextEditingController();
  final TextEditingController landlineController = TextEditingController();
  final TextEditingController bloodGroupController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController profilePictureController =
      TextEditingController();
  final TextEditingController personalPhoneController = TextEditingController();
  final TextEditingController professionController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  final TextEditingController bioController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController igController = TextEditingController();
  final TextEditingController linkedinController = TextEditingController();
  final TextEditingController twtitterController = TextEditingController();
  final TextEditingController facebookController = TextEditingController();
  final TextEditingController websiteNameController = TextEditingController();
  final TextEditingController websiteLinkController = TextEditingController();
  final TextEditingController videoNameController = TextEditingController();
  final TextEditingController videoLinkController = TextEditingController();
  final TextEditingController awardNameController = TextEditingController();

  final TextEditingController awardAuthorityController =
      TextEditingController();
  final TextEditingController certificateNameController =
      TextEditingController();
  final TextEditingController documentNameController = TextEditingController();
  File? _profileImageFile;
  ImageSource? _profileImageSource;
  NavigationService navigationService = NavigationService();
  final _formKey = GlobalKey<FormState>();
  SnackbarService snackbarService = SnackbarService();

  File? _awardImageFIle;
  File? _certificateImageFIle;
  File? _documentFile;
  ImageSource? _awardImageSource;
  ImageSource? _certificateSource;
  bool _isProfileImageLoading = false;
  bool isFormActive = true;
  Future<File?> _pickFile({required String imageType}) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      if (imageType == 'profile') {
        setState(() {
          _isProfileImageLoading = true;
        });
        try {
          // 1. Crop the image
          final croppedBytes = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CropImageScreen(
                imageFile: File(image.path),
                shape: CustomCropShape.Circle, // Use circle crop
                width: 1,
                height: 1,
              ),
            ),
          );

          if (croppedBytes != null && croppedBytes is Uint8List) {
            // 2. Save cropped image to file
            String croppedFilePath = await saveUint8ListToFile(
              croppedBytes,
              'profile_cropped_${DateTime.now().millisecondsSinceEpoch}.jpg',
            );
            File croppedFile = File(croppedFilePath);

            // 3. Upload the cropped image
            String profileUrl = await imageUpload(croppedFile.path);

            setState(() {
              _profileImageFile = croppedFile;
              _profileImageSource = ImageSource.gallery;
            });

            ref.read(userProvider.notifier).updateProfilePicture(profileUrl);
            print((profileUrl));
            return croppedFile;
          }
        } catch (e) {
          print('Error uploading profile image: $e');
          snackbarService.showSnackBar('Failed to upload profile image');
        } finally {
          setState(() {
            _isProfileImageLoading = false;
          });
        }
      } else if (imageType == 'award') {
        _awardImageFIle = File(image.path);
        _awardImageSource = ImageSource.gallery;
        return _awardImageFIle;
      } else if (imageType == 'certificate') {
        _certificateImageFIle = File(image.path);
        _certificateSource = ImageSource.gallery;
        return _certificateImageFIle;
      } else {
        _documentFile = File(image.path);
        return _documentFile;
      }
    }
    return null;
  }

  Future<void> _addNewAward() async {
    await imageUpload(_awardImageFIle!.path).then((url) {
      final String awardUrl = url;
      final newAward = Award(
        name: awardNameController.text,
        image: awardUrl,
        authority: awardAuthorityController.text,
      );

      ref
          .read(userProvider.notifier)
          .updateAwards([...?ref.read(userProvider).value?.awards, newAward]);
    });

    _awardImageFIle = null;
  }

  void _removeAward(int index) async {
    ref
        .read(userProvider.notifier)
        .removeAward(ref.read(userProvider).value!.awards![index]);
  }

  void _addNewWebsite() async {
    SubData newWebsite = SubData(
        link: websiteLinkController.text.toString(),
        name: websiteNameController.text.toString());
    log('Hello im in website bug:${ref.read(userProvider).value?.websites}');
    ref.read(userProvider.notifier).updateWebsite(
        [...?ref.read(userProvider).value?.websites, newWebsite]);
    websiteLinkController.clear();
    websiteNameController.clear();
  }

  void _removeWebsite(int index) async {
    ref
        .read(userProvider.notifier)
        .removeWebsite(ref.read(userProvider).value!.websites![index]);
  }

  void _addNewVideo() async {
    SubData newVideo = SubData(
        link: videoLinkController.text.toString(),
        name: videoNameController.text.toString());
    log('Hello im in website bug:${ref.read(userProvider).value?.videos}');
    ref
        .read(userProvider.notifier)
        .updateVideos([...?ref.read(userProvider).value?.videos, newVideo]);
    videoLinkController.clear();
    videoNameController.clear();
  }

  void _removeVideo(int index) async {
    ref
        .read(userProvider.notifier)
        .removeVideo(ref.read(userProvider).value!.videos![index]);
  }

  Future<void> _addNewCertificate() async {
    await imageUpload(_certificateImageFIle!.path).then((url) {
      final String certificateUrl = url;
      final newCertificate =
          SubData(name: certificateNameController.text, link: certificateUrl);

      ref.read(userProvider.notifier).updateCertificate(
          [...?ref.read(userProvider).value?.certificates, newCertificate]);
    });

    _certificateImageFIle = null;
  }

  void _removeCertificate(int index) async {
    ref
        .read(userProvider.notifier)
        .removeCertificate(ref.read(userProvider).value!.certificates![index]);
  }

  void _onAwardEdit(int index) async {
    // First check if awards exist and index is valid
    final awards = ref.read(userProvider).value?.awards;
    if (awards == null || awards.isEmpty || index >= awards.length) {
      snackbarService.showSnackBar('Award not found');
      return;
    }

    // Get the award to edit
    final Award oldAward = awards[index];

    // Pre-fill the controllers with existing data
    awardNameController.text = oldAward.name ?? '';
    awardAuthorityController.text = oldAward.authority ?? '';

    showModalBottomSheet(
      backgroundColor: kBackgroundColor,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return ShowEnterAwardSheet(
          imageUrl: oldAward.image,
          pickImage: _pickFile,
          editAwardCard: () => _editAward(oldAward: oldAward),
          imageType: 'award',
          textController1: awardNameController,
          textController2: awardAuthorityController,
        );
      },
    );
  }

  Future<void> _editAward({required Award oldAward}) async {
    if (_awardImageFIle != null) {
      try {
        final String awardUrl = await imageUpload(_awardImageFIle!.path);
        final newAward = Award(
          name: awardNameController.text,
          image: awardUrl,
          authority: awardAuthorityController.text,
        );

        ref.read(userProvider.notifier).editAward(oldAward, newAward);
      } catch (e) {
        print('Error uploading award image: $e');
        snackbarService.showSnackBar('Failed to upload award image');
      }
    } else {
      final newAward = Award(
        name: awardNameController.text,
        image: oldAward.image,
        authority: awardAuthorityController.text,
      );

      ref.read(userProvider.notifier).editAward(oldAward, newAward);
    }
  }

  void _editWebsite(int index) {
    websiteNameController.text =
        ref.read(userProvider).value?.websites?[index].name ?? '';
    websiteLinkController.text =
        ref.read(userProvider).value?.websites?[index].link ?? '';

    showWebsiteSheet(
        addWebsite: () {
          final SubData oldWebsite =
              ref.read(userProvider).value!.websites![index];
          final SubData newWebsite = SubData(
              name: websiteNameController.text,
              link: websiteLinkController.text);
          ref.read(userProvider.notifier).editWebsite(oldWebsite, newWebsite);
        },
        textController1: websiteNameController,
        textController2: websiteLinkController,
        fieldName: 'Edit Website Link',
        title: 'Edit Website',
        context: context);
  }

  void _editVideo(int index) {
    videoNameController.text =
        ref.read(userProvider).value?.videos?[index].name ?? '';
    videoLinkController.text =
        ref.read(userProvider).value?.videos?[index].link ?? '';

    showVideoLinkSheet(
        addVideo: () {
          final SubData oldVideo = ref.read(userProvider).value!.videos![index];
          final SubData newVideo = SubData(
              name: videoNameController.text, link: videoLinkController.text);
          ref.read(userProvider.notifier).editVideo(oldVideo, newVideo);
        },
        textController1: videoNameController,
        textController2: videoLinkController,
        fieldName: 'Edit Video Link',
        title: 'Edit Video Link',
        context: context);
  }

  void _editCertificate(int index) async {
    final SubData oldCertificate =
        ref.read(userProvider).value!.certificates![index];
    certificateNameController.text = oldCertificate.name ?? '';

    showModalBottomSheet(
      backgroundColor: kCardBackgroundColor,
      isScrollControlled: true,
      context: context,
      builder: (context) => ShowAddCertificateSheet(
        imageUrl: oldCertificate.link,
        textController: certificateNameController,
        pickImage: _pickFile,
        imageType: 'certificate',
        addCertificateCard: () async {
          if (_certificateImageFIle != null) {
            try {
              final String certificateUrl =
                  await imageUpload(_certificateImageFIle!.path);
              final newCertificate = SubData(
                  name: certificateNameController.text, link: certificateUrl);
              ref
                  .read(userProvider.notifier)
                  .editCertificate(oldCertificate, newCertificate);
            } catch (e) {
              print('Error uploading certificate image: $e');
              snackbarService
                  .showSnackBar('Failed to upload certificate image');
            }
          } else {
            final newCertificate = SubData(
              name: certificateNameController.text,
              link: oldCertificate.link,
            );
            ref
                .read(userProvider.notifier)
                .editCertificate(oldCertificate, newCertificate);
          }
        },
      ),
    );
  }

  Future<File?> _pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg', 'pdf'],
    );

    if (result != null) {
      _documentFile = File(result.files.single.path!);
      log('picked pdf :$_documentFile');
      return _documentFile;
    }
    return null;
  }

  Future<void> _addNewDocument() async {
    log("picked pdf while add:$_documentFile");
    final String brochureUrl = await imageUpload(
      _documentFile!.path,
    );

    final newBrochure =
        SubData(name: documentNameController.text, link: brochureUrl);

    ref.read(userProvider.notifier).updateDocuments(
        [...?ref.read(userProvider).value?.documents, newBrochure]);
  }

  void _removeDocument(int index) async {
    ref
        .read(userProvider.notifier)
        .removeDocument(ref.read(userProvider).value!.documents![index]);
  }

  @override
  void dispose() {
    nameController.dispose();
    bloodGroupController.dispose();
    emailController.dispose();
    profilePictureController.dispose();
    personalPhoneController.dispose();
    landlineController.dispose();
    professionController.dispose();
    bioController.dispose();
    addressController.dispose();
    _didSave = false; // Reset flag on dispose
    super.dispose();
  }

  Future<bool> _submitData({required UserModel user}) async {
    final Map<String, dynamic> profileData = {
      'name': user.name,
      if (user.profession != null) 'proffession': user.profession,
      if (user.bio != null) 'bio': user.bio,
      if (user.email != null) 'email': user.email,
      if (user.location != null) 'location': user.location,
      if (user.image != null) 'image': user.image ?? '',
      if (user.isFormActivated != null)
        'is_form_activated': user.isFormActivated ?? true,
      if (user.socialMedia != null)
        'social_media': user.socialMedia?.map((e) => e.toJson()).toList(),
      if (user.websites != null)
        'websites': user.websites?.map((e) => e.toJson()).toList(),
      if (user.awards != null)
        'awards': user.awards?.map((e) => e.toJson()).toList(),
      if (user.videos != null)
        'videos': user.videos?.map((e) => e.toJson()).toList(),
      if (user.certificates != null)
        'certificates': user.certificates?.map((e) => e.toJson()).toList(),
      if (user.documents != null)
        'documents': user.documents?.map((e) => e.toJson()).toList(),
    };

    log("Submitting profile data: ${profileData.toString()}");
    final userApiService = ref.watch(userDataApiServiceProvider);
    final response =
        await userApiService.updateUser(id, UserModel.fromJson(profileData));
    log(profileData.toString());

    return response.success ?? false;
  }

  void navigateBasedOnPreviousPage() {
    final previousPage = ModalRoute.of(context)?.settings.name;
    log('previousPage: $previousPage');
    if (previousPage == 'ProfileCompletion') {
      navigationService.pushNamedReplacement('MainPage');
    } else {
      navigationService.pop();
    }
  }

  String? businessTagSearch;
  @override
  Widget build(BuildContext context) {
    final asyncUser = ref.watch(userProvider);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: PopScope(
        onPopInvokedWithResult: (didPop, result) {
          if (didPop && !_didSave) {
            ref.read(userProvider.notifier).revertToInitialState();
          }
          if (didPop) {
            ref.invalidate(getUserDetailsByIdProvider(userId: id));
          }
        },
        child: Scaffold(
            backgroundColor: kBackgroundColor,
            body: asyncUser.when(
              loading: () {
                return const EditUserShimmer();
              },
              error: (error, stackTrace) {
                return Center(
                  child: Text('Error loading User: $error '),
                );
              },
              data: (user) {
                if (nameController.text.isEmpty) {
                  nameController.text = user.name ?? '';
                }

                if (bioController.text.isEmpty) {
                  bioController.text = user.bio ?? '';
                }

                if (personalPhoneController.text.isEmpty) {
                  personalPhoneController.text = user.phone ?? '';
                }
                if (emailController.text.isEmpty) {
                  emailController.text = user.email ?? '';
                }
                if (professionController.text.isEmpty) {
                  professionController.text = user.profession ?? '';
                }
                if (addressController.text.isEmpty) {
                  addressController.text = user.location ?? '';
                }
                if (designationController.text.isEmpty) {
                  designationController.text = user.profession ?? '';
                }
                if (aboutController.text.isEmpty) {
                  aboutController.text = user.bio ?? '';
                }
                if (mobileController.text.isEmpty) {
                  mobileController.text = user.phone ?? '';
                }
                for (UserSocialMedia social in user.socialMedia ?? []) {
                  if (social.name == 'instagram' && igController.text.isEmpty) {
                    igController.text = social.url ?? '';
                  } else if (social.name == 'linkedin' &&
                      linkedinController.text.isEmpty) {
                    linkedinController.text = social.url ?? '';
                  } else if (social.name == 'twitter' &&
                      twtitterController.text.isEmpty) {
                    twtitterController.text = social.url ?? '';
                  } else if (social.name == 'facebook' &&
                      facebookController.text.isEmpty) {
                    facebookController.text = social.url ?? '';
                  }
                }

                return PopScope(
                  onPopInvoked: (didPop) {
                    if (didPop) {
                      ref.invalidate(getUserDetailsByIdProvider);
                    }
                  },
                  child: SafeArea(
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: AppBar(
                                    centerTitle: true,
                                    leading: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: InkWell(
                                        onTap: () => Navigator.pop(context),
                                        child: CustomRoundButton(
                                          offset: Offset(4, 0),
                                          iconPath:
                                              'assets/svg/icons/arrow_back_ios.svg',
                                        ),
                                      ),
                                    ),
                                    scrolledUnderElevation: 0,
                                    title: Text('Edit Profile',
                                        style: kBodyTitleB.copyWith()),
                                    backgroundColor: kBackgroundColor,
                                    iconTheme: IconThemeData(
                                        color: kSecondaryTextColor),
                                  ),
                                ),
                                const SizedBox(height: 35),
                                FormField<File>(
                                  builder: (FormFieldState<File> state) {
                                    return Center(
                                      child: Column(
                                        children: [
                                          Stack(
                                            children: [
                                              DottedBorder(
                                                borderType: BorderType.Circle,
                                                dashPattern: [6, 3],
                                                color: Colors.grey,
                                                strokeWidth: 2,
                                                child: ClipOval(
                                                  child: Container(
                                                    width: 120,
                                                    height: 120,
                                                    color: const Color.fromARGB(
                                                        255, 255, 255, 255),
                                                    child:
                                                        _isProfileImageLoading
                                                            ? const Center(
                                                                child:
                                                                    LoadingAnimation())
                                                            : Image.network(
                                                                errorBuilder:
                                                                    (context,
                                                                        error,
                                                                        stackTrace) {
                                                                  return SvgPicture
                                                                      .asset(
                                                                          'assets/svg/icons/dummy_person_large.svg');
                                                                },
                                                                user.image ??
                                                                    '',
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 4,
                                                right: 4,
                                                child: InkWell(
                                                  onTap: () {
                                                    _pickFile(
                                                        imageType: 'profile');
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(0.2),
                                                          offset: const Offset(
                                                              2, 2),
                                                          blurRadius: 4,
                                                        ),
                                                      ],
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: const CircleAvatar(
                                                      radius: 17,
                                                      backgroundColor: kWhite,
                                                      child: Icon(
                                                        Icons.edit,
                                                        color: kPrimaryColor,
                                                        size: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (state.hasError)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 15),
                                              child: Text(
                                                state.errorText ?? '',
                                                style: const TextStyle(
                                                    color: kPrimaryColor),
                                              ),
                                            ),
                                        ],
                                      ),
                                    );
                                  },
                                ),

                                const SizedBox(height: 24),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomTextFormField(
                                        backgroundColor: kCardBackgroundColor,
                                        title: 'Name',
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please Enter Your Name';
                                          }
                                          final regex =
                                              RegExp(r'^[a-zA-Z0-9\s.,-]*$');
                                          if (!regex.hasMatch(value)) {
                                            return 'Only standard letters, numbers, and basic punctuation allowed';
                                          }
                                          return null;
                                        },
                                        textController: nameController,
                                        labelText: 'Enter Name',
                                      ),
                                      const SizedBox(height: 16),
                                      CustomTextFormField(
                                        backgroundColor: kCardBackgroundColor,
                                        title: 'Designation',
                                        textController: designationController,
                                        labelText: 'Enter Designation',
                                      ),
                                      const SizedBox(height: 16),
                                      CustomTextFormField(
                                        backgroundColor: kCardBackgroundColor,
                                        title: 'About',
                                        textController: aboutController,
                                        labelText: 'Bio',
                                        maxLines: 5,
                                      ),
                                      const SizedBox(height: 16),
                                      CustomTextFormField(
                                        backgroundColor: kCardBackgroundColor,
                                        title: 'Email ID',
                                        textController: emailController,
                                        labelText: 'Enter Email ID',
                                      ),
                                    ],
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15, left: 16, bottom: 15),
                                  child: Row(
                                    children: [
                                      Text('Social Media', style: kSmallTitleR),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SocialMediaEditor(
                                      icon: FontAwesomeIcons.instagram,
                                      socialMedias: user.socialMedia ?? [],
                                      platform: 'Instagram',
                                      onSave: (socialMedias, platform, newUrl) {
                                        ref
                                            .read(userProvider.notifier)
                                            .updateSocialMediaEntry(
                                                socialMedias, platform, newUrl);
                                      },
                                    ),
                                    SocialMediaEditor(
                                      icon: FontAwesomeIcons.linkedinIn,
                                      socialMedias: user.socialMedia ?? [],
                                      platform: 'Linkedin',
                                      onSave: (socialMedias, platform, newUrl) {
                                        ref
                                            .read(userProvider.notifier)
                                            .updateSocialMediaEntry(
                                                socialMedias, platform, newUrl);
                                      },
                                    ),
                                    SocialMediaEditor(
                                      icon: FontAwesomeIcons.xTwitter,
                                      socialMedias: user.socialMedia ?? [],
                                      platform: 'Twitter',
                                      onSave: (socialMedias, platform, newUrl) {
                                        ref
                                            .read(userProvider.notifier)
                                            .updateSocialMediaEntry(
                                                socialMedias, platform, newUrl);
                                      },
                                    ),
                                    SocialMediaEditor(
                                      icon: FontAwesomeIcons.facebookF,
                                      socialMedias: user.socialMedia ?? [],
                                      platform: 'Facebook',
                                      onSave: (socialMedias, platform, newUrl) {
                                        ref
                                            .read(userProvider.notifier)
                                            .updateSocialMediaEntry(
                                                socialMedias, platform, newUrl);
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                if (user.websites != null &&
                                    user.websites!.isNotEmpty)
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Website',
                                          style: kSmallTitleR,
                                        ),
                                      ],
                                    ),
                                  ),
                                if (user.websites != null &&
                                    user.websites!.isNotEmpty)
                                  SizedBox(
                                    height: 10,
                                  ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: user.websites?.length,
                                  itemBuilder: (context, index) {
                                    log('Websites count: ${user.websites?.length}');
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: customWebsiteCard(
                                          onEdit: () => _editWebsite(index),
                                          onRemove: () => _removeWebsite(index),
                                          website: user.websites?[index]),
                                    );
                                  },
                                ),
                                InkWell(
                                  onTap: () => showWebsiteSheet(
                                    addWebsite: _addNewWebsite,
                                    textController1: websiteNameController,
                                    textController2: websiteLinkController,
                                    fieldName: 'Website Link',
                                    title: 'Add Website',
                                    context: context,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16, right: 16, bottom: 15),
                                    child: Text('+ Add Website',
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ),
                                if (user.videos != null &&
                                    user.videos!.isNotEmpty)
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Videos',
                                          style: kSmallTitleR,
                                        ),
                                        // CustomSwitch(
                                        //   value:
                                        //       ref.watch(isVideoDetailsVisibleProvider),
                                        //   onChanged: (bool value) {
                                        //     setState(() {
                                        //       ref
                                        //           .read(isVideoDetailsVisibleProvider
                                        //               .notifier)
                                        //           .state = value;
                                        //     });
                                        //   },
                                        // ),
                                      ],
                                    ),
                                  ),
                                if (user.videos != null &&
                                    user.videos!.isNotEmpty)
                                  SizedBox(
                                    height: 10,
                                  ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: user.videos?.length,
                                  itemBuilder: (context, index) {
                                    log('video count: ${user.videos?.length}');
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0), // Space between items
                                      child: customVideoCard(
                                          onEdit: () => _editVideo(index),
                                          onRemove: () => _removeVideo(index),
                                          video: user.videos?[index]),
                                    );
                                  },
                                ),
                                // + Add Video
                                InkWell(
                                  onTap: () => showVideoLinkSheet(
                                    addVideo: _addNewVideo,
                                    textController1: videoNameController,
                                    textController2: videoLinkController,
                                    fieldName: 'Video Link',
                                    title: 'Add Video',
                                    context: context,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16, right: 16, bottom: 15),
                                    child: Text('+ Add Video',
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ),
                                if (user.awards != null &&
                                    user.awards!.isNotEmpty)
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: 16,
                                      right: 16,
                                      bottom: 5,
                                      top: 10,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Awards',
                                          style: kSmallTitleR,
                                        ),
                                      ],
                                    ),
                                  ),

                                if (user.awards != null &&
                                    user.awards!.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: GridView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 8.0,
                                        mainAxisSpacing: 8.0,
                                      ),
                                      itemCount: user.awards!.length + 1,
                                      itemBuilder: (context, index) {
                                        if (index < user.awards!.length) {
                                          return AwardCard(
                                            onEdit: () => _onAwardEdit(index),
                                            award: user.awards![index],
                                            onRemove: () => _removeAward(index),
                                          );
                                        } else {
                                          SizedBox.shrink();
                                        }
                                      },
                                    ),
                                  ),
                                InkWell(
                                  onTap: () => showModalBottomSheet(
                                    backgroundColor: kCardBackgroundColor,
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (context) => ShowEnterAwardSheet(
                                      addAwardCard: _addNewAward,
                                      pickImage: _pickFile,
                                      imageType: 'award',
                                      textController1: awardNameController,
                                      textController2: awardAuthorityController,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16, right: 16, bottom: 15),
                                    child: Text('+ Add Award',
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ),
                                if (user.documents != null &&
                                    user.documents!.isNotEmpty)
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 16, right: 16, top: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Documents',
                                          style: kSmallTitleR,
                                        ),
                                      ],
                                    ),
                                  ),
                                if (user.documents != null &&
                                    user.documents!.isNotEmpty)
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 16, right: 16, top: 10),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: user.documents!.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4.0),
                                          child: DocumentCard(
                                            brochure: user.documents![index],
                                            onRemove: () =>
                                                _removeDocument(index),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                InkWell(
                                  onTap: () => showModalBottomSheet(
                                      backgroundColor: kCardBackgroundColor,
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (context) =>
                                          ShowAddDocumentSheet(
                                              brochureName: '',
                                              textController:
                                                  documentNameController,
                                              pickPdf: _pickDocument,
                                              addBrochureCard:
                                                  _addNewDocument)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16, right: 16, bottom: 15),
                                    child: Text('+ Add Document',
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ),
                                if (user.certificates != null &&
                                    user.certificates!.isNotEmpty)
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 16,
                                        right: 16,
                                        top: 10,
                                        bottom: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Certificates',
                                          style: kSmallTitleR,
                                        ),
                                      ],
                                    ),
                                  ),
                                if (user.certificates != null &&
                                    user.certificates!.isNotEmpty)
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: user.certificates!.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        child: CertificateCard(
                                          onEdit: () => _editCertificate(index),
                                          certificate:
                                              user.certificates![index],
                                          onRemove: () =>
                                              _removeCertificate(index),
                                        ),
                                      );
                                    },
                                  ),
                                InkWell(
                                  onTap: () => showModalBottomSheet(
                                    backgroundColor: kCardBackgroundColor,
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (context) =>
                                        ShowAddCertificateSheet(
                                      pickImage: _pickFile,
                                      imageType: 'award',
                                      addCertificateCard: _addNewCertificate,
                                      textController: certificateNameController,
                                      onImagePicked: (file) {
                                        setState(() {
                                          _certificateImageFIle = file;
                                        });
                                      },
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16, right: 16, bottom: 15),
                                    child: Text('+ Add Certificate',
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16, bottom: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Activate Form',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16)),
                                      Switch(
                                        value: user.isFormActivated ?? true,
                                        onChanged: (val) {
                                          ref
                                              .read(userProvider.notifier)
                                              .updateIsFormActivated(val);
                                        },
                                        activeColor: Colors.blue,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 70),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          left: 20,
                          right: 20,
                          child: SizedBox(
                            height: 50,
                            child: customButton(
                              fontSize: 16,
                              label: 'Save & Proceed',
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  SnackbarService snackbarService =
                                      SnackbarService();
                                  bool success = await _submitData(user: user);
                                  if (success) {
                                    _didSave = true;
                                    snackbarService
                                        .showSnackBar('Profile Updated');

                                    navigateBasedOnPreviousPage();
                                  } else {
                                    snackbarService.showSnackBar('Failed',
                                        type: SnackbarType.warning);
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )),
      ),
    );
  }
}
