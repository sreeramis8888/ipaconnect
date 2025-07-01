import 'dart:io';
import 'dart:typed_data';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_button.dart';
import 'package:ipaconnect/src/interfaces/components/textFormFields/custom_text_form_field.dart';
import '../../data/constants/color_constants.dart';
import '../../data/services/navigation_service.dart';
import '../additional_screens/crop_image_screen.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

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
            builder: (context) =>
                CropImageScreen(imageFile: File(pickedFile.path)),
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

  Future<void> _submit() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 100,
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
                        padding: const EdgeInsets.all(4.0), // Adjust spacing
                        child: CircleAvatar(
                          radius:
                              44, // Reduce radius slightly to fit inside border
                          backgroundColor: kInputFieldcolor,
                          backgroundImage: _profileImage != null
                              ? MemoryImage(_profileImage!)
                              : null,
                          child: _profileImage == null
                              ? Icon(Icons.person,
                                  size: 44, color: Colors.white)
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
                              color: Colors.white, size: 18),
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
              Text('Desgination', style: kBodyTitleR),
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
              customButton(
                label: 'SEND REQUEST',
                onPressed: () {
                  NavigationService navigationService = NavigationService();
                  navigationService.pushNamedReplacement('ApprovalWaitingPage');
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
