import 'package:dotted_border/dotted_border.dart';
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
import 'package:ipaconnect/src/interfaces/components/custom_widgets/social_media_editor.dart';
import 'package:ipaconnect/src/interfaces/components/loading/loading_indicator.dart';
import 'package:ipaconnect/src/interfaces/components/shimmers/edit_user_shimmer.dart';
import 'package:ipaconnect/src/interfaces/components/textFormFields/custom_text_form_field.dart';
import 'package:path/path.dart' as Path;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';

class EditUser extends ConsumerStatefulWidget {
  const EditUser({super.key});

  @override
  ConsumerState<EditUser> createState() => _EditUserState();
}

class _EditUserState extends ConsumerState<EditUser> {
  List<Map<String, TextEditingController>> companyDetailsControllers = [];
  @override
  void initState() {
    super.initState();
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

  final TextEditingController bioController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController igController = TextEditingController();
  final TextEditingController linkedinController = TextEditingController();
  final TextEditingController twtitterController = TextEditingController();
  final TextEditingController facebookController = TextEditingController();

  File? _profileImageFile;
  ImageSource? _profileImageSource;
  NavigationService navigationService = NavigationService();
  final _formKey = GlobalKey<FormState>();
  SnackbarService snackbarService = SnackbarService();

  bool _isProfileImageLoading = false;

  Future<File?> _pickFile({required String imageType}) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      if (imageType == 'profile') {
        setState(() {
          _isProfileImageLoading = true;
          _profileImageFile = File(image.path);
        });
        try {
          String profileUrl = await imageUpload(_profileImageFile!.path);
          _profileImageSource = ImageSource.gallery;
          ref.read(userProvider.notifier).updateProfilePicture(profileUrl);
          print((profileUrl));
          return _profileImageFile;
        } catch (e) {
          print('Error uploading profile image: $e');
          snackbarService.showSnackBar('Failed to upload profile image');
        } finally {
          setState(() {
            _isProfileImageLoading = false;
          });
        }
      }
    }
    return null;
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

    super.dispose();
  }

  Future<String> _submitData({required UserModel user}) async {
    final Map<String, dynamic> profileData = {
      'name': user.name,
      if (user.profession != null) 'profession': user.profession,
      if (user.bio != null) 'bio': user.bio,
      if (user.email != null) 'email': user.email,
      'phone': user.phone,
      if (user.location != null) 'location': user.location,
      if (user.image != null) 'image': user.image ?? '',
      if (user.socialMedia != null)
        'social_media': user.socialMedia?.map((e) => e.toJson()).toList(),
    };

    log("Submitting profile data: ${profileData.toString()}");
    final userApiService = ref.watch(userDataApiServiceProvider);
    final response =
        await userApiService.updateUser(id, UserModel.fromJson(profileData));
    log(profileData.toString());

    return response.message ?? '';
  }

  // Future<void> _selectImageFile(ImageSource source, String imageType) async {
  //   final XFile? image = await _picker.pickImage(source: source);
  //   print('$image');
  //   if (image != null && imageType == 'profile') {
  //     setState(() {
  //       _profileImageFile = _pickFile()
  //     });
  //   } else if (image != null && imageType == 'company') {
  //     setState(() {
  //       _companyImageFile = File(image.path);
  //     });
  //   }
  // }

  void navigateBasedOnPreviousPage() {
    final previousPage = ModalRoute.of(context)?.settings.name;
    log('previousPage: $previousPage');
    if (previousPage == 'ProfileCompletion') {
      navigationService.pushNamedReplacement('MainPage');
    } else {
      navigationService.pop();
      ref.read(userProvider.notifier).refreshUser();
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
              // _initializeCompanyDetails(user.company);
              // log(user.company.toString());
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
              if (addressController.text.isEmpty) {
                addressController.text = user.location ?? '';
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
                    ref.read(userProvider.notifier).refreshUser();
                  }
                },
                child: SafeArea(
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Container(
                                child: AppBar(
                                  scrolledUnderElevation: 0,
                                  backgroundColor: kBackgroundColor,
                                  elevation: 0,
                                  leadingWidth: 50,
                                  leading: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: SvgPicture.asset(
                                            'assets/svg/icons/ipa_logo.svg'),
                                      )),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          ref
                                              .read(userProvider.notifier)
                                              .refreshUser();
                                          navigateBasedOnPreviousPage();
                                        },
                                        child: Icon(
                                          Icons.close,
                                          color: kPrimaryColor,
                                        )),
                                  ],
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
                                                  child: _isProfileImageLoading
                                                      ? const Center(
                                                          child:
                                                              LoadingAnimation())
                                                      : Image.network(
                                                          errorBuilder:
                                                              (context, error,
                                                                  stackTrace) {
                                                            return SvgPicture.asset(
                                                                'assets/svg/icons/dummy_person_large.svg');
                                                          },
                                                          user.image ?? '',
                                                          fit: BoxFit.cover,
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
                                                        offset:
                                                            const Offset(2, 2),
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
                                            padding:
                                                const EdgeInsets.only(top: 15),
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
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 60, left: 16, bottom: 10),
                                    child: Text('Personal Details',
                                        style: kSubHeadingB),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, top: 10, bottom: 10),
                                child: Column(
                                  children: [
                                    CustomTextFormField(
                                      backgroundColor: kCardBackgroundColor,
                                      title: 'Full Name',
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please Enter Your Name';
                                        }

                                        // Regex to allow only basic English letters and spaces (no emojis or fancy unicode)
                                        final regex =
                                            RegExp(r'^[a-zA-Z0-9\s.,-]*$');

                                        if (!regex.hasMatch(value)) {
                                          return 'Only standard letters, numbers, and basic punctuation allowed';
                                        }

                                        return null;
                                      },
                                      textController: nameController,
                                      labelText: 'Enter your Name',
                                    ),
                                    const SizedBox(height: 20.0),
                                    CustomTextFormField(
                                        backgroundColor: kCardBackgroundColor,
                                        title: 'Bio',
                                        // validator: (value) {
                                        //   if (value == null || value.isEmpty) {
                                        //     return 'Please Enter Your Bio';
                                        //   }
                                        //   return null;
                                        // },
                                        textController: bioController,
                                        labelText: 'Bio',
                                        maxLines: 5),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 20,
                                  left: 20,
                                ),
                                child: Row(
                                  children: [
                                    Text('Contact', style: kSubHeadingB),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: CustomTextFormField(
                                  backgroundColor: kCardBackgroundColor,
                                  title: 'Address',
                                  textController: addressController,
                                  labelText: 'Enter your Address',
                                  onChanged: () {
                                    ref
                                        .read(userProvider.notifier)
                                        .updateAddress(addressController.text);
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 20, left: 20, bottom: 15),
                                child: Row(
                                  children: [
                                    Text('Social Media', style: kSubHeadingB),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                              SizedBox(
                                height: 100,
                              )
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
                                      String response =
                                          await _submitData(user: user);
                                      // ref
                                      //     .read(userProvider.notifier)
                                      //     .refreshUser();

                                      // Navigator.pushReplacement(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (BuildContext context) =>
                                      //             MainPage()
                                      //             ));
                                      if (response.contains('success')) {
                                        snackbarService.showSnackBar(response);
                                        ref.invalidate(userProvider);
                                        navigateBasedOnPreviousPage();
                                      } else {
                                        snackbarService.showSnackBar(response,
                                            type: SnackbarType.warning);
                                      }
                                    }
                                  }))),
                    ],
                  ),
                ),
              );
            },
          )),
    );
  }
}
