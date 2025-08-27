import 'package:flutter/material.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/notifiers/products_notifier.dart';
import 'package:ipaconnect/src/data/services/snackbar_service.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_button.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_round_button.dart';
import 'package:ipaconnect/src/interfaces/components/textFormFields/custom_text_form_field.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:ipaconnect/src/interfaces/additional_screens/crop_image_screen.dart';
import 'package:ipaconnect/src/data/services/image_upload.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/services/api_routes/products_api/products_api_service.dart';
import 'package:ipaconnect/src/data/models/product_model.dart';

class AddProductModalSheet extends ConsumerStatefulWidget {
  final List<String> categories;
  final String companyId;
  final ProductModel? productToEdit;
  const AddProductModalSheet({
    Key? key,
    required this.categories,
    required this.companyId,
    this.productToEdit,
  }) : super(key: key);

  @override
  ConsumerState<AddProductModalSheet> createState() =>
      _AddProductModalSheetState();
}

class _AddProductModalSheetState extends ConsumerState<AddProductModalSheet> {
  final _formKey = GlobalKey<FormState>();
  String? selectedCategory;
  List<String> imagePaths = [];
  List<Uint8List> imageBytesList = [];
  List<String> existingImageUrls = []; // For existing product images
  final nameController = TextEditingController();

  final actualPriceController = TextEditingController();
  final offerPriceController = TextEditingController();
  final List<TextEditingController> specificationControllers = [
    TextEditingController()
  ];
  bool showOnPublicProfile = true;
  bool isUploading = false;

