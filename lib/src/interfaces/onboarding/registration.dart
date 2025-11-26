import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/models/user_model.dart';
import 'package:ipaconnect/src/data/notifiers/loading_notifier.dart';
import 'package:ipaconnect/src/data/services/api_routes/user_api/user_data/user_data_api.dart';
import 'package:ipaconnect/src/data/services/image_upload.dart'
    show imageUpload, documentUpload, saveUint8ListToFile;
import 'package:ipaconnect/src/data/utils/globals.dart';
import 'package:ipaconnect/src/data/utils/secure_storage.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_button.dart';
import 'package:ipaconnect/src/interfaces/components/textFormFields/custom_text_form_field.dart';
import 'package:ipaconnect/src/interfaces/onboarding/login.dart';
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

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _whatsAppController = TextEditingController();

  Uint8List? _profileImage;
  List<_DocumentUpload> _documents = [];
  File? _emiratesIdDocument;
  File? _passportDocument;

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

  Future<void> _pickDocument() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _documents.add(_DocumentUpload(File(result.files.single.path!)));
      });
    }
  }

  Future<void> _pickEmiratesIdDocument() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _emiratesIdDocument = File(result.files.single.path!);
      });
    }
  }

  Future<void> _pickPassportDocument() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _passportDocument = File(result.files.single.path!);
      });
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
            body: SafeArea(
              child: Column(
                children: [
                  // Scrollable form content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.topRight,
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
                                  style: kSmallTitleB.copyWith(
                                      color: kPrimaryColor),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
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
                              validator: (val) => val == null || val.isEmpty
                                  ? 'Required'
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            Text('Email ID *', style: kBodyTitleR),
                            CustomTextFormField(
                              labelText: 'Enter the email id',
                              textController: _emailController,
                              validator: (val) => val == null || val.isEmpty
                                  ? 'Required'
                                  : null,
                            ),
                            const SizedBox(height: 16),

                            //Phone number
                            Text('Phone Number *', style: kBodyTitleR),
                            const SizedBox(height: 16),
                            Theme(
                              data: Theme.of(context).copyWith(
                                textTheme: Theme.of(context).textTheme.apply(
                                      bodyColor: Colors.white,
                                      displayColor: Colors.white,
                                    ),
                                inputDecorationTheme:
                                    const InputDecorationTheme(
                                  hintStyle: TextStyle(color: Colors.white70),
                                ),
                              ),
                              child: IntlPhoneField(
                                validator: (phone) {
                                  if (phone!.number.length > 9) {
                                    if (phone.number.length > 10) {
                                      return 'Phone number cannot exceed 10 digits';
                                    }
                                  }
                                  return null;
                                },
                                style: const TextStyle(
                                  color: kWhite,
                                  letterSpacing: 8,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                                controller: _phoneController,
                                disableLengthCheck: true,
                                showCountryFlag: true,
                                cursorColor: kWhite,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: kInputFieldcolor,
                                  hintText: 'Enter your phone number',
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: .2,
                                    fontWeight: FontWeight.w200,
                                    color: kSecondaryTextColor,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide:
                                        BorderSide(color: kInputFieldcolor),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide:
                                        BorderSide(color: kInputFieldcolor),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: const BorderSide(
                                        color: kInputFieldcolor),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16.0,
                                    horizontal: 10.0,
                                  ),
                                ),
                                onCountryChanged: (value) {
                                  ref.read(countryCodeProvider.notifier).state =
                                      value.dialCode;
                                },
                                initialCountryCode: 'AE',
                                onChanged: (phone) {
                                  print(phone.completeNumber);
                                },
                                flagsButtonPadding: const EdgeInsets.only(
                                    left: 10, right: 10.0),
                                showDropdownIcon: true,
                                dropdownIcon: const Icon(
                                  Icons.arrow_drop_down_outlined,
                                  color: kWhite,
                                ),
                                dropdownIconPosition: IconPosition.trailing,
                                dropdownTextStyle: const TextStyle(
                                  color: kWhite,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),

                            //Whatsapp number
                            Text('WhatsApp Number *', style: kBodyTitleR),
                            const SizedBox(height: 16),
                            Theme(
                              data: Theme.of(context).copyWith(
                                textTheme: Theme.of(context).textTheme.apply(
                                      bodyColor: Colors.white,
                                      displayColor: Colors.white,
                                    ),
                                inputDecorationTheme:
                                    const InputDecorationTheme(
                                  hintStyle: TextStyle(color: Colors.white70),
                                ),
                              ),
                              child: IntlPhoneField(
                                validator: (phone) {
                                  if (phone!.number.length > 9) {
                                    if (phone.number.length > 10) {
                                      return 'Phone number cannot exceed 10 digits';
                                    }
                                  }
                                  return null;
                                },
                                style: const TextStyle(
                                  color: kWhite,
                                  letterSpacing: 8,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                                controller: _whatsAppController,
                                disableLengthCheck: true,
                                showCountryFlag: true,
                                cursorColor: kWhite,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: kInputFieldcolor,
                                  hintText: 'Enter your WhatsApp number',
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: .2,
                                    fontWeight: FontWeight.w200,
                                    color: kSecondaryTextColor,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide:
                                        BorderSide(color: kInputFieldcolor),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide:
                                        BorderSide(color: kInputFieldcolor),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: const BorderSide(
                                        color: kInputFieldcolor),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16.0,
                                    horizontal: 10.0,
                                  ),
                                ),
                                onCountryChanged: (value) {
                                  ref.read(countryCodeProvider.notifier).state =
                                      value.dialCode;
                                },
                                initialCountryCode: 'AE',
                                onChanged: (phone) {
                                  print(phone.completeNumber);
                                },
                                flagsButtonPadding: const EdgeInsets.only(
                                    left: 10, right: 10.0),
                                showDropdownIcon: true,
                                dropdownIcon: const Icon(
                                  Icons.arrow_drop_down_outlined,
                                  color: kWhite,
                                ),
                                dropdownIconPosition: IconPosition.trailing,
                                dropdownTextStyle: const TextStyle(
                                  color: kWhite,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),

                            //Emirates id Copy (document upload)
                            Text('Emirates ID Copy *', style: kBodyTitleR),
                            const SizedBox(height: 16),
                            Text('Upload Document (PDF only)',
                                style: kSmallerTitleR),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: _pickEmiratesIdDocument,
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: kInputFieldcolor,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color:
                                          kSecondaryTextColor.withOpacity(0.3)),
                                ),
                                child: Row(
                                  children: [
                                    const SizedBox(width: 12),
                                    Icon(Icons.upload_file,
                                        color: kSecondaryTextColor),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        _emiratesIdDocument != null
                                            ? _emiratesIdDocument!.path
                                                .split('/')
                                                .last
                                            : 'Upload Emirates ID',
                                        style: TextStyle(
                                          color: _emiratesIdDocument != null
                                              ? kWhite
                                              : kSecondaryTextColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Icon(Icons.cloud_upload_outlined,
                                        color: kSecondaryTextColor),
                                    const SizedBox(width: 12),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            //Passport copy (document upload)
                            Text('Passport Copy *', style: kBodyTitleR),
                            const SizedBox(height: 16),
                            Text('Upload Document (PDF only)',
                                style: kSmallerTitleR),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: _pickPassportDocument,
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: kInputFieldcolor,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color:
                                          kSecondaryTextColor.withOpacity(0.3)),
                                ),
                                child: Row(
                                  children: [
                                    const SizedBox(width: 12),
                                    Icon(Icons.upload_file,
                                        color: kSecondaryTextColor),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        _passportDocument != null
                                            ? _passportDocument!.path
                                                .split('/')
                                                .last
                                            : 'Upload Passport',
                                        style: TextStyle(
                                          color: _passportDocument != null
                                              ? kWhite
                                              : kSecondaryTextColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Icon(Icons.cloud_upload_outlined,
                                        color: kSecondaryTextColor),
                                    const SizedBox(width: 12),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                                height: 100), // Extra space before fixed button
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Fixed button at bottom
                  Container(
                    padding: const EdgeInsets.all(16),
                    // decoration: BoxDecoration(
                    //   color: kBackgroundColor,
                    //   border: Border(
                    //     top: BorderSide(
                    //         color: kSecondaryTextColor.withOpacity(0.2)),
                    //   ),
                    // ),
                    child: Consumer(
                      builder: (context, ref, child) {
                        return customButton(
                          isLoading: loading,
                          label: 'Send Request',
                          onPressed: () async {
                            // Validate required fields
                            if (_nameController.text.isEmpty ||
                                _emailController.text.isEmpty ||
                                _phoneController.text.isEmpty ||
                                _whatsAppController.text.isEmpty ||
                                _emiratesIdDocument == null ||
                                _passportDocument == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Please fill all required fields and upload documents'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            String? profileUrl;
                            String? emiratesIdUrl;
                            String? passportUrl;
                            ref.read(loadingProvider.notifier).startLoading();

                            try {
                              // Upload profile image
                              if (_profileImage != null) {
                                String tempImagePath =
                                    await saveUint8ListToFile(
                                        _profileImage!, 'profile.png');
                                profileUrl = await imageUpload(tempImagePath);
                              }

                              // Upload Emirates ID document
                              emiratesIdUrl = await documentUpload(
                                  _emiratesIdDocument!.path);

                              // Upload Passport document
                              passportUrl =
                                  await documentUpload(_passportDocument!.path);

                              UserDataApiService userDataApiService =
                                  ref.watch(userDataApiServiceProvider);
                              final response =
                                  await userDataApiService.updateUser(
                                      id,
                                      UserModel(
                                          name: _nameController.text,
                                          email: _emailController.text,
                                          image: profileUrl,
                                          phone: _phoneController.text,
                                          emiratesIdCopy: emiratesIdUrl,
                                          passportCopy: passportUrl,
                                          profession:
                                              _designationController.text,
                                          location: _locationController.text,
                                          status: 'pending'));
                              log(response.data.toString(), name: 'EDIT USER');
                              if (response.success == true) {
                                NavigationService navigationService =
                                    NavigationService();
                                navigationService.pushNamedReplacement(
                                    'ApprovalWaitingPage');
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error: ${e.toString()}'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } finally {
                              ref.read(loadingProvider.notifier).stopLoading();
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DocumentUpload {
  final File file;
  _DocumentUpload(this.file);
}
