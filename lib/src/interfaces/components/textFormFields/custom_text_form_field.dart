import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/notifiers/user_notifier.dart';

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
  final Color backgroundColor;
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
    this.backgroundColor = kInputFieldcolor,
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
                  case 'Enter your Name':
                    ref.read(userProvider.notifier).updateName(
                          name: textController!.text,
                        );
                    break;

                  case 'Enter Personal Address':
                    ref
                        .read(userProvider.notifier)
                        .updateAddress(textController!.text);
                    break;

                  case 'Enter your Profession':
                    ref
                        .read(userProvider.notifier)
                        .updateProfession(profession: textController!.text);
                    break;

                  case 'Bio':
                    ref
                        .read(userProvider.notifier)
                        .updateBio(bio: textController!.text);
                    break;

                  case 'Enter Instagram':
                    final currentSocials =
                        ref.read(userProvider).value?.socialMedia ?? [];
                    ref.read(userProvider.notifier).updateSocialMediaEntry(
                          currentSocials,
                          'instagram',
                          textController!.text,
                        );

                  case 'Enter Linkedin':
                    final currentSocials =
                        ref.read(userProvider).value?.socialMedia ?? [];
                    ref.read(userProvider.notifier).updateSocialMediaEntry(
                          currentSocials,
                          'linkedin',
                          textController!.text,
                        );

                    break;
                  case 'Enter Twitter':
                    final currentSocials =
                        ref.read(userProvider).value?.socialMedia ?? [];
                    ref.read(userProvider.notifier).updateSocialMediaEntry(
                          currentSocials,
                          'twitter',
                          textController!.text,
                        );

                    break;

                  case 'Enter Facebook':
                    final currentSocials =
                        ref.read(userProvider).value?.socialMedia ?? [];
                    ref.read(userProvider.notifier).updateSocialMediaEntry(
                          currentSocials,
                          'facebook',
                          textController!.text,
                        );

                    break;

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
                fillColor: backgroundColor,
                filled: true,
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10, horizontal: 12), // << Add this line
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: backgroundColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: backgroundColor),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: backgroundColor),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: backgroundColor),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
