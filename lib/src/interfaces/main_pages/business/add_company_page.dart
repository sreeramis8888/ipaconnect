import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/notifiers/user_companies_notifier.dart';
import 'package:ipaconnect/src/data/utils/globals.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_button.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_round_button.dart';
import 'package:ipaconnect/src/interfaces/components/dropdown/selectionDropdown.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:ipaconnect/src/interfaces/additional_screens/crop_image_screen.dart';

import 'package:ipaconnect/src/data/services/image_upload.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/services/api_routes/company_api/company_api_service.dart';
import 'package:ipaconnect/src/interfaces/components/loading/loading_indicator.dart';
import 'package:ipaconnect/src/data/notifiers/business_category_notifier.dart';
import 'package:ipaconnect/src/data/models/business_category_model.dart';
import 'package:ipaconnect/src/data/models/company_model.dart';

class AddCompanyPage extends ConsumerStatefulWidget {
  final CompanyModel? companyToEdit;
  const AddCompanyPage({Key? key, this.companyToEdit}) : super(key: key);

  @override
  ConsumerState<AddCompanyPage> createState() => _AddCompanyPageState();
}

class _AddCompanyPageState extends ConsumerState<AddCompanyPage> {
  final _formKey = GlobalKey<FormState>();
  String? name;
  String? status = 'active';
  String? overview;
  String? category;
  String? image;
  DateTime? establishedDate;
  String? companySize;
  List<String> services = [];

  // Opening Hours
  String? sunday;
  String? monday;
  String? tuesday;
  String? wednesday;
  String? thursday;
  String? friday;
  String? saturday;

  // Contact Info
  String? address;
  String? phone;
  String? email;
  String? website;

  // Gallery
  List<File> localPhotoFiles = [];
  List<String> galleryPhotoUrls = [];
  List<String> videoUrls = [];

  // Example dropdown items
  final List<DropdownMenuItem<String>> statusItems = [
    DropdownMenuItem(value: 'active', child: Text('Active')),
    DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
  ];

  bool isUploadingImage = false;
  String? imageUploadError;
  File? localImageFile;
  bool isSubmitting = false;
  String? submitError;

  List<String> tags = [];

  @override
  void initState() {
    super.initState();
    // Prefill fields if editing
    final company = widget.companyToEdit;
    if (company != null) {
      name = company.name;
      status = company.status;
      overview = company.overview;
      // Defensive fix for category: map name to ID if needed
      final categories = ref.read(businessCategoryNotifierProvider);
      final found = categories.firstWhere(
        (cat) =>
            cat.id.toString() == company.category ||
            cat.name == company.category,
        orElse: () => BusinessCategoryModel(id: '', name: ''),
      );
      category = (found.id != null && found.id.toString().isNotEmpty)
          ? found.id.toString()
          : company.category;
      image = company.image;
      establishedDate = company.establishedDate;
      companySize = company.companySize;
      services = company.services ?? [];
      tags = company.tags ?? [];
      // Opening Hours
      sunday = company.openingHours?.sunday;
      monday = company.openingHours?.monday;
      tuesday = company.openingHours?.tuesday;
      wednesday = company.openingHours?.wednesday;
      thursday = company.openingHours?.thursday;
      friday = company.openingHours?.friday;
      saturday = company.openingHours?.saturday;
      // Contact Info
      address = company.contactInfo?.address;
      phone = company.contactInfo?.phone;
      email = company.contactInfo?.email;
      website = company.contactInfo?.website;
      // Gallery
      galleryPhotoUrls = company.gallery?.photos
              ?.map((p) => p.url ?? '')
              .where((u) => u.isNotEmpty)
              .toList() ??
          [];
      videoUrls = company.gallery?.videos
              ?.map((v) => v.url ?? '')
              .where((u) => u.isNotEmpty)
              .toList() ??
          [];
    }
    // Fetch initial categories
    Future.microtask(() {
      ref.read(businessCategoryNotifierProvider.notifier).fetchMoreCategories();
    });
  }

