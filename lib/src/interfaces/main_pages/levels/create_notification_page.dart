import 'dart:developer';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_round_button.dart'
    show CustomRoundButton;

import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:path/path.dart' as Path;
import 'package:ipaconnect/src/data/models/heirarchy_model.dart';
import 'package:ipaconnect/src/data/models/user_model.dart';
import 'package:ipaconnect/src/data/services/api_routes/hierarchy/hierarchy_api_service.dart';
import 'package:ipaconnect/src/data/services/api_routes/notification_api/notification_api_service.dart';
import 'package:ipaconnect/src/data/services/image_upload.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';

import 'package:ipaconnect/src/interfaces/components/buttons/custom_button.dart';
import 'package:ipaconnect/src/interfaces/components/loading/loading_indicator.dart';
import 'package:ipaconnect/src/interfaces/components/textFormFields/custom_text_form_field.dart';

class CreateNotificationPage extends ConsumerStatefulWidget {
  final String? hierarchyId;
  final String? hierarchyName;
  const CreateNotificationPage({
    super.key,
    this.hierarchyId,
    this.hierarchyName,
  });

  @override
  ConsumerState<CreateNotificationPage> createState() =>
      _CreateNotificationPageState();
}

class _CreateNotificationPageState
    extends ConsumerState<CreateNotificationPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  TextEditingController linkController = TextEditingController();

  // For hierarchy selection
  List<HierarchyModel> _selectedHierarchies = [];
  List<String> _selectedHierarchyIds = [];

  // For user selection (when hierarchy is selected)
  List<UserModel> _selectedUsers = [];
  List<String> _selectedUserIds = [];

  File? notificationImage;
  String? notificationImageUrl;

  // Track if we're selecting hierarchies or users
  bool _isSelectingHierarchies = true;

  void _showHierarchyMultiSelect(
      List<HierarchyModel> items, BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return MultiSelectDialog(
          items: items
              .map((e) => MultiSelectItem(e, e.name ?? 'Unnamed Hierarchy'))
              .toList(),
          initialValue: _selectedHierarchies,
          onConfirm: (values) {
            setState(() {
              _selectedHierarchies = values.cast<HierarchyModel>();
              _selectedHierarchyIds = _selectedHierarchies
                  .map((item) => item.id ?? '')
                  .where((id) => id.isNotEmpty)
                  .toList();
            });
          },
          title: const Text(
            "Select Hierarchies",
            style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),
          ),
          selectedColor: kPrimaryColor,
          checkColor: Colors.white,
          searchable: true,
          confirmText: const Text(
            "CONFIRM",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: kPrimaryColor,
            ),
          ),
          cancelText: const Text(
            "CANCEL",
            style: TextStyle(color: Color.fromARGB(255, 130, 130, 130)),
          ),
          backgroundColor: Colors.white,
        );
      },
    );
  }

  void _showUserMultiSelect(List<UserModel> items, BuildContext context) async {
    // Add a dummy user for "All Users"
    final allUsersOption = UserModel(id: '*', name: 'All Users');
    final allItems = [allUsersOption, ...items];

    await showDialog(
      context: context,
      builder: (ctx) {
        return MultiSelectDialog(
            selectedItemsTextStyle: kSmallTitleB,
            itemsTextStyle: kSmallTitleB,
            items: allItems
                .map((e) => MultiSelectItem(e, e.name ?? 'Unnamed User'))
                .toList(),
            initialValue: _selectedUsers,
            onConfirm: (values) {
              setState(() {
                if (values.any((user) => user.id == '*')) {
                  _selectedUsers = [allUsersOption];
                  _selectedUserIds = ['*'];
                } else {
                  _selectedUsers = values.cast<UserModel>();
                  _selectedUserIds = _selectedUsers
                      .map((item) => item.id ?? '')
                      .where((id) => id.isNotEmpty)
                      .toList();
                }
              });
            },
            title: const Text(
              "Select Users",
              style:
                  TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),
            ),
            selectedColor: kPrimaryColor,
            checkColor: Colors.white,
            searchIcon: Icon(
              Icons.search_sharp,
              color: kWhite,
            ),
            searchable: true,
            confirmText: const Text(
              "CONFIRM",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: kPrimaryColor,
              ),
            ),
            cancelText: const Text(
              "CANCEL",
              style: TextStyle(color: Color.fromARGB(255, 130, 130, 130)),
            ),
            unselectedColor: kWhite,
            backgroundColor: kCardBackgroundColor);
      },
    );
  }

  Future<File?> _pickFile({required String imageType}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'png',
        'jpg',
        'jpeg',
      ],
    );

    if (result != null) {
      notificationImage = File(result.files.single.path!);
      return notificationImage;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final asyncHierarchies = ref.watch(getHierarchyProvider);
    // If hierarchyId is provided, always use it for user selection
    final bool isFromHierarchy =
        widget.hierarchyId != null && widget.hierarchyId!.isNotEmpty;
    final String? effectiveHierarchyId = isFromHierarchy
        ? widget.hierarchyId
        : (_selectedHierarchyIds.isNotEmpty
            ? _selectedHierarchyIds.first
            : null);
    final asyncHierarchyUsers = effectiveHierarchyId != null
        ? ref.watch(getHierarchyUsersProvider(
            hierarchyId: effectiveHierarchyId, page: 1, limit: 100))
        : null;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          backgroundColor: kBackgroundColor,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: CustomRoundButton(
                offset: Offset(4, 0),
                iconPath: 'assets/svg/icons/arrow_back_ios.svg',
              ),
            ),
          ),
          title: Text('Activities',
              style: kBodyTitleR.copyWith(
                  fontSize: 16, color: kSecondaryTextColor)),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if ((isFromHierarchy) ||
                  (_isSelectingHierarchies &&
                      _selectedHierarchyIds.isNotEmpty)) ...[
                const SizedBox(height: 16),
                Text(
                    isFromHierarchy
                        ? 'Select Members from ${widget.hierarchyName ?? "Hierarchy"}'
                        : 'Or Select Specific Users from Hierarchy',
                    style: kSmallTitleB),
                const SizedBox(height: 8),
                if (asyncHierarchyUsers != null)
                  asyncHierarchyUsers.when(
                    data: (users) {
                      return GestureDetector(
                        onTap: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          _showUserMultiSelect(users, context);
                        },
                        child: Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: kCardBackgroundColor,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedUsers.isEmpty
                                    ? "Select Users"
                                    : "${_selectedUsers.length} selected",
                                style: TextStyle(color: kGreyDark),
                              ),
                              const Icon(Icons.arrow_drop_down,
                                  color: kSecondaryTextColor),
                            ],
                          ),
                        ),
                      );
                    },
                    loading: () => const Center(child: LoadingAnimation()),
                    error: (error, stackTrace) => const SizedBox(),
                  ),
                const SizedBox(height: 10),
                MultiSelectChipDisplay(
                  items: _selectedUsers
                      .map((e) => MultiSelectItem(e, e.name ?? 'Unnamed User'))
                      .toList(),
                  onTap: (value) {
                    setState(() {
                      _selectedUsers.remove(value);
                      _selectedUserIds = _selectedUsers
                          .map((item) => item.id ?? '')
                          .where((id) => id.isNotEmpty)
                          .toList();
                      // If 'All Users' chip is removed, clear '*'
                      if (_selectedUserIds.contains('*')) {
                        _selectedUserIds.remove('*');
                      }
                    });
                  },
                  icon: const Icon(Icons.close),
                  chipColor: const Color.fromARGB(255, 224, 224, 224),
                  textStyle: const TextStyle(color: Colors.black),
                ),
              ],

              // Direct User Selection
              if (!isFromHierarchy &&
                  !_isSelectingHierarchies &&
                  !_selectedUserIds.contains('*')) ...[
                const Text(
                  'Select Users',
                  style: TextStyle(color: Colors.orange, fontSize: 16),
                ),
                const SizedBox(height: 8),
                // For now, show a placeholder. You might want to implement a user search/selection
                Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: kWhite,
                    border: Border.all(color: kGreyLight),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "User selection not implemented yet",
                        style: TextStyle(color: kGreyDark),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ],

              if (!isFromHierarchy && _selectedUserIds.contains('*')) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: kPrimaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: kPrimaryColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: kPrimaryColor, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Notification will be sent to all users in the system',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 16),

              // Title Field
              Text(
                'Title',
                style: kSmallTitleB,
              ),
              const SizedBox(height: 8),
              CustomTextFormField(
                labelText: 'Notification Title',
                textController: titleController,
              ),
              const SizedBox(height: 16),

              // Message Field
              Text(
                'Message',
                style: kSmallTitleB,
              ),
              const SizedBox(height: 8),
              CustomTextFormField(
                maxLines: 3,
                labelText: 'Message',
                textController: messageController,
              ),
              const SizedBox(height: 16),

              // Upload Image
              Text(
                'Upload Image',
                style: kSmallTitleB,
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return const Center(
                        child: LoadingAnimation(),
                      );
                    },
                  );

                  final pickedFile = await _pickFile(imageType: 'product');
                  if (pickedFile == null) {
                    Navigator.pop(context);
                  }

                  setState(() {
                    notificationImage = pickedFile;
                  });

                  Navigator.of(context).pop();
                },
                child: DottedBorder(
                  color: kPrimaryColor,
                  strokeWidth: 1,
                  dashPattern: const [6, 3],
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(10),
                  child: Container(
                    width: double.infinity,
                    height: 120,
                    color: kCardBackgroundColor,
                    child: Center(
                        child: notificationImage == null
                            ? const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    'Upload Image',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  children: [
                                    if (notificationImage != null)
                                      Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          height: double.infinity,
                                          width: 60,
                                          child:
                                              Image.file(notificationImage!)),
                                    const Spacer(),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          notificationImage = null;
                                        });
                                      },
                                      child: SvgPicture.asset(
                                        'assets/svg/icons/menu_icons/delete.svg',
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Add Link
              Text(
                'Add Link',
                style: kSmallTitleB,
              ),
              const SizedBox(height: 8),
              CustomTextFormField(
                labelText: 'Link',
                textController: linkController,
              ),
              const SizedBox(height: 24),

              // Submit Button
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: customButton(
                  label: 'Send Notification',
                  onPressed: () async {
                    // Validate inputs
                    if (titleController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a title')),
                      );
                      return;
                    }

                    if (messageController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a message')),
                      );
                      return;
                    }

                    if (_isSelectingHierarchies &&
                        _selectedHierarchyIds.isEmpty &&
                        _selectedUserIds.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Please select hierarchies or users')),
                      );
                      return;
                    }

                    if (!_isSelectingHierarchies && _selectedUserIds.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Please select users or choose "All Users"')),
                      );
                      return;
                    }

                    // Show loading dialog
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return const Center(
                          child: LoadingAnimation(),
                        );
                      },
                    );

                    try {
                      // Upload image if selected
                      if (notificationImage != null) {
                        notificationImageUrl =
                            await imageUpload(notificationImage!.path);
                      }

                      // Create notification
                      final notificationApiService =
                          ref.watch(notificationApiServiceProvider);
                      bool success = false;
                      List<String> targetUserIds = [];

                      if (_selectedUserIds.contains('*')) {
                        // Send to all users
                        success = await notificationApiService
                            .sendNotifcationToHierarchy(
                          subject: titleController.text,
                          content: messageController.text,
                          image: notificationImageUrl,
                          link: linkController.text.isNotEmpty
                              ? linkController.text
                              : null,
                          types: ['in-app'],
                          status: 'sended',
                        );
                      } else {
                        if (_isSelectingHierarchies) {
                          if (_selectedUserIds.isNotEmpty) {
                            // Send to specific users from hierarchy
                            targetUserIds = _selectedUserIds;
                          } else {
                            // Get all users from selected hierarchies
                            targetUserIds = await _getUsersFromHierarchies(
                                _selectedHierarchyIds);
                          }
                        } else {
                          // Send to specific users
                          targetUserIds = _selectedUserIds;
                        }

                        if (targetUserIds.isEmpty) {
                          Navigator.pop(context); // Close loading dialog
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'No users found to send notification to')),
                          );
                          return;
                        }

                        // Send notification
                        success =
                            await notificationApiService.createNotification(
                          userIds: targetUserIds,
                          subject: titleController.text,
                          content: messageController.text,
                          image: notificationImageUrl,
                          link: linkController.text.isNotEmpty
                              ? linkController.text
                              : null,
                          types: ['in-app'], // Default to in-app notification
                          status: 'sended', // Default status
                        );
                      }

                      Navigator.pop(context); // Close loading dialog

                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Notification sent successfully')),
                        );
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Failed to send notification')),
                        );
                      }
                    } catch (e) {
                      Navigator.pop(context); // Close loading dialog
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${e.toString()}')),
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to get users from hierarchies
  Future<List<String>> _getUsersFromHierarchies(
      List<String> hierarchyIds) async {
    List<String> allUserIds = [];

    try {
      for (String hierarchyId in hierarchyIds) {
        // Get users from each hierarchy
        final users = await ref.read(getHierarchyUsersProvider(
          hierarchyId: hierarchyId,
          page: 1,
          limit: 1000, // Get all users from hierarchy
        ).future);

        // Extract user IDs
        final userIds = users
            .map((user) => user.id ?? '')
            .where((id) => id.isNotEmpty)
            .toList();
        allUserIds.addAll(userIds);
      }

      // Remove duplicates
      allUserIds = allUserIds.toSet().toList();

      log('Found ${allUserIds.length} users from ${hierarchyIds.length} hierarchies',
          name: 'Notification');
    } catch (e) {
      log('Error getting users from hierarchies: $e', name: 'Notification');
    }

    return allUserIds;
  }
}
