import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/services/api_routes/analytics_api/analytics_api.dart';
import 'package:ipaconnect/src/data/services/api_routes/hierarchy/hierarchy_api_service.dart';
import 'package:ipaconnect/src/data/services/snackbar_service.dart';
import 'package:ipaconnect/src/data/utils/globals.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_button.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_round_button.dart';
import 'package:ipaconnect/src/interfaces/components/dropdown/selectionDropdown.dart';
import 'package:ipaconnect/src/interfaces/components/loading/loading_indicator.dart';
import 'package:ipaconnect/src/interfaces/components/textFormFields/custom_text_form_field.dart';
import 'package:ipaconnect/src/interfaces/components/dropdown/paginated_dropdown.dart';
import 'package:ipaconnect/src/data/notifiers/hierarchyUsers_notifier.dart';
import 'package:ipaconnect/src/data/models/user_model.dart';

class SendAnalyticRequestPage extends ConsumerStatefulWidget {
  @override
  _SendAnalyticRequestPageState createState() =>
      _SendAnalyticRequestPageState();
}

class _SendAnalyticRequestPageState
    extends ConsumerState<SendAnalyticRequestPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController referralName = TextEditingController();

  TextEditingController referralNameController = TextEditingController();
  TextEditingController referralEmailController = TextEditingController();

  TextEditingController referralAddressController = TextEditingController();
  TextEditingController referralInfoController = TextEditingController();
  TextEditingController referralPhoneController = TextEditingController();

  String? selectedRequestType;
  String? selectedHierarchyId;

  String? selectedMemberId;

  // String? selectedMeetingType;
  Future<String?> createAnalytic(String countryCode) async {
    final Map<String, dynamic> analytictData = {
      "type": selectedRequestType,
      "receiver": selectedMemberId,
      "sender": id,
      if (amountController.text != '')
        "amount": int.parse(amountController.text),
      "title": titleController.text,
      "description": descriptionController.text,
      if (selectedRequestType == 'Referral')
        "referral": {
          if (referralNameController.text != '')
            "name": referralNameController.text,
          if (referralEmailController.text != '')
            "email": referralEmailController.text,
          if (referralPhoneController.text != '')
            "phone": '+$countryCode${referralPhoneController.text}',
          if (referralAddressController.text != '')
            "address": referralAddressController.text,
          if (referralInfoController.text != '')
            "info": referralInfoController.text,
        },
      // if (dateController.text != '') "date": dateController.text,
      // if (timeController.text != '') "time": timeController.text,
      // if (selectedMeetingType == 'Online' && linkController.text != '')
      //   "meetingLink": linkController.text,
      // if (selectedMeetingType == 'Offline' && locationController.text != '')
      //   "location": locationController.text,
    };
    log(analytictData.toString(), name: "analytic to be created:");
    final analyticApiService = ref.watch(analyticsApiServiceProvider);
    String? response =
        await analyticApiService.postAnalytic(data: analytictData);
    return response;
  }

  // void onChecked() {
  //   print('Checkbox is checked!');
  //   setState(() {
  //     isReferral = true;
  //   });
  // }

  // void onUnchecked() {
  //   setState(() {
  //     isReferral = false;
  //     selectedRefferalDistrict = null;
  //     selectedRefferalStateId = null;
  //     selectedRefferalChapter = null;
  //     selectedRefferalZone = null;
  //     selectedRefferalMember = null;
  //   });
  //   print('Checkbox is unchecked!');
  // }

  Widget _buildRequiredLabel(String label) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: label, style: kSmallTitleB),
          const TextSpan(
            text: ' *',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  final countryCodeProvider = StateProvider<String?>((ref) => '91');

  @override
  Widget build(BuildContext context) {
    final analyticsApiService = ref.watch(analyticsApiServiceProvider);
    final countryCode = ref.watch(countryCodeProvider);
    final asyncHierarchies = ref.watch(getHierarchyProvider);
    final hierarchyUsersNotifier =
        ref.watch(hierarchyusersNotifierProvider.notifier);
    final hierarchyUsers = ref.watch(hierarchyusersNotifierProvider);
    final isLoadingUsers = hierarchyUsersNotifier.isLoading;
    final hasMoreUsers = hierarchyUsersNotifier.hasMore;
    // final asyncReferralZones = ref
    //     .watch(fetchLevelDataProvider(selectedRefferalStateId ?? '', 'state'));
    // final asyncReferralDistricts =
    //     ref.watch(fetchLevelDataProvider(selectedRefferalZone ?? '', 'zone'));
    // final asyncReferralChapters = ref.watch(
    //     fetchLevelDataProvider(selectedRefferalDistrict ?? '', 'district'));
    // final asyncReferralMembers = ref
    //     .watch(fetchLevelDataProvider(selectedRefferalChapter ?? '', 'user'));
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
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
          backgroundColor: kBackgroundColor,
          centerTitle: true,
          title: const Text(
            "Send Request",
            style: TextStyle(
                fontWeight: FontWeight.w500, fontSize: 14, color: kWhite),
          ),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRequiredLabel('Request Type'),
                SizedBox(
                  height: 10,
                ),
                SelectionDropDown(
                  backgroundColor: kCardBackgroundColor,
                  hintText: 'Choose Type',
                  value: selectedRequestType,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a request type';
                    }
                    return null;
                  },
                  items: ['Business', 'Referral']
                      .map((reqType) => DropdownMenuItem(
                            value: reqType,
                            child: Text(reqType),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedRequestType = value;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                _buildRequiredLabel('Heirarchy'),
                SizedBox(
                  height: 10,
                ),
                asyncHierarchies.when(
                  data: (hierarchies) => SelectionDropDown(
                    backgroundColor: kCardBackgroundColor,
                    hintText: 'Choose Cluster',
                    value: selectedHierarchyId,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a hierarchy';
                      }
                      return null;
                    },
                    label: null,
                    items: hierarchies.map((state) {
                      return DropdownMenuItem<String>(
                        value: state.id,
                        child: Text(state.name ?? ''),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedHierarchyId = value;
                        selectedMemberId = null;
                      });
                      if (value != null && value.isNotEmpty) {
                        hierarchyUsersNotifier.refreshHierarchyUsers(
                            hierarchyId: value);
                      }
                    },
                  ),
                  loading: () => const Center(child: LoadingAnimation()),
                  error: (error, stackTrace) => const SizedBox(),
                ),
                if (selectedHierarchyId != null &&
                    selectedHierarchyId!.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRequiredLabel('Member'),
                      SizedBox(
                        height: 10,
                      ),
                      PaginatedDropdown<UserModel>(
                        items: hierarchyUsers,
                        value: hierarchyUsers.cast<UserModel?>().firstWhere(
                              (u) => u?.id == selectedMemberId,
                              orElse: () => null,
                            ),
                        onChanged: (user) {
                          setState(() {
                            selectedMemberId = user?.id;
                          });
                        },
                        isLoading: isLoadingUsers,
                        hasMore: hasMoreUsers,
                        onScrolledToEnd: () {
                          if (selectedHierarchyId != null) {
                            hierarchyUsersNotifier.fetchMoreHierarchyUsers(
                                hierarchyId: selectedHierarchyId!);
                          }
                        },
                        hintText: 'Select Member',
                        validator: (user) {
                          if (user == null) {
                            return 'Please select a member';
                          }
                          return null;
                        },
                        backgroundColor: kCardBackgroundColor,
                        itemBuilder: (context, user, isSelected) {
                          if (user == null) return const SizedBox();
                          return Container(
                            color: isSelected
                                ? kPrimaryColor.withOpacity(0.1)
                                : Colors.transparent,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            child: Text(
                              user.name ?? '',
                              style: kSmallTitleL.copyWith(
                                color: isSelected ? kPrimaryColor : kWhite,
                              ),
                            ),
                          );
                        },
                        getItemLabel: (user) => user.name ?? '',
                      ),
                    ],
                  ),
                const SizedBox(height: 10.0),
                _buildRequiredLabel('Title'),
                CustomTextFormField(
                  backgroundColor: kCardBackgroundColor,
                  textController: titleController,
                  labelText: 'Eg - Construction related',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                if (selectedRequestType == 'Business' ||
                    selectedRequestType == 'Referral')
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10.0),
                      if (selectedRequestType != 'Referral')
                        _buildRequiredLabel('Amount'),
                      if (selectedRequestType != 'Referral')
                        CustomTextFormField(
                          backgroundColor: kCardBackgroundColor,
                          textInputType: TextInputType.numberWithOptions(),
                          textController: amountController,
                          labelText: 'Eg - 50000',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an amount';
                            }
                            return null;
                          },
                        ),
                    ],
                  ),
                if (selectedRequestType != 'Referral')
                  const SizedBox(height: 10.0),
                Text(
                  'Description',
                  style: kSmallTitleB,
                ),
                CustomTextFormField(
                  backgroundColor: kCardBackgroundColor,
                  textController: descriptionController,
                  labelText: 'Eg - Business closed for purchase of materials',
                  maxLines: 4,
                ),
                // SizedBox(
                //   height: 10,
                // ),
                // if (selectedRequestType == 'Business')
                //   _buildRequiredLabel('Date'),
                // if (selectedRequestType == 'Business')
                //   const SizedBox(height: 10.0),
                // if (selectedRequestType == 'Business')
                //   TextFormField(
                //     controller: dateController,
                //     readOnly: true,
                //     validator: (value) {
                //       if (value == null || value.isEmpty) {
                //         return 'Please select a date';
                //       }
                //       return null;
                //     },
                //     decoration: InputDecoration(
                //       labelStyle: const TextStyle(color: Colors.grey),
                //       floatingLabelBehavior: FloatingLabelBehavior.never,
                //       fillColor: kCardBackgroundColor,
                //       filled: true,
                //       enabledBorder: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(8.0),
                //         borderSide:
                //             const BorderSide(color: kCardBackgroundColor),
                //       ),
                //       focusedBorder: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(8.0),
                //         borderSide:
                //             const BorderSide(color: kCardBackgroundColor),
                //       ),
                //       errorBorder: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(8.0),
                //         borderSide:
                //             const BorderSide(color: kCardBackgroundColor),
                //       ),
                //       focusedErrorBorder: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(8.0),
                //         borderSide:
                //             const BorderSide(color: kCardBackgroundColor),
                //       ),
                //       labelText: 'Date',
                //       suffixIcon: IconButton(
                //         icon: const Icon(Icons.calendar_today),
                //         onPressed: () async {
                //           DateTime? pickedDate = await showDatePicker(
                //             context: context,
                //             initialDate: DateTime.now(),
                //             firstDate: DateTime(2025),
                //             lastDate: DateTime(2101),
                //           );
                //           if (pickedDate != null) {
                //             setState(() {
                //               dateController.text =
                //                   DateFormat('yyyy-MM-dd').format(pickedDate);
                //             });
                //           }
                //         },
                //       ),
                //     ),
                //   ),
                const SizedBox(height: 20.0),
                if (selectedRequestType == 'Referral')
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16.0),
                      Text('Referral Details', style: kBodyTitleB),
                      const SizedBox(height: 10.0),
                      _buildRequiredLabel('Name'),
                      CustomTextFormField(
                        backgroundColor: kCardBackgroundColor,
                        textController: referralNameController,
                        labelText: 'Enter referral name',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter referral name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10.0),
                      const Text('Email',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      CustomTextFormField(
                        backgroundColor: kCardBackgroundColor,
                        textController: referralEmailController,
                        labelText: 'Enter referral email',
                      ),
                      const SizedBox(height: 10.0),
                      _buildRequiredLabel('Phone'),
                      const SizedBox(height: 10.0),
                      Container(
                        width: double.infinity, // Full width container
                        child: IntlPhoneField(
                          dropdownIcon: Icon(
                            Icons.arrow_drop_down_outlined,
                            color: kWhite,
                          ),
                          dropdownIconPosition: IconPosition.trailing,
                          dropdownTextStyle: const TextStyle(
                            color: kWhite,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                          cursorColor: kWhite,
                          validator: (phone) {
                            if (phone == null || phone.number.isEmpty) {
                              return 'Please enter a phone number';
                            }
                            if (phone.number.length != 10) {
                              return 'Phone number must be 10 digits';
                            }
                            return null;
                          },
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          controller: referralPhoneController,
                          disableLengthCheck: true,
                          showCountryFlag: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: kCardBackgroundColor,
                            hintText: 'Enter referral phone number',
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide:
                                  BorderSide(color: kCardBackgroundColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide:
                                  BorderSide(color: kCardBackgroundColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide:
                                  const BorderSide(color: kCardBackgroundColor),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide:
                                  const BorderSide(color: kCardBackgroundColor),
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
                          initialCountryCode: 'IN',
                          onChanged: (PhoneNumber phone) {
                            print(phone.completeNumber);
                          },
                          flagsButtonPadding: const EdgeInsets.only(left: 10),
                          showDropdownIcon: true,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Text('Address', style: kSmallTitleB),
                      CustomTextFormField(
                        backgroundColor: kCardBackgroundColor,
                        textController: referralAddressController,
                        labelText: 'Enter referral address',
                        maxLines: 2,
                      ),
                      const SizedBox(height: 10.0),
                      Text('Additional Information', style: kSmallTitleB),
                      CustomTextFormField(
                        backgroundColor: kCardBackgroundColor,
                        textController: referralInfoController,
                        labelText:
                            'eg: I have a reference for you, Name, Number, purpose',
                        maxLines: 3,
                      ),
                    ],
                  ),
                const SizedBox(height: 20.0),
                customButton(
                  label: 'Send Request',
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      String? response =
                          await createAnalytic(countryCode ?? '91');
                      if (response != null && response.contains('success')) {
                        Navigator.pop(context);
                        ref.invalidate(fetchAnalyticsProvider);
                      } else {
                        SnackbarService service = SnackbarService();

                        service.showSnackBar(response ?? 'Error');
                      }
                      print('Form Submitted');
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
