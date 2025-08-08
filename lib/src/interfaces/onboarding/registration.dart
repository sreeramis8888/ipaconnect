import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/models/user_model.dart';
import 'package:ipaconnect/src/data/notifiers/loading_notifier.dart';
import 'package:ipaconnect/src/data/services/api_routes/user_api/user_data/user_data_api.dart';
import 'package:ipaconnect/src/data/services/image_upload.dart';
import 'package:ipaconnect/src/data/utils/globals.dart';
import 'package:ipaconnect/src/data/utils/secure_storage.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_button.dart';
import 'package:ipaconnect/src/interfaces/components/textFormFields/custom_text_form_field.dart';
import '../../data/constants/color_constants.dart';
import '../../data/services/navigation_service.dart';
import '../additional_screens/crop_image_screen.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  Uint8List? _profileImage;

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        final cropped = await Navigator.of(context).push<Uint8List>(
          MaterialPageRoute(
            builder: (context) => CropImageScreen(
              imageFile: File(pickedFile.path),
              shape: CustomCropShape.Square,
            ),
          ),
        );

        if (cropped != null) {
          setState(() {
            _profileImage = cropped;
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final loading = ref.watch(loadingProvider);
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            backgroundColor: kBackgroundColor,
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: SafeArea(
                        child: TextButton.icon(
                          onPressed: () async {
                            await SecureStorage.delete('token');
                            await SecureStorage.delete('id');

                            NavigationService()
                                .pushNamedReplacement('PhoneNumber');
                          },
                          icon: Icon(Icons.logout, color: kPrimaryColor),
                          label: Text(
                            'Logout',
                            style: kSmallTitleB.copyWith(color: kPrimaryColor),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Stack(
                        children: [
                          DottedBorder(
                            borderType: BorderType.Circle,
                            color: Colors.grey,
                            dashPattern: [6, 3],
                            strokeWidth: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: CircleAvatar(
                                radius: 44,
                                backgroundColor: kInputFieldcolor,
                                backgroundImage: _profileImage != null
                                    ? MemoryImage(_profileImage!)
                                    : null,
                                child: _profileImage == null
                                    ? Icon(Icons.person,
                                        size: 44, color: kWhite)
                                    : null,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _pickImage,
                              child: CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.black,
                                child: Icon(Icons.camera_alt,
                                    color: kWhite, size: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text('Personal Details', style: kHeadTitleB),
                    const SizedBox(height: 24),
                    Text('Full Name *', style: kBodyTitleR),
                    CustomTextFormField(
                      labelText: 'Enter the full name',
                      textController: _nameController,
                      validator: (val) =>
                          val == null || val.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    Text('Email ID', style: kBodyTitleR),
                    CustomTextFormField(
                      labelText: 'Enter the email id',
                      textController: _emailController,
                      validator: (val) =>
                          val == null || val.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    Text('Designation', style: kBodyTitleR),
                    CustomTextFormField(
                      labelText: 'Enter the designation',
                      textController: _designationController,
                      validator: (val) =>
                          val == null || val.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    Text('Location', style: kBodyTitleR),
                    CustomTextFormField(
                      labelText: 'Enter the location',
                      textController: _locationController,
                      validator: (val) =>
                          val == null || val.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 26),
                    Consumer(
                      builder: (context, ref, child) {
                        return customButton(
                          isLoading: loading,
                          label: 'Send Request',
                          onPressed: () async {
                            String? profileUrl;
                            ref.read(loadingProvider.notifier).startLoading();

                            if (_profileImage != null) {
                              String tempImagePath = await saveUint8ListToFile(
                                  _profileImage!, 'profile.png');
                              profileUrl = await imageUpload(tempImagePath);
                            }
                            UserDataApiService userDataApiService =
                                ref.watch(userDataApiServiceProvider);
                            final response =
                                await userDataApiService.updateUser(
                                    id,
                                    UserModel(
                                        name: _nameController.text,
                                        email: _emailController.text,
                                        image: profileUrl,
                                        profession: _designationController.text,
                                        location: _locationController.text,
                                        status: 'pending'));
                            log(response.data.toString(), name: 'EDIT USER');
                            if (response.success == true) {
                              NavigationService navigationService =
                                  NavigationService();
                              navigationService
                                  .pushNamedReplacement('ApprovalWaitingPage');
                            }
                            ref.read(loadingProvider.notifier).stopLoading();
                          },
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