  Widget _label(String text, {bool required = false}) {
    return RichText(
      text: TextSpan(
        style: kBodyTitleR,
        children: [
          TextSpan(text: text),
          if (required)
            const TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Prefill fields if editing
    final product = widget.productToEdit;
    if (product != null) {
      nameController.text = product.name;
      actualPriceController.text = product.actualPrice.toString();
      offerPriceController.text = product.discountPrice.toString();
      showOnPublicProfile = product.isPublic;

      // Handle specifications
      if (product.specifications.isNotEmpty) {
        specificationControllers.clear();
        for (final spec in product.specifications) {
          specificationControllers.add(TextEditingController(text: spec));
        }
      }

      // Handle existing images
      if (product.images.isNotEmpty) {
        existingImageUrls = product.images.map((img) => img.url).toList();
      }
    }
  }

  Future<void> _pickAndCropImage() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles.isEmpty) return;
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
        urls.add(url);
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
          child: Form(
            key: _formKey,
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
                    Text(
                        widget.productToEdit != null
                            ? 'Edit Product'
                            : 'Add Product',
                        style: kSmallTitleL),
                  ],
                ),
                const SizedBox(height: 12),
                if (existingImageUrls.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      'Existing Images (tap to remove)',
                      style: kSmallTitleL.copyWith(color: kSecondaryTextColor),
                    ),
                  ),
                _label('Images', required: true),
                GestureDetector(
                  onTap: _pickAndCropImage,
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: kCardBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: (imageBytesList.isEmpty && existingImageUrls.isEmpty)
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add,
                                  color: kSecondaryTextColor, size: 32),
                              const SizedBox(height: 4),
                              Text('Upload Images', style: kSmallTitleL),
                            ],
                          )
                        : ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: imageBytesList.length +
                                existingImageUrls.length,
                            separatorBuilder: (_, __) => SizedBox(width: 8),
                            itemBuilder: (context, index) {
                              if (index < imageBytesList.length) {
                                // Local images (new uploads)
                                return Stack(
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
                                );
                              } else {
                                // Existing images (URLs)
                                final urlIndex = index - imageBytesList.length;
                                return Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        existingImageUrls[urlIndex],
                                        fit: BoxFit.cover,
                                        width: 100,
                                        height: 100,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            width: 100,
                                            height: 100,
                                            color: kCardBackgroundColor,
                                            child: Icon(Icons.broken_image,
                                                color: kSecondaryTextColor,
                                                size: 40),
                                          );
                                        },
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            existingImageUrls
                                                .removeAt(urlIndex);
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
                                );
                              }
                            },
                          ),
                  ),
                ),
                const SizedBox(height: 12),
                _label('Name', required: true),
                const SizedBox(height: 4),
                CustomTextFormField(
                  backgroundColor: kCardBackgroundColor,
                  labelText: 'Name',
                  textController: nameController,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return "Name is required. Don't leave it blank. Please make sure to fill it in.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                _label('Specifications', required: true),
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
                _label('Actual Price', required: true),
                const SizedBox(height: 4),
                CustomTextFormField(
                  labelText: 'Price',
                  backgroundColor: kCardBackgroundColor,
                  textController: actualPriceController,
                  textInputType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return "Actual price is required. Don't leave it blank.";
                    }
                    if (double.tryParse(v.trim()) == null) {
                      return 'Actual price Please enter a valid number.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                _label('Add Offer Price', required: true),
                const SizedBox(height: 4),
                CustomTextFormField(
                  backgroundColor: kCardBackgroundColor,
                  labelText: 'Price',
                  textController: offerPriceController,
                  textInputType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return "Discount price is required. Don't leave it blank.";
                    }
                    if (double.tryParse(v.trim()) == null) {
                      return 'Discount price Please enter a valid number.';
                    }
                    return null;
                  },
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
                  label: isUploading
                      ? (widget.productToEdit != null
                          ? 'Updating...'
                          : 'Posting...')
                      : (widget.productToEdit != null ? 'Update' : 'Post'),
                  onPressed: isUploading
                      ? null
                      : () async {
                          SnackbarService snackbarService = SnackbarService();
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }

                          // Validate specifications
                          final nonEmptySpecifications =
                              specificationControllers
                                  .map((c) => c.text.trim())
                                  .where((s) => s.isNotEmpty)
                                  .toList();
                          if (nonEmptySpecifications.isEmpty) {
                            snackbarService.showSnackBar(
                                "Specifications is required. Don't leave it blank.",
                                type: SnackbarType.error);
                            return;
                          }

                          // Validate images
                          if (imageBytesList.isEmpty &&
                              existingImageUrls.isEmpty) {
                            snackbarService.showSnackBar(
                                "Images is required. Don't leave it blank.",
                                type: SnackbarType.error);
                            return;
                          }

                          List<String> imageUrls = [];

                          // Upload new images if any
                          if (imagePaths.isNotEmpty) {
                            final newImageUrls = await _uploadImagesIfNeeded();
                            if (newImageUrls.isEmpty) return;
                            imageUrls.addAll(newImageUrls);
                          }

                          // Add existing image URLs
                          imageUrls.addAll(existingImageUrls);
                          final productsApiService =
                              ref.read(productsApiServiceProvider);
                          setState(() {
                            isUploading = true;
                          });
                          final specifications = nonEmptySpecifications;

                          bool? result;
                          if (widget.productToEdit != null) {
                            // Update existing product
                            result = await productsApiService.updateProduct(
                              productId: widget.productToEdit!.id,
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
                          } else {
                            result = await productsApiService.postProduct(
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
                          }

                          setState(() {
                            isUploading = false;
                          });
                          if (result != false) {
                            Navigator.of(context).pop();
                            snackbarService.showSnackBar(widget.productToEdit !=
                                    null
                                ? 'Product updated successfully!'
                                : 'Product posted successfully and will be reviewed by admin');
                            ref
                                .read(productsNotifierProvider.notifier)
                                .refreshProducts(widget.companyId,
                                    isUserProducts: true);
                          } else {
                            snackbarService.showSnackBar(
                                widget.productToEdit != null
                                    ? 'Failed to update product!'
                                    : 'Failed to post product!',
                                type: SnackbarType.error);
                          }
                        },
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
