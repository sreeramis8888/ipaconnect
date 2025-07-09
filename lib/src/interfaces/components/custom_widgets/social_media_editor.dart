import 'package:flutter/material.dart';

import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/models/company_model.dart';
import 'package:ipaconnect/src/data/models/user_model.dart';
import 'package:ipaconnect/src/data/services/navigation_service.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_button.dart';
import 'package:ipaconnect/src/interfaces/components/textFormFields/custom_text_form_field.dart';

class SocialMediaEditor extends StatefulWidget {
  final List<UserSocialMedia> socialMedias;
  final String platform;
  final IconData icon;
  final void Function(
          List<UserSocialMedia> socialMedias, String platform, String newUrl)
      onSave;

  const SocialMediaEditor({
    Key? key,
    required this.socialMedias,
    required this.platform,
    required this.icon,
    required this.onSave,
  }) : super(key: key);

  @override
  _SocialMediaEditorState createState() => _SocialMediaEditorState();
}

class _SocialMediaEditorState extends State<SocialMediaEditor> {
  String? currentValue;
  NavigationService navigationService = NavigationService();
  @override
  void initState() {
    super.initState();

    final existing = widget.socialMedias.firstWhere(
        (link) => link.name == widget.platform,
        orElse: () => UserSocialMedia(name: null, url: null));
    currentValue = existing.url;
  }

  void _showEditModal() {
    TextEditingController textController =
        TextEditingController(text: currentValue);

    showModalBottomSheet(
      context: context, backgroundColor: kCardBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true, // Enable proper resizing when keyboard appears
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                          color: kGreyDarker,
                          borderRadius: BorderRadius.circular(16)),
                      width: 70, // Width of the line
                      height: 4, // Thickness of the line
                      // Line color
                    ),
                  ),
                ),
                CustomTextFormField(
                  backgroundColor: kStrokeColor,
                  labelText: 'Enter URL for ${widget.platform}',
                  textController: textController,
                ),
                const SizedBox(height: 16),
                customButton(
                  label: 'Save',
                  onPressed: () {
                    widget.onSave(widget.socialMedias, widget.platform,
                        textController.text.trim());
                    setState(() {
                      currentValue = textController.text.trim().isNotEmpty
                          ? textController.text.trim()
                          : null;
                    });
                    navigationService.pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isValuePresent = currentValue != null && currentValue!.isNotEmpty;

    return GestureDetector(
      onTap: _showEditModal,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            shape: BoxShape.rectangle,
            color: isValuePresent ? kPrimaryColor : kCardBackgroundColor),
        padding: const EdgeInsets.all(16),
        child: Icon(
          widget.icon,
          color: isValuePresent ? kCardBackgroundColor : kPrimaryColor,
        ),
      ),
    );
  }
}
