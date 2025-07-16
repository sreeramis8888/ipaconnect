import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_button.dart';
import 'package:ipaconnect/src/interfaces/components/loading/loading_indicator.dart';
import 'package:ipaconnect/src/interfaces/components/textFormFields/custom_text_form_field.dart';

class ShowEnterAwardSheet extends StatefulWidget {
  final TextEditingController textController1;
  final TextEditingController textController2;
  final Future<void> Function()? addAwardCard;
  final Future<void> Function()? editAwardCard;
  final String imageType;
  final Future<File?> Function({required String imageType}) pickImage;
  final String? imageUrl;
  const ShowEnterAwardSheet({
    required this.textController1,
    required this.textController2,
    this.addAwardCard,
    required this.pickImage,
    required this.imageType,
    super.key,
    this.editAwardCard,
    this.imageUrl,
  });

  @override
  State<ShowEnterAwardSheet> createState() => _ShowEnterAwardSheetState();
}

class _ShowEnterAwardSheetState extends State<ShowEnterAwardSheet> {
  final _formKey = GlobalKey<FormState>();
  File? awardImage; // Moved awardImage to State
  bool get isEditMode => widget.editAwardCard != null;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        widget.textController1.text = '';
        widget.textController2.text = '';
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add Awards',
                    style: TextStyle(
                      color: kWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: kWhite,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              FormField<File>(
                initialValue: awardImage,
                validator: (value) {
                  if (isEditMode && awardImage == null) {
                    return null;
                  }
                  if (!isEditMode && value == null && widget.imageUrl == null) {
                    return 'Please upload an image';
                  }
                  return null;
                },
                builder: (FormFieldState<File> state) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final pickedFile = await widget.pickImage(
                              imageType: widget.imageType);
                          if (pickedFile == null) {
                            return; // Don't pop if no image selected
                          }
                          setState(() {
                            awardImage = pickedFile;
                            state.didChange(
                                pickedFile); // Update form field state
                          });
                        },
                        child: Container(
                          height: 110,
                          decoration: BoxDecoration(
                            color: kStrokeColor,
                            borderRadius: BorderRadius.circular(10),
                            border: state.hasError
                                ? Border.all(color: Colors.red)
                                : null,
                          ),
                          child: awardImage == null
                              ? widget.imageUrl != null
                                  ? Center(
                                      child:
                                          Image.network(widget.imageUrl ?? ''),
                                    )
                                  : const Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.add,
                                              size: 27, color: kPrimaryColor),
                                          SizedBox(height: 10),
                                          Text(
                                            'Upload Image',
                                            style: TextStyle(color: kWhite),
                                          ),
                                        ],
                                      ),
                                    )
                              : Center(
                                  child: Image.file(
                                  awardImage!,
                                  fit: BoxFit.cover,
                                  width: 120,
                                  height: 120,
                                )),
                        ),
                      ),
                      if (state.hasError)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            state.errorText!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
              ModalSheetTextFormField(
                label: 'Add name',
                textController: widget.textController1,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              ModalSheetTextFormField(
                label: 'Add Authority name',
                textController: widget.textController2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the authority name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              customButton(
                label: isEditMode ? 'UPDATE' : 'SAVE',
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) =>
                          const Center(child: LoadingAnimation()),
                    );

                    try {
                      if (isEditMode) {
                        // Edit mode - handle both text-only and image updates
                        await widget.editAwardCard!();
                      } else {
                        // Add mode - always needs image
                        await widget.addAwardCard!();
                      }

                      widget.textController1.clear();
                      widget.textController2.clear();

                      if (awardImage != null) {
                        setState(() {
                          awardImage = null; // Clear the image after saving
                        });
                      }
                    } catch (e) {
                      print('Error updating award: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to update award: $e')),
                      );
                    } finally {
                      Navigator.of(context).pop(); // Close loading dialog
                      Navigator.pop(context); // Close modal sheet
                    }
                  }
                },
                fontSize: 16,
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
