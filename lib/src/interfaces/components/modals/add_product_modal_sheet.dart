import 'package:flutter/material.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/notifiers/products_notifier.dart';
import 'package:ipaconnect/src/data/services/snackbar_service.dart';
import 'package:ipaconnect/src/data/utils/globals.dart' as globals;
import 'package:ipaconnect/src/interfaces/components/buttons/custom_button.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_round_button.dart';
import 'package:ipaconnect/src/interfaces/components/dropdown/selectionDropdown.dart';
import 'package:ipaconnect/src/interfaces/components/textFormFields/custom_text_form_field.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:ipaconnect/src/interfaces/additional_screens/crop_image_screen.dart';
import 'package:ipaconnect/src/data/services/image_upload.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/notifiers/user_notifier.dart';
import 'package:ipaconnect/src/data/services/api_routes/products_api/products_api_service.dart';

class AddProductModalSheet extends ConsumerStatefulWidget {
  final List<String> categories;
  final String companyId;
  const AddProductModalSheet(
      {Key? key, required this.categories, required this.companyId})
      : super(key: key);

  @override
  ConsumerState<AddProductModalSheet> createState() =>
      _AddProductModalSheetState();
}

class _AddProductModalSheetState extends ConsumerState<AddProductModalSheet> {
  String? selectedCategory;
  List<String> imagePaths = [];
  List<Uint8List> imageBytesList = [];
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final sellerNameController = TextEditingController();
  final actualPriceController = TextEditingController();
  final offerPriceController = TextEditingController();
  final List<TextEditingController> specificationControllers = [
    TextEditingController()
  ];
  bool showOnPublicProfile = true;
  bool isUploading = false;

  Future<void> _pickAndCropImage() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles == null || pickedFiles.isEmpty) return;
    for (final pickedFile in pickedFiles) {
      final File pickedImageFile = File(pickedFile.path);
      final croppedBytes = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CropImageScreen(imageFile: pickedImageFile),
        ),
      );
      if (croppedBytes != null && croppedBytes is Uint8List) {
        final fileName =
            'cropped_${DateTime.now().millisecondsSinceEpoch}${path.extension(pickedFile.path)}';
        final localPath = await saveUint8ListToFile(croppedBytes, fileName);
        setState(() {
          imagePaths.add(localPath);
          imageBytesList.add(croppedBytes);
        });
      }
    }
  }

  Future<List<String>> _uploadImagesIfNeeded() async {
    List<String> urls = [];
    if (imagePaths.isEmpty) return urls;
    setState(() {
      isUploading = true;
    });
    try {
      for (final path in imagePaths) {
        final url = await imageUpload(path);
        if (url != null) {
          urls.add(url);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image upload failed')),
      );
    }
    setState(() {
      isUploading = false;
    });
    return urls;
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    sellerNameController.dispose();
    actualPriceController.dispose();
    offerPriceController.dispose();
    for (final c in specificationControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _addSpecificationField() {
    setState(() {
      specificationControllers.add(TextEditingController());
    });
  }

  void _removeSpecificationField(int index) {
    if (specificationControllers.length > 1) {
      setState(() {
        specificationControllers.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: kBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: CustomRoundButton(
                      offset: Offset(4, 0),
                      iconPath: 'assets/svg/icons/arrow_back_ios.svg',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('Add Product', style: kSmallTitleR),
                ],
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _pickAndCropImage,
                child: Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: kCardBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: imageBytesList.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add,
                                color: kSecondaryTextColor, size: 32),
                            const SizedBox(height: 4),
                            Text('Upload Images', style: kSmallTitleR),
                          ],
                        )
                      : ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: imageBytesList.length,
                          separatorBuilder: (_, __) => SizedBox(width: 8),
                          itemBuilder: (context, index) => Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.memory(
                                  imageBytesList[index],
                                  fit: BoxFit.cover,
                                  width: 100,
                                  height: 100,
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      imageBytesList.removeAt(index);
                                      imagePaths.removeAt(index);
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.close,
                                        color: kWhite, size: 20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 12),
              Text('Name', style: kBodyTitleR),
              const SizedBox(height: 4),
              CustomTextFormField(
                backgroundColor: kCardBackgroundColor,
                labelText: 'Name',
                textController: nameController,
              ),
              const SizedBox(height: 12),
              Text('Description', style: kBodyTitleR),
              const SizedBox(height: 4),
              CustomTextFormField(
                backgroundColor: kCardBackgroundColor,
                labelText: 'Description',
                textController: descriptionController,
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              Text('Specifications', style: kBodyTitleR),
              const SizedBox(height: 4),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: specificationControllers.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          backgroundColor: kCardBackgroundColor,
                          labelText: 'Specification',
                          textController: specificationControllers[index],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () => _removeSpecificationField(index),
                      ),
                    ],
                  );
                },
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: _addSpecificationField,
                  icon: Icon(Icons.add),
                  label: Text('Add Specification'),
                ),
              ),
              const SizedBox(height: 12),
              Text('Seller Name', style: kBodyTitleR),
              const SizedBox(height: 4),
              CustomTextFormField(
                backgroundColor: kCardBackgroundColor,
                labelText: 'Name',
                textController: sellerNameController,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Actual Price', style: kBodyTitleR),
                        const SizedBox(height: 4),
                        CustomTextFormField(
                          labelText: 'Price',
                          backgroundColor: kCardBackgroundColor,
                          textController: actualPriceController,
                          textInputType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Add Offer Price', style: kBodyTitleR),
                        const SizedBox(height: 4),
                        CustomTextFormField(
                          backgroundColor: kCardBackgroundColor,
                          labelText: 'Price',
                          textController: offerPriceController,
                          textInputType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Show on Public Profile', style: kBodyTitleR),
                  Switch(
                    value: showOnPublicProfile,
                    onChanged: (val) =>
                        setState(() => showOnPublicProfile = val),
                    activeColor: kPrimaryColor,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              customButton(
                label: isUploading ? 'Posting...' : 'Post',
                onPressed: isUploading
                    ? null
                    : () async {
                        SnackbarService snackbarService = SnackbarService();

                        List<String> imageUrls = [];
                        if (imagePaths.isNotEmpty) {
                          imageUrls = await _uploadImagesIfNeeded();
                          if (imageUrls.isEmpty) return;
                        }
                        final productsApiService =
                            ref.read(productsApiServiceProvider);
                        setState(() {
                          isUploading = true;
                        });
                        final specifications = specificationControllers
                            .map((c) => c.text.trim())
                            .where((s) => s.isNotEmpty)
                            .toList();
                        final result = await productsApiService.postProduct(
                          companyId: widget.companyId,
                          name: nameController.text.trim(),
                          actualPrice: double.tryParse(
                                  actualPriceController.text.trim()) ??
                              0.0,
                          discountPrice: double.tryParse(
                                  offerPriceController.text.trim()) ??
                              0.0,
                          imageUrls: imageUrls,
                          tags: [],
                          specifications: specifications,
                          isPublic: showOnPublicProfile,
                        );
                        setState(() {
                          isUploading = false;
                        });
                        if (result != false) {
                          Navigator.of(context).pop();
                          snackbarService.showSnackBar(
                              'Product posted successfully and will be reviewed by admin');
                          ref
                              .read(productsNotifierProvider.notifier)
                              .refreshProducts(widget.companyId);
                        } else {
                          snackbarService.showSnackBar(
                              'Failed to post product!',
                              type: SnackbarType.error);
                        }
                      },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