  Future<void> pickAndUploadImage() async {
    setState(() {
      isUploadingImage = true;
      imageUploadError = null;
    });
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked == null) {
        setState(() => isUploadingImage = false);
        return;
      }
      final cropResult = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CropImageScreen(imageFile: File(picked.path)),
        ),
      );
      if (cropResult != null && cropResult is Uint8List) {
        final filePath =
            await saveUint8ListToFile(cropResult, 'company_image.jpg');
        localImageFile = File(filePath);
        final url = await imageUpload(filePath);
        setState(() {
          image = url;
          isUploadingImage = false;
        });
      } else {
        setState(() => isUploadingImage = false);
      }
    } catch (e) {
      setState(() {
        imageUploadError = 'Image upload failed';
        isUploadingImage = false;
      });
    }
  }

  Future<void> pickGalleryPhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        localPhotoFiles.add(File(picked.path));
      });
    }
  }

  void removeGalleryPhoto(int index) {
    setState(() {
      localPhotoFiles.removeAt(index);
    });
  }

  final TextEditingController videoController = TextEditingController();

  void addVideoUrl() {
    final url = videoController.text.trim();
    if (url.isNotEmpty && isYouTubeUrl(url)) {
      setState(() {
        videoUrls.add(url);
        videoController.clear();
      });
    }
  }

  void removeVideoUrl(int index) {
    setState(() {
      videoUrls.removeAt(index);
    });
  }

  bool isYouTubeUrl(String url) {
    final youtubeRegex =
        RegExp(r'^(https?://)?(www\.)?(youtube\.com|youtu\.?be)/.+');
    return youtubeRegex.hasMatch(url);
  }

  Future<void> _showCategoryPicker(BuildContext context) async {
    final businessCategoryNotifier =
        ref.read(businessCategoryNotifierProvider.notifier);
    final categories = ref.read(businessCategoryNotifierProvider);
    String? selected = category;

    await showModalBottomSheet(
      backgroundColor: kCardBackgroundColor,
      context: context,
      builder: (context) {
        final scrollController = ScrollController();

        scrollController.addListener(() {
          if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 100) {
            if (businessCategoryNotifier.hasMore &&
                !businessCategoryNotifier.isLoading) {
              businessCategoryNotifier.fetchMoreCategories();
            }
          }
        });

        return SizedBox(
          height: 400,
          child: Column(
            children: [
              Expanded(
                child: Consumer(
                  builder: (context, ref, _) {
                    final categories =
                        ref.watch(businessCategoryNotifierProvider);
                    final notifier =
                        ref.watch(businessCategoryNotifierProvider.notifier);
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: categories.length + (notifier.hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index < categories.length) {
                          final cat = categories[index];
                          return ListTile(
                            title: Text(
                              cat.name,
                              style: kSmallTitleL,
                            ),
                            selected: selected == cat.id?.toString(),
                            onTap: () {
                              setState(() => category = cat.id?.toString());
                              Navigator.pop(context);
                            },
                          );
                        } else {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: LoadingAnimation()),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final businessCategoryNotifier =
        ref.watch(businessCategoryNotifierProvider.notifier);
    final categories = ref.watch(businessCategoryNotifierProvider);
    final hasMore = businessCategoryNotifier.hasMore;
    final isLoading = businessCategoryNotifier.isLoading;

    List<DropdownMenuItem<String>> categoryItems = [
      ...categories.map((cat) => DropdownMenuItem(
            value: cat.id?.toString() ?? cat.name,
            child: Text(cat.name),
          )),
      if (hasMore || isLoading)
        DropdownMenuItem(
          value: '__load_more__',
          enabled: !isLoading,
          child: isLoading
              ? Row(
                  children: [
                    SizedBox(width: 16, height: 16, child: LoadingAnimation()),
                    SizedBox(width: 8),
                    Text('Loading...'),
                  ],
                )
              : Text('Load more...'),
        ),
    ];

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
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
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('Add Business', style: kSmallTitleB),
          iconTheme: const IconThemeData(color: kWhite),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Company Name', style: kSmallTitleM),
                    Text(' *', style: kSmallTitleM.copyWith(color: Colors.red)),
                  ],
                ),
                const SizedBox(height: 8),
                TextFormField(
                  style: kSmallTitleL,
                  initialValue: name,
                  decoration: InputDecoration(
                    hintStyle:
                        kSmallTitleL.copyWith(color: kSecondaryTextColor),
                    hintText: 'Enter company name',
                    filled: true,
                    fillColor: kCardBackgroundColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (val) => setState(() => name = val),
                  validator: (val) => val == null || val.isEmpty ? '' : null,
                ),
                const SizedBox(height: 16),
                Text('Company Image', style: kSmallTitleM),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: isUploadingImage ? null : pickAndUploadImage,
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: kCardBackgroundColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: isUploadingImage
                          ? const LoadingAnimation()
                          : image != null
                              ? Image.network(image!, height: 100)
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_a_photo,
                                        color: kPrimaryColor, size: 32),
                                    const SizedBox(height: 8),
                                    Text('Upload Image', style: kSmallTitleL),
                                  ],
                                ),
                    ),
                  ),
                ),
                if (imageUploadError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(imageUploadError!,
                        style: TextStyle(color: Colors.red)),
                  ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text('Overview', style: kSmallTitleM),
                    Text(' *', style: kSmallTitleM.copyWith(color: Colors.red)),
                  ],
                ),
                const SizedBox(height: 8),
                TextFormField(
                  style: kSmallTitleL,
                  initialValue: overview,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintStyle:
                        kSmallTitleL.copyWith(color: kSecondaryTextColor),
                    hintText: 'Overview',
                    filled: true,
                    fillColor: kCardBackgroundColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (val) => setState(() => overview = val),
                  validator: (val) => val == null || val.isEmpty ? '' : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text('Category', style: kSmallTitleM),
                    Text(' *', style: kSmallTitleM.copyWith(color: Colors.red)),
                  ],
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _showCategoryPicker(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 12),
                    decoration: BoxDecoration(
                      color: kCardBackgroundColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Builder(
                      builder: (context) {
                        final categories =
                            ref.watch(businessCategoryNotifierProvider);
                        if (categories.isEmpty &&
                            category != null &&
                            category!.isNotEmpty) {
                          return Text('Loading...', style: kSmallTitleL);
                        }
                        final found = categories.firstWhere(
                          (cat) => cat.id.toString() == category,
                          orElse: () => BusinessCategoryModel(id: '', name: ''),
                        );
                        return Text(
                          found.name.isNotEmpty
                              ? found.name
                              : (category ?? 'Select category'),
                          style: kSmallTitleL,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Company Size', style: kSmallTitleM),
                const SizedBox(height: 8),
                TextFormField(
                  style: kSmallTitleL,
                  initialValue: companySize,
                  decoration: InputDecoration(
                    hintStyle:
                        kSmallTitleL.copyWith(color: kSecondaryTextColor),
                    hintText: 'Company Size',
                    filled: true,
                    fillColor: kCardBackgroundColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (val) => setState(() => companySize = val),
                ),
                const SizedBox(height: 16),

                const SizedBox(height: 16),
                Row(
                  children: [
                    Text('Services (comma separated)', style: kSmallTitleM),
                    Text(' *', style: kSmallTitleM.copyWith(color: Colors.red)),
                  ],
                ),
                const SizedBox(height: 8),
                TextFormField(
                  style: kSmallTitleL,
                  initialValue:
                      services.isNotEmpty ? services.join(', ') : null,
                  decoration: InputDecoration(
                    hintText: 'e.g. Consulting, Design',
                    filled: true,
                    fillColor: kCardBackgroundColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (val) => setState(() =>
                      services = val.split(',').map((e) => e.trim()).toList()),
                  validator: (val) {
                    if (val == null || val.isEmpty) return '';
                    final serviceList =
                        val.split(',').map((e) => e.trim()).toList();
                    if (serviceList.isEmpty ||
                        (serviceList.length == 1 && serviceList[0].isEmpty)) {
                      return '';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Text('Established Date', style: kSmallTitleM),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: establishedDate ?? DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() => establishedDate = picked);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 12),
                    decoration: BoxDecoration(
                      color: kCardBackgroundColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      establishedDate != null
                          ? '${establishedDate!.toLocal()}'.split(' ')[0]
                          : 'Select Date',
                      style: kSmallTitleL,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                Text('Opening Hours', style: kSmallTitleM),
                const SizedBox(height: 8),
                TextFormField(
                  style: kSmallTitleL,
                  initialValue: sunday,
                  decoration: InputDecoration(
                      hintText: 'Sunday',
                      filled: true,
                      fillColor: kCardBackgroundColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      )),
                  onChanged: (val) => setState(() => sunday = val),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  style: kSmallTitleL,
                  initialValue: monday,
                  decoration: InputDecoration(
                      hintText: 'Monday',
                      filled: true,
                      fillColor: kCardBackgroundColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      )),
                  onChanged: (val) => setState(() => monday = val),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  style: kSmallTitleL,
                  initialValue: tuesday,
                  decoration: InputDecoration(
                      hintText: 'Tuesday',
                      filled: true,
                      fillColor: kCardBackgroundColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      )),
                  onChanged: (val) => setState(() => tuesday = val),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  style: kSmallTitleL,
                  initialValue: wednesday,
                  decoration: InputDecoration(
                      hintText: 'Wednesday',
                      filled: true,
                      fillColor: kCardBackgroundColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      )),
                  onChanged: (val) => setState(() => wednesday = val),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  style: kSmallTitleL,
                  initialValue: thursday,
                  decoration: InputDecoration(
                      hintText: 'Thursday',
                      filled: true,
                      fillColor: kCardBackgroundColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      )),
                  onChanged: (val) => setState(() => thursday = val),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  style: kSmallTitleL,
                  initialValue: friday,
                  decoration: InputDecoration(
                      hintText: 'Friday',
                      filled: true,
                      fillColor: kCardBackgroundColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      )),
                  onChanged: (val) => setState(() => friday = val),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  style: kSmallTitleL,
                  initialValue: saturday,
                  decoration: InputDecoration(
                      hintText: 'Saturday',
                      filled: true,
                      fillColor: kCardBackgroundColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      )),
                  onChanged: (val) => setState(() => saturday = val),
                ),
                const SizedBox(height: 24),
                Text('Contact Info', style: kSmallTitleM),
                const SizedBox(height: 8),
                TextFormField(
                  style: kSmallTitleL,
                  initialValue: address,
                  decoration: InputDecoration(
                      hintText: 'Address',
                      filled: true,
                      fillColor: kCardBackgroundColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      )),
                  onChanged: (val) => setState(() => address = val),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  style: kSmallTitleL,
                  initialValue: phone,
                  decoration: InputDecoration(
                      hintText: 'Phone',
                      filled: true,
                      fillColor: kCardBackgroundColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      )),
                  onChanged: (val) => setState(() => phone = val),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  style: kSmallTitleL,
                  initialValue: email,
                  decoration: InputDecoration(
                      hintText: 'Email',
                      filled: true,
                      fillColor: kCardBackgroundColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      )),
                  onChanged: (val) => setState(() => email = val),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  style: kSmallTitleL,
                  initialValue: website,
                  decoration: InputDecoration(
                      hintText: 'Website',
                      filled: true,
                      fillColor: kCardBackgroundColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      )),
                  onChanged: (val) => setState(() => website = val),
                ),
                const SizedBox(height: 24),
                Text('Gallery', style: kSmallTitleM),
                const SizedBox(height: 8),
                Text(
                  'Add Image',
                  style: kSmallerTitleR,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    // Show remote gallery images
                    ...List.generate(galleryPhotoUrls.length, (index) {
                      return Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: NetworkImage(galleryPhotoUrls[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                galleryPhotoUrls.removeAt(index);
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close,
                                  color: kWhite, size: 18),
                            ),
                          ),
                        ],
                      );
                    }),
                    // Show local gallery images
                    ...List.generate(localPhotoFiles.length, (index) {
                      return Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: FileImage(localPhotoFiles[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => removeGalleryPhoto(index),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close,
                                  color: kWhite, size: 18),
                            ),
                          ),
                        ],
                      );
                    }),
                    // Add image button
                    Column(
                      children: [
                        Tooltip(
                          message: 'Add Image',
                          child: GestureDetector(
                            onTap: pickGalleryPhoto,
                            child: Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: kCardBackgroundColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: kPrimaryColor),
                              ),
                              child: const Icon(Icons.add,
                                  color: kPrimaryColor, size: 32),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                // Videos section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: videoController,
                            style: kSmallTitleL,
                            decoration: InputDecoration(
                              hintText: 'YouTube Video URL',
                              filled: true,
                              fillColor: kCardBackgroundColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: addVideoUrl,
                          child: const Icon(
                            Icons.add,
                            color: kPrimaryColor,
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(12),
                            backgroundColor: kCardBackgroundColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...List.generate(videoUrls.length, (index) {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(videoUrls[index], style: kSmallTitleL),
                        trailing: IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () => removeVideoUrl(index),
                        ),
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 24),
                customButton(
                  label: isSubmitting
                      ? 'Submitting...'
                      : (widget.companyToEdit != null ? 'Update' : 'Submit'),
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          // Validate mandatory fields
                          bool isValid = true;
                          String? validationError;

                          if (name == null || name!.isEmpty) {
                            validationError = 'Company name is required';
                            isValid = false;
                          } else if (overview == null || overview!.isEmpty) {
                            validationError = 'Overview is required';
                            isValid = false;
                          } else if (category == null || category!.isEmpty) {
                            validationError = 'Category is required';
                            isValid = false;
                          } else if (services.isEmpty) {
                            validationError = 'Services are required';
                            isValid = false;
                          }

                          if (!isValid) {
                            setState(() {
                              submitError = validationError;
                            });
                            return;
                          }

                          if (_formKey.currentState?.validate() ?? false) {
                            setState(() {
                              isSubmitting = true;
                              submitError = null;
                            });
                            try {
                              final newGalleryPhotoUrls =
                                  List<String>.from(galleryPhotoUrls);
                              for (final file in localPhotoFiles) {
                                final url = await imageUpload(file.path);
                                newGalleryPhotoUrls.add(url);
                              }
                              galleryPhotoUrls = newGalleryPhotoUrls;
                              localPhotoFiles
                                  .clear(); // Clear after successful upload

                              // Always resolve category to ID
                              final found = categories.firstWhere(
                                (cat) =>
                                    cat.id.toString() == category ||
                                    cat.name == category,
                                orElse: () =>
                                    BusinessCategoryModel(id: '', name: ''),
                              );
                              final categoryId = (found.id != null &&
                                      found.id.toString().isNotEmpty)
                                  ? found.id.toString()
                                  : null;
                              if (categoryId == null || categoryId.isEmpty) {
                                setState(() {
                                  isSubmitting = false;
                                  submitError =
                                      'Please select a valid category.';
                                });
                                return;
                              }

                              final companyData = {
                                'name': name,
                                'overview': overview,
                                'category': categoryId, // Always pass ID
                                'image': image,
                                'status': status,
                                'established_date':
                                    establishedDate?.toIso8601String(),
                                'company_size': companySize,
                                'services': services,
                                'tags': tags,
                                'opening_hours': {
                                  'sunday': sunday,
                                  'monday': monday,
                                  'tuesday': tuesday,
                                  'wednesday': wednesday,
                                  'thursday': thursday,
                                  'friday': friday,
                                  'saturday': saturday,
                                },
                                'contact_info': {
                                  'address': address,
                                  'phone': phone,
                                  'email': email,
                                  'website': website,
                                },
                                'gallery': {
                                  'photos': galleryPhotoUrls
                                      .map((url) => {'url': url})
                                      .toList(),
                                  'videos': videoUrls
                                      .map((url) => {'url': url})
                                      .toList(),
                                },
                              };
                              final container =
                                  ProviderScope.containerOf(context);
                              final companyApi =
                                  container.read(companyApiServiceProvider);
                              bool result;
                              if (widget.companyToEdit != null &&
                                  widget.companyToEdit!.id != null) {
                                result = await companyApi.updateCompany(
                                    widget.companyToEdit!.id!, companyData);
                              } else {
                                result =
                                    await companyApi.createCompany(companyData);
                              }
                              if (result != false) {
                                if (mounted) {
                                  Navigator.of(context).pop(result);
                                  ref.invalidate(getCompaniesByUserIdProvider);
                                }
                              } else {
                                setState(() => submitError =
                                    widget.companyToEdit != null
                                        ? 'Failed to update company.'
                                        : 'Failed to create company.');
                              }
                            } catch (e) {
                              setState(() => submitError = 'Error: $e');
                            } finally {
                              setState(() => isSubmitting = false);
                            }
                          }
                        },
                ),
                if (submitError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child:
                        Text(submitError!, style: TextStyle(color: Colors.red)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
