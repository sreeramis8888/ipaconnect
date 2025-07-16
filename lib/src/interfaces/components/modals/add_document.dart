import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_button.dart';
import 'package:ipaconnect/src/interfaces/components/loading/loading_indicator.dart';
import 'package:ipaconnect/src/interfaces/components/textFormFields/custom_text_form_field.dart';

class ShowAddDocumentSheet extends StatefulWidget {
  final TextEditingController textController;
  final Future<File?> Function() pickPdf;
  final Future<void> Function() addBrochureCard;
  final String brochureName;

  ShowAddDocumentSheet({
    super.key,
    required this.textController,
    required this.pickPdf,
    required this.addBrochureCard,
    required this.brochureName,
  });

  @override
  State<ShowAddDocumentSheet> createState() => _ShowAddDocumentSheetState();
}

class _ShowAddDocumentSheetState extends State<ShowAddDocumentSheet> {
  final _formKey = GlobalKey<FormState>();
  File? brochurePdf;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        widget.textController.text = '';
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
                    'Add Brochure',
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
                initialValue: brochurePdf,
                validator: (value) {
                  if (value == null) {
                    return 'Please upload a PDF';
                  }
                  return null;
                },
                builder: (FormFieldState<File> state) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final pickedFile = await widget.pickPdf();
                          if (pickedFile == null) {
                            Navigator.pop(context);
                          }
                          setState(() {
                            brochurePdf = pickedFile;
                            state.didChange(pickedFile);
                          });
                        },
                        child: brochurePdf == null
                            ? Container(
                                height: 110,
                                decoration: BoxDecoration(
                                  color: kStrokeColor,
                                  borderRadius: BorderRadius.circular(10),
                                  border: state.hasError
                                      ? Border.all(color: Colors.red)
                                      : null,
                                ),
                                child: const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add,
                                          size: 27, color: Color(0xFF004797)),
                                      SizedBox(height: 10),
                                      Text(
                                        'Upload PDF',
                                        style: TextStyle(color: kWhite),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : const Center(
                                child: Text(
                                  'PDF ADDED',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.green,
                                  ),
                                ),
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
                label: 'Add Name',
                textController: widget.textController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name for the brochure';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              customButton(
                label: 'SAVE',
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) =>
                          const Center(child: LoadingAnimation()),
                    );

                    try {
                      await widget.addBrochureCard();
                      widget.textController.clear();

                      if (brochurePdf != null) {
                        setState(() {
                          brochurePdf = null;
                        });
                      }
                    } finally {
                      Navigator.of(context).pop();
                      Navigator.pop(context);
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
