import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/services/image_upload.dart';
import 'package:ipaconnect/src/data/utils/globals.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_button.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_round_button.dart';
import 'package:ipaconnect/src/interfaces/components/dropdown/selectionDropdown.dart';
import 'package:ipaconnect/src/interfaces/components/loading/loading_indicator.dart';
import 'package:ipaconnect/src/interfaces/components/textFormFields/custom_text_form_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/services/api_routes/events_api/events_api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ipaconnect/src/data/services/api_service.dart';
import 'package:ipaconnect/src/interfaces/additional_screens/crop_image_screen.dart';
import 'dart:typed_data';
import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:ipaconnect/src/data/notifiers/loading_notifier.dart';
import 'package:ipaconnect/src/data/notifiers/members_notifier.dart';
import 'package:ipaconnect/src/data/models/user_model.dart';
import 'package:ipaconnect/src/data/models/events_model.dart';
import 'package:ipaconnect/src/data/services/snackbar_service.dart';

class AddEventPage extends StatefulWidget {
  final EventsModel? eventToEdit;
  const AddEventPage({Key? key, this.eventToEdit}) : super(key: key);

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final _formKey = GlobalKey<FormState>();
  String? _eventType;
  String? _platform;
  File? _eventImage;
  String? _existingImageUrl; // For editing existing events
  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  final TextEditingController _venueController = TextEditingController();
  final TextEditingController _organiserNameController =
      TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  // Speaker fields
  final TextEditingController _speakerNameController = TextEditingController();
  final TextEditingController _speakerDesignationController =
      TextEditingController();
  final TextEditingController _speakerRoleController = TextEditingController();
  File? _speakerImage;
  List<Map<String, dynamic>> _speakers = [];
  List<UserModel> _selectedCoordinators = [];

