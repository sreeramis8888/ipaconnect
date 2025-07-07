import 'package:flutter/material.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
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
  String? imagePath;
  Uint8List? imageBytes; // For preview
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final sellerNameController = TextEditingController();
  final actualPriceController = TextEditingController();
  final offerPriceController = TextEditingController();
  bool showOnPublicProfile = true;
  bool isUploading = false;

  Future<void> _pickAndCropImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;
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
        imagePath = localPath;
        imageBytes = croppedBytes;
      });
    }
  }

  Future<String?> _uploadImageIfNeeded() async {
    if (imagePath == null) return null;
    try {
      setState(() {
        isUploading = true;
      });
      final url = await imageUpload(imagePath!);
      setState(() {
        isUploading = false;
      });
      return url;
    } catch (e) {
      setState(() {
        isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image upload failed')),
      );
      return null;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    sellerNameController.dispose();
    actualPriceController.dispose();
    offerPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                child: imageBytes == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: kSecondaryTextColor, size: 32),
                          const SizedBox(height: 4),
                          Text('Upload Image', style: kSmallTitleR),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.memory(
                          imageBytes!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 100,
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
                  onChanged: (val) => setState(() => showOnPublicProfile = val),
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
                      final userAsync = ref.read(userProvider);
                      if (!userAsync.hasValue || userAsync.value == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('User info not loaded.')),
                        );
                        return;
                      }
                      final user = userAsync.value!;
                      String? imageUrl;
                      if (imagePath != null) {
                        imageUrl = await _uploadImageIfNeeded();
                        if (imageUrl == null) return;
                      }
                      final productsApiService =
                          ref.read(productsApiServiceProvider);
                      setState(() {
                        isUploading = true;
                      });
                      final result = await productsApiService.postProduct(
                        userId: user.id ?? '',
                        userName: user.name ?? '',
                        companyId: widget.companyId,
                        name: nameController.text.trim(),
                        description: descriptionController.text.trim(),
                        actualPrice: double.tryParse(
                                actualPriceController.text.trim()) ??
                            0.0,
                        discountPrice:
                            double.tryParse(offerPriceController.text.trim()) ??
                                0.0,
                        imageUrls: imageUrl != null ? [imageUrl] : [],
                        tags: [],
                        isPublic: showOnPublicProfile,
                        status: 'pending',
                      );
                      setState(() {
                        isUploading = false;
                      });
                      if (result != null) {
                        Navigator.of(context).pop();
                        snackbarService.showSnackBar(
                            'Product posted successfully and will be reviewed by admin');
                      } else {
                        snackbarService.showSnackBar('Failed to post product!',
                            type: SnackbarType.error);
                      }
                    },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
