import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final bool readOnly;
  final int maxLines;
  final TextEditingController? textController;
  final int? companyIndex;
  final FormFieldValidator<String>? validator;
  final VoidCallback? onChanged;
  final bool? enabled;
  final bool? isAward;
  final String? title;
  final TextInputType textInputType;
  const CustomTextFormField({
    super.key,
    required this.labelText,
    this.readOnly = false,
    this.maxLines = 1,
    required this.textController,
    this.validator,
    this.onChanged,
    this.enabled,
    this.isAward,
    this.title,
    this.textInputType = TextInputType.text,
    this.companyIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Column(
          children: [
            if (title != null)
              Row(
                children: [
                  Text(
                    title ?? '',
                    style: kSmallTitleM,
                  ),
                ],
              ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              style: kBodyTitleR,
              cursorColor: kWhite,
              keyboardType: textInputType,
              enabled: enabled,
              onChanged: (value) {
                log(companyIndex.toString());
                switch (labelText) {
                  // case 'Enter your Name':
                  //   ref.read(userProvider.notifier).updateName(
                  //         textController!.text,
                  //       );
                  //   break;

                  // case 'Enter Personal Address':
                  //   ref
                  //       .read(userProvider.notifier)
                  //       .updateAddress(textController!.text);
                  //   break;

                  // case 'Enter Designation':
                  //   ref
                  //       .read(userProvider.notifier)
                  //       .updateOccupation(textController!.text);
                  //   break;

                  // case 'Bio':
                  //   ref
                  //       .read(userProvider.notifier)
                  //       .updateBio(textController!.text);
                  //   break;

                  // case 'Enter Instagram':
                  //   ref.read(userProvider.notifier).updateSocialMedia(
                  //       [...?ref.read(userProvider).value?.social],
                  //       'instagram',
                  //       textController!.text);
                  //   break;

                  // case 'Enter Linkedin':
                  //   ref.read(userProvider.notifier).updateSocialMedia(
                  //       [...?ref.read(userProvider).value?.social],
                  //       'linkedin',
                  //       textController!.text);
                  //   break;

                  // case 'Enter Twitter':
                  //   ref.read(userProvider.notifier).updateSocialMedia(
                  //       [...?ref.read(userProvider).value?.social],
                  //       'twitter',
                  //       textController!.text);
                  //   break;

                  // case 'Enter Facebook':
                  //   ref.read(userProvider.notifier).updateSocialMedia(
                  //       [...?ref.read(userProvider).value?.social],
                  //       'facebook',
                  //       textController!.text);
                  //   break;

                  default:
                }
              },
              readOnly: readOnly,
              controller: textController,
              maxLines: maxLines,
              validator: validator,
              decoration: InputDecoration(
                errorMaxLines: 2,
                hintStyle: TextStyle(color: Color(0xFF979797), fontSize: 14),
                hintText: labelText,
                labelStyle: const TextStyle(color: Colors.grey),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                fillColor: kInputFieldcolor,
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: kInputFieldcolor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: kInputFieldcolor),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: kInputFieldcolor),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: kInputFieldcolor),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