  int? _limit;
  DateTime? _posterVisibilityStartDate;
  DateTime? _posterVisibilityEndDate;
  final TextEditingController _limitController = TextEditingController();
  final TextEditingController _posterVisibilityStartDateController =
      TextEditingController();
  final TextEditingController _posterVisibilityEndDateController =
      TextEditingController();

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickEventImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (pickedFile != null) {
      // Crop the image to 16:9
      final croppedBytes = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CropImageScreen(
            imageFile: File(pickedFile.path),
            width: 16,
            height: 9,
            shape: CustomCropShape.Ratio,
          ),
        ),
      );
      if (croppedBytes != null && croppedBytes is Uint8List) {
        // Save cropped image to temp file
        final croppedPath =
            await saveUint8ListToFile(croppedBytes, 'event_cropped.jpg');
        setState(() {
          _eventImage = File(croppedPath);
        });
      }
    }
  }

  Future<void> _pickSpeakerImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (pickedFile != null) {
      // Crop the image to circle
      final croppedBytes = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CropImageScreen(
            imageFile: File(pickedFile.path),
            width: 1,
            height: 1,
            shape: CustomCropShape.Circle,
          ),
        ),
      );
      if (croppedBytes != null && croppedBytes is Uint8List) {
        final croppedPath =
            await saveUint8ListToFile(croppedBytes, 'speaker_cropped.jpg');
        setState(() {
          _speakerImage = File(croppedPath);
        });
      }
    }
  }

  void _addSpeaker() async {
    if (_speakerNameController.text.isEmpty) return;
    String? imageUrl;
    if (_speakerImage != null) {
      imageUrl = await imageUpload(_speakerImage!.path);
    }
    setState(() {
      _speakers.add({
        'name': _speakerNameController.text,
        'designation': _speakerDesignationController.text,
        'role': _speakerRoleController.text,
        if (imageUrl != null) 'image': imageUrl,
      });
      _speakerNameController.clear();
      _speakerDesignationController.clear();
      _speakerRoleController.clear();
      _speakerImage = null;
    });
  }

  void _removeSpeaker(int index) {
    setState(() {
      _speakers.removeAt(index);
    });
  }

  Future<void> _pickDate({required bool isStart}) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          _startDateController.text =
              _startDate!.toLocal().toString().split(' ')[0];
        } else {
          _endDate = picked;
          _endDateController.text =
              _endDate!.toLocal().toString().split(' ')[0];
        }
      });
    }
  }

  Future<void> _pickTime({required bool isStart}) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
          _startTimeController.text = _startTime!.format(context);
        } else {
          _endTime = picked;
          _endTimeController.text = _endTime!.format(context);
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.eventToEdit != null) {
      final event = widget.eventToEdit!;
      _eventType = event.type;
      _platform = event.platform;
      if (event.image != null && event.image!.isNotEmpty) {
        _existingImageUrl = event.image;
      }
      _startDate = event.eventStartDate;
      _endDate = event.eventEndDate;
      if (_startDate != null) {
        _startTime = TimeOfDay.fromDateTime(_startDate!);
        _startDateController.text =
            _startDate!.toLocal().toString().split(' ')[0];
        _startTimeController.text = _startTime!.format(context);
      }
      if (_endDate != null) {
        _endTime = TimeOfDay.fromDateTime(_endDate!);
        _endDateController.text = _endDate!.toLocal().toString().split(' ')[0];
        _endTimeController.text = _endTime!.format(context);
      }
      _eventNameController.text = event.eventName ?? '';
      _descriptionController.text = event.description ?? '';
      _linkController.text = event.link ?? '';
      _venueController.text = event.venue ?? '';
      _organiserNameController.text = event.organiserName ?? '';
      _limit = event.limit;
      _limitController.text = event.limit?.toString() ?? '';
      _posterVisibilityStartDate = event.posterVisibilityStartDate;
      _posterVisibilityEndDate = event.posterVisibilityEndDate;
      if (_posterVisibilityStartDate != null) {
        _posterVisibilityStartDateController.text =
            _posterVisibilityStartDate!.toLocal().toString().split(' ')[0];
      }
      if (_posterVisibilityEndDate != null) {
        _posterVisibilityEndDateController.text =
            _posterVisibilityEndDate!.toLocal().toString().split(' ')[0];
      }
      if (event.speakers != null) {
        _speakers = event.speakers!
            .map((speaker) => {
                  'name': speaker.name ?? '',
                  'designation': speaker.designation ?? '',
                  'role': speaker.role ?? '',
                  if (speaker.image != null) 'image': speaker.image,
                })
            .toList();
      }
      // Note: coordinators will need to be fetched separately as they are just IDs
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          backgroundColor: kBackgroundColor,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(8),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: CustomRoundButton(
                offset: Offset(4, 0),
                iconPath: 'assets/svg/icons/arrow_back_ios.svg',
              ),
            ),
          ),
          title: Text(
              widget.eventToEdit != null ? 'Edit Event' : 'Add New Event',
              style: kBodyTitleR.copyWith(
                  fontSize: 16, color: kSecondaryTextColor)),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SelectionDropDown(
                  backgroundColor: kCardBackgroundColor,
                  labelWidget: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: 'Type of Event ', style: kSmallTitleB),
                        TextSpan(
                            text: '*',
                            style: kSmallTitleB.copyWith(color: kRed)),
                      ],
                    ),
                  ),
                  value: _eventType,
                  hintText: 'Select',
                  items: [
                    DropdownMenuItem(value: 'Offline', child: Text('Offline')),
                    DropdownMenuItem(value: 'Online', child: Text('Online')),
                  ],
                  onChanged: (val) => setState(() => _eventType = val),
                  validator: (val) => val == null ? 'Please select type' : null,
                ),

                CustomTextFormField(
                  backgroundColor: kCardBackgroundColor,
                  titleWidget: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: 'Name ', style: kSmallTitleB),
                        TextSpan(
                            text: '*',
                            style: kSmallTitleB.copyWith(color: kRed)),
                      ],
                    ),
                  ),
                  labelText: 'Enter the name of event',
                  textController: _eventNameController,
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Enter event name' : null,
                ),
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: 'Event Image ', style: kSmallTitleB),
                      TextSpan(
                          text: '*', style: kSmallTitleB.copyWith(color: kRed)),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: _pickEventImage,
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
                          child: _eventImage == null &&
                                  _existingImageUrl == null
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Row(
                                    children: [
                                      if (_eventImage != null)
                                        Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            height: double.infinity,
                                            width: 60,
                                            child: Image.file(_eventImage!))
                                      else if (_existingImageUrl != null)
                                        Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            height: double.infinity,
                                            width: 60,
                                            child: Image.network(
                                                _existingImageUrl!)),
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _eventImage = null;
                                            _existingImageUrl = null;
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
                const SizedBox(height: 10),
                CustomTextFormField(
                  backgroundColor: kCardBackgroundColor,
                  titleWidget: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: 'Description ', style: kSmallTitleB),
                        TextSpan(
                            text: '*',
                            style: kSmallTitleB.copyWith(color: kRed)),
                      ],
                    ),
                  ),
                  labelText: 'Enter the content here',
                  textController: _descriptionController,
                  maxLines: 4,
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Enter description' : null,
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _pickDate(isStart: true),
                  child: AbsorbPointer(
                    child: CustomTextFormField(
                      backgroundColor: kCardBackgroundColor,
                      titleWidget: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(text: 'Start Date ', style: kSmallTitleB),
                            TextSpan(
                                text: '*',
                                style: kSmallTitleB.copyWith(color: kRed)),
                          ],
                        ),
                      ),
                      labelText: 'Select Start Date from Calendar',
                      textController: _startDateController,
                      readOnly: true,
                      validator: (val) => val == null || val.isEmpty
                          ? 'Select start date'
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _pickDate(isStart: false),
                  child: AbsorbPointer(
                    child: CustomTextFormField(
                      backgroundColor: kCardBackgroundColor,
                      titleWidget: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(text: 'End Date ', style: kSmallTitleB),
                            TextSpan(
                                text: '*',
                                style: kSmallTitleB.copyWith(color: kRed)),
                          ],
                        ),
                      ),
                      labelText: 'Select End Date from Calendar',
                      textController: _endDateController,
                      readOnly: true,
                      validator: (val) =>
                          val == null || val.isEmpty ? 'Select end date' : null,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _pickTime(isStart: true),
                  child: AbsorbPointer(
                    child: CustomTextFormField(
                      backgroundColor: kCardBackgroundColor,
                      titleWidget: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(text: 'Start Time ', style: kSmallTitleB),
                            TextSpan(
                                text: '*',
                                style: kSmallTitleB.copyWith(color: kRed)),
                          ],
                        ),
                      ),
                      labelText: 'Select Start Time',
                      textController: _startTimeController,
                      readOnly: true,
                      validator: (val) => val == null || val.isEmpty
                          ? 'Select start time'
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _pickTime(isStart: false),
                  child: AbsorbPointer(
                    child: CustomTextFormField(
                      backgroundColor: kCardBackgroundColor,
                      titleWidget: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(text: 'End Time ', style: kSmallTitleB),
                            TextSpan(
                                text: '*',
                                style: kSmallTitleB.copyWith(color: kRed)),
                          ],
                        ),
                      ),
                      labelText: 'Select End Time',
                      textController: _endTimeController,
                      readOnly: true,
                      validator: (val) =>
                          val == null || val.isEmpty ? 'Select end time' : null,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SelectionDropDown(
                  backgroundColor: kCardBackgroundColor,
                  labelWidget: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'Virtual Platform ', style: kSmallTitleB),
                        TextSpan(
                            text: '*',
                            style: kSmallTitleB.copyWith(color: kRed)),
                      ],
                    ),
                  ),
                  value: _platform,
                  hintText: 'Choose the Virtual Platform',
                  items: [
                    DropdownMenuItem(value: 'Zoom', child: Text('Zoom')),
                    DropdownMenuItem(
                        value: 'Google Meet', child: Text('Google Meet')),
                    DropdownMenuItem(value: 'Teams', child: Text('Teams')),
                    DropdownMenuItem(value: 'Other', child: Text('Other')),
                  ],
                  onChanged: (val) => setState(() => _platform = val),
                  validator: (val) =>
                      val == null ? 'Please select platform' : null,
                ),
                CustomTextFormField(
                  backgroundColor: kCardBackgroundColor,
                  title: 'Link',
                  labelText: 'Add Meeting Link here',
                  textController: _linkController,
                  validator: (val) => null,
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  backgroundColor: kCardBackgroundColor,
                  titleWidget: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: 'Venue ', style: kSmallTitleB),
                        TextSpan(
                            text: '*',
                            style: kSmallTitleB.copyWith(color: kRed)),
                      ],
                    ),
                  ),
                  labelText: 'Enter the venue',
                  textController: _venueController,
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Enter venue' : null,
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  backgroundColor: kCardBackgroundColor,
                  titleWidget: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: 'Organiser Name ', style: kSmallTitleB),
                        TextSpan(
                            text: '*',
                            style: kSmallTitleB.copyWith(color: kRed)),
                      ],
                    ),
                  ),
                  labelText: 'Enter the organiser name',
                  textController: _organiserNameController,
                  validator: (val) => val == null || val.isEmpty
                      ? 'Enter organiser name'
                      : null,
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  backgroundColor: kCardBackgroundColor,
                  titleWidget: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: 'Limit ', style: kSmallTitleB),
                        TextSpan(
                            text: '*',
                            style: kSmallTitleB.copyWith(color: kRed)),
                      ],
                    ),
                  ),
                  labelText: 'Enter participant limit',
                  textController: _limitController,
                  textInputType: TextInputType.number,
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Enter limit';
                    final n = int.tryParse(val);
                    if (n == null) return 'Limit must be an integer';
                    if (n <= 0) return 'Limit must be greater than 0';
                    return null;
                  },
                  onChanged: (val) {
                    setState(() {
                      _limit = int.tryParse(val);
                    });
                  },
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _posterVisibilityStartDate ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() {
                        _posterVisibilityStartDate = picked;
                        _posterVisibilityStartDateController.text =
                            _posterVisibilityStartDate!
                                .toLocal()
                                .toString()
                                .split(' ')[0];
                      });
                    }
                  },
                  child: AbsorbPointer(
                    child: CustomTextFormField(
                      backgroundColor: kCardBackgroundColor,
                      titleWidget: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: 'Poster Visibility Start Date ',
                                style: kSmallTitleB),
                            TextSpan(
                                text: '*',
                                style: kSmallTitleB.copyWith(color: kRed)),
                          ],
                        ),
                      ),
                      labelText: 'Select Poster Visibility Start Date',
                      textController: _posterVisibilityStartDateController,
                      readOnly: true,
                      validator: (val) => val == null || val.isEmpty
                          ? 'Select poster visibility start date'
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _posterVisibilityEndDate ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() {
                        _posterVisibilityEndDate = picked;
                        _posterVisibilityEndDateController.text =
                            _posterVisibilityEndDate!
                                .toLocal()
                                .toString()
                                .split(' ')[0];
                      });
                    }
                  },
                  child: AbsorbPointer(
                    child: CustomTextFormField(
                      backgroundColor: kCardBackgroundColor,
                      titleWidget: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: 'Poster Visibility End Date ',
                                style: kSmallTitleB),
                            TextSpan(
                                text: '*',
                                style: kSmallTitleB.copyWith(color: kRed)),
                          ],
                        ),
                      ),
                      labelText: 'Select Poster Visibility End Date',
                      textController: _posterVisibilityEndDateController,
                      readOnly: true,
                      validator: (val) => val == null || val.isEmpty
                          ? 'Select poster visibility end date'
                          : null,
                    ),
                  ),
                ),
                // Coordinator selection field
                const SizedBox(height: 10),
                Text('Coordinators', style: kSmallTitleB),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: _selectedCoordinators
                      .map((user) => Chip(
                            label: Text(user.name ?? ''),
                            onDeleted: () {
                              setState(() {
                                _selectedCoordinators.remove(user);
                              });
                            },
                          ))
                      .toList(),
                ),
                const SizedBox(height: 8),
                customButton(
                  label: 'Select Coordinators',
                  onPressed: () async {
                    final result = await showDialog<List<UserModel>>(
                      context: context,
                      builder: (context) => _CoordinatorSelectDialog(
                        initiallySelected: _selectedCoordinators,
                      ),
                    );
                    if (result != null) {
                      setState(() {
                        _selectedCoordinators = result;
                      });
                    }
                  },
                  buttonColor: kStrokeColor,
                  labelColor: kWhite,
                ),
                // Speaker Section
                const SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: 'Speakers ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: kWhite)),
                      TextSpan(
                          text: '*',
                          style: TextStyle(
                              color: kRed,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                ..._speakers.asMap().entries.map((entry) => ListTile(
                      leading: entry.value['image'] != null
                          ? CircleAvatar(
                              backgroundImage:
                                  NetworkImage(entry.value['image']))
                          : null,
                      title: Text(entry.value['name'] ?? ''),
                      subtitle: Text(entry.value['designation'] ?? ''),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeSpeaker(entry.key),
                      ),
                    )),
                SizedBox(height: 10),
                // Speaker name and designation row
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        backgroundColor: kCardBackgroundColor,
                        titleWidget: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: 'Speaker Name ', style: kSmallTitleB),
                              TextSpan(
                                  text: '*',
                                  style: kSmallTitleB.copyWith(color: kRed)),
                            ],
                          ),
                        ),
                        labelText: 'Enter speaker name',
                        textController: _speakerNameController,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CustomTextFormField(
                        backgroundColor: kCardBackgroundColor,
                        title: 'Designation',
                        labelText: 'Enter designation',
                        textController: _speakerDesignationController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Speaker role row
                CustomTextFormField(
                  backgroundColor: kCardBackgroundColor,
                  title: 'Role',
                  labelText: 'Enter role',
                  textController: _speakerRoleController,
                ),
                const SizedBox(height: 8),
                // Speaker image row
                Row(
                  children: [
                    Text('Image', style: kSmallTitleB),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: _pickSpeakerImage,
                      child: Container(
                        height: 56,
                        width: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                          border: Border.all(
                              color: Colors.grey.shade300, width: 1.2),
                        ),
                        child: _speakerImage == null
                            ? Center(
                                child: Icon(Icons.cloud_upload_outlined,
                                    color: Colors.grey))
                            : ClipOval(
                                child: Image.file(_speakerImage!,
                                    fit: BoxFit.cover, width: 56, height: 56),
                              ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Consumer(builder: (context, ref, child) {
                  final isLoading = ref.watch(loadingProvider);
                  return Container(
                      margin: const EdgeInsets.only(top: 8),
                      child: customButton(
                        label: 'Add Speaker',
                        onPressed: isLoading
                            ? null
                            : () async {
                                if (_speakerNameController.text.isEmpty) {
                                  SnackbarService().showSnackBar(
                                    'Please enter speaker name',
                                    type: SnackbarType.error,
                                  );
                                  return;
                                }
                                ref
                                    .read(loadingProvider.notifier)
                                    .startLoading();
                                String? imageUrl;
                                if (_speakerImage != null) {
                                  imageUrl =
                                      await imageUpload(_speakerImage!.path);
                                }
                                setState(() {
                                  _speakers.add({
                                    'name': _speakerNameController.text,
                                    'designation':
                                        _speakerDesignationController.text,
                                    'role': _speakerRoleController.text,
                                    if (imageUrl != null) 'image': imageUrl,
                                  });
                                  _speakerNameController.clear();
                                  _speakerDesignationController.clear();
                                  _speakerRoleController.clear();
                                  _speakerImage = null;
                                });
                                ref
                                    .read(loadingProvider.notifier)
                                    .stopLoading();
                                SnackbarService().showSnackBar(
                                  'Speaker added',
                                  type: SnackbarType.success,
                                );
                              },
                      ));
                }),
                const SizedBox(height: 20),
                Consumer(
                  builder: (context, ref, child) {
                    final eventApiService = ref.watch(eventsApiServiceProvider);
                    return customButton(
                      label: widget.eventToEdit != null
                          ? 'Update Event'
                          : 'Create Event',
                      isLoading: ref.watch(loadingProvider),
                      onPressed: ref.watch(loadingProvider)
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                ref
                                    .read(loadingProvider.notifier)
                                    .startLoading();
                                final eventName = _eventNameController.text;
                                final description = _descriptionController.text;
                                final eventStartDate = _startDate;
                                final eventEndDate = _endDate;
                                final limit = _limit ??
                                    int.tryParse(_limitController.text) ??
                                    100;
                                final posterVisibilityStartDate =
                                    _posterVisibilityStartDate;
                                final posterVisibilityEndDate =
                                    _posterVisibilityEndDate;
                                final platform = _platform;
                                final link = _linkController.text.isNotEmpty
                                    ? _linkController.text
                                    : null;
                                final venue = _venueController.text.isNotEmpty
                                    ? _venueController.text
                                    : null;
                                final organiserName =
                                    _organiserNameController.text;

                                String image = '';
                                if (_eventImage != null) {
                                  image = await imageUpload(_eventImage!.path);
                                } else if (_existingImageUrl != null) {
                                  image = _existingImageUrl!;
                                }
                                // Validate required fields
                                if (eventName.isEmpty ||
                                    description.isEmpty ||
                                    image.isEmpty ||
                                    eventStartDate == null ||
                                    eventEndDate == null ||
                                    posterVisibilityStartDate == null ||
                                    posterVisibilityEndDate == null ||
                                    organiserName.isEmpty ||
                                    _speakers.isEmpty ||
                                    limit == null) {
                                  SnackbarService().showSnackBar(
                                    'Please fill all required fields and add at least one speaker.',
                                    type: SnackbarType.error,
                                  );
                                  ref
                                      .read(loadingProvider.notifier)
                                      .stopLoading();
                                  return;
                                }
                                try {
                                  EventsModel result;
                                  if (widget.eventToEdit != null) {
                                    // Update existing event
                                    result = await eventApiService.updateEvent(
                                      eventId: widget.eventToEdit!.id!,
                                      eventName: eventName,
                                      description: description,
                                      type: _eventType ?? '',
                                      image: image,
                                      eventStartDate: eventStartDate,
                                      eventEndDate: eventEndDate,
                                      posterVisibilityStartDate:
                                          posterVisibilityStartDate,
                                      posterVisibilityEndDate:
                                          posterVisibilityEndDate,
                                      organiserName: organiserName,
                                      limit: limit,
                                      speakers: _speakers,
                                      platform: platform,
                                      link: link,
                                      venue: venue,
                                      coordinators: _selectedCoordinators
                                          .map((u) => u.id ?? '')
                                          .toList(),
                                    );
                                  } else {
                                    // Create new event
                                    result = await eventApiService.postEvent(
                                      eventName: eventName,
                                      description: description,
                                      type: _eventType ?? '',
                                      image: image,
                                      eventStartDate: eventStartDate,
                                      eventEndDate: eventEndDate,
                                      posterVisibilityStartDate:
                                          posterVisibilityStartDate,
                                      posterVisibilityEndDate:
                                          posterVisibilityEndDate,
                                      organiserName: organiserName,
                                      limit: limit,
                                      speakers: _speakers,
                                      platform: platform,
                                      link: link,
                                      venue: venue,
                                      coordinators: _selectedCoordinators
                                          .map((u) => u.id ?? '')
                                          .toList(),
                                    );
                                  }
                                  if (result.eventName != null) {
                                    SnackbarService().showSnackBar(
                                      widget.eventToEdit != null
                                          ? 'Event Updated successfully'
                                          : 'Event Created successfully and will be reviewed by admin',
                                      type: SnackbarType.success,
                                    );
                                    Navigator.of(context).pop();
                                  }
                                } catch (e) {
                                  SnackbarService().showSnackBar(
                                    'Failed to apply event: ${e.toString()}',
                                    type: SnackbarType.error,
                                  );
                                } finally {
                                  ref
                                      .read(loadingProvider.notifier)
                                      .stopLoading();
                                }
                              }
                            },
                      buttonColor: kPrimaryColor,
                      labelColor: kWhite,
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Coordinator selection dialog
class _CoordinatorSelectDialog extends ConsumerStatefulWidget {
  final List<UserModel> initiallySelected;
  const _CoordinatorSelectDialog({Key? key, required this.initiallySelected})
      : super(key: key);
  @override
  ConsumerState<_CoordinatorSelectDialog> createState() =>
      _CoordinatorSelectDialogState();
}

class _CoordinatorSelectDialogState
    extends ConsumerState<_CoordinatorSelectDialog> {
  List<UserModel> _selected = [];
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _selected = List<UserModel>.from(widget.initiallySelected);
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(membersNotifierProvider.notifier).fetchMoreUsers();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      ref.read(membersNotifierProvider.notifier).fetchMoreUsers();
    }
  }

  void _onSearchChanged(String query) {
    ref.read(membersNotifierProvider.notifier).searchUsers(query);
  }

  @override
  Widget build(BuildContext context) {
    final users = ref.watch(membersNotifierProvider);
    final isLoading = ref.read(membersNotifierProvider.notifier).isLoading;
    return Dialog(
      backgroundColor: kCardBackgroundColor,
      child: SizedBox(
        width: 400,
        height: 500,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Search Members',
                  hintStyle: kSmallTitleL.copyWith(color: kSecondaryTextColor),
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: kWhite,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: users.isEmpty && isLoading
                  ? const Center(child: LoadingAnimation())
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: users.length + (isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index < users.length) {
                          final user = users[index];
                          final isSelected =
                              _selected.any((u) => u.id == user.id);
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: user.image != null
                                  ? NetworkImage(user.image!)
                                  : null,
                              child: user.image == null
                                  ? Icon(Icons.person)
                                  : null,
                            ),
                            title: Text(user.name ?? ''),
                            subtitle: Text(user.email ?? ''),
                            trailing: Checkbox(
                              value: isSelected,
                              onChanged: (val) {
                                setState(() {
                                  if (val == true) {
                                    _selected.add(user);
                                  } else {
                                    _selected
                                        .removeWhere((u) => u.id == user.id);
                                  }
                                });
                              },
                            ),
                          );
                        } else {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: LoadingAnimation()),
                          );
                        }
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(_selected),
                    child: Text('Select'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
