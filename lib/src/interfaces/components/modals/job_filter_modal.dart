import 'package:flutter/material.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_button.dart';
import 'package:ipaconnect/src/interfaces/components/textFormFields/custom_text_form_field.dart';
import 'package:ipaconnect/src/interfaces/components/dropdown/selectionDropdown.dart';

class JobFilterModal extends StatefulWidget {
  const JobFilterModal({Key? key}) : super(key: key);

  @override
  State<JobFilterModal> createState() => _JobFilterModalState();
}

class _JobFilterModalState extends State<JobFilterModal> {
  String? selectedCategory;
  String? selectedExperience;
  String? selectedNoticePeriod;
  String? selectedLocation;
  DateTime? uploadedStartDate;
  DateTime? uploadedEndDate;

  final List<String> categories = [
    'IT',
    'Finance',
    'Marketing',
    'HR',
    'Design',
    'Other'
  ];
  final List<String> experiences = [
    'Fresher',
    '1-2 years',
    '3-5 years',
    '5+ years'
  ];
  final List<String> noticePeriods = [
    'Immediate',
    '15 days',
    '1 month',
    '2 months'
  ];
  final List<String> locations = [
    'Remote',
    'Bangalore',
    'Mumbai',
    'Delhi',
    'Other'
  ];

  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 1),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: kPrimaryColor,
              onPrimary: kWhite,
              surface: kCardBackgroundColor,
              onSurface: kWhite,
            ),
            dialogBackgroundColor: kBackgroundColor,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          uploadedStartDate = picked;
        } else {
          uploadedEndDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: kBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Filter', style: kHeadTitleSB),
            const SizedBox(height: 18),
            SelectionDropDown(
              backgroundColor: kStrokeColor,
              label: 'Category',
              hintText: 'Select',
              value: selectedCategory,
              items: categories
                  .map((e) => DropdownMenuItem<String>(
                      value: e, child: Text(e, style: kBodyTitleR)))
                  .toList(),
              onChanged: (val) => setState(() => selectedCategory = val),
            ),
            SelectionDropDown(
              backgroundColor: kStrokeColor,
              label: 'Experience',
              hintText: 'Select',
              value: selectedExperience,
              items: experiences
                  .map((e) => DropdownMenuItem<String>(
                      value: e, child: Text(e, style: kBodyTitleR)))
                  .toList(),
              onChanged: (val) => setState(() => selectedExperience = val),
            ),
            SelectionDropDown(
              backgroundColor: kStrokeColor,
              label: 'Notice Period',
              hintText: 'Select',
              value: selectedNoticePeriod,
              items: noticePeriods
                  .map((e) => DropdownMenuItem<String>(
                      value: e, child: Text(e, style: kBodyTitleR)))
                  .toList(),
              onChanged: (val) => setState(() => selectedNoticePeriod = val),
            ),
            SelectionDropDown(
              backgroundColor: kStrokeColor,
              label: 'Location',
              hintText: 'Select',
              value: selectedLocation,
              items: locations
                  .map((e) => DropdownMenuItem<String>(
                      value: e, child: Text(e, style: kBodyTitleR)))
                  .toList(),
              onChanged: (val) => setState(() => selectedLocation = val),
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Uploaded Start Date', style: kSmallTitleM),
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: () => _pickDate(isStart: true),
                        child: AbsorbPointer(
                          child: ModalSheetTextFormField(
                            textController: TextEditingController(
                              text: uploadedStartDate == null
                                  ? ''
                                  : '${uploadedStartDate!.year}-${uploadedStartDate!.month.toString().padLeft(2, '0')}-${uploadedStartDate!.day.toString().padLeft(2, '0')}',
                            ),
                            label: 'Date',
                            validator: null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Uploaded End Date', style: kSmallTitleM),
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: () => _pickDate(isStart: false),
                        child: AbsorbPointer(
                          child: ModalSheetTextFormField(
                            textController: TextEditingController(
                              text: uploadedEndDate == null
                                  ? ''
                                  : '${uploadedEndDate!.year}-${uploadedEndDate!.month.toString().padLeft(2, '0')}-${uploadedEndDate!.day.toString().padLeft(2, '0')}',
                            ),
                            label: 'Date',
                            validator: null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            customButton(
              label: 'Apply',
              onPressed: () {
                Navigator.of(context).pop({
                  'category': selectedCategory,
                  'experience': selectedExperience,
                  'noticePeriod': selectedNoticePeriod,
                  'location': selectedLocation,
                  'uploadedStartDate': uploadedStartDate,
                  'uploadedEndDate': uploadedEndDate,
                });
              },
              fontSize: 16,
              buttonHeight: 48,
            ),
          ],
        ),
      ),
    );
  }
}
