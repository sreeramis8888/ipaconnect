import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/services/api_routes/folder_api/folder_api.dart';
import 'package:ipaconnect/src/data/services/image_upload.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_button.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_round_button.dart';
import 'package:ipaconnect/src/interfaces/components/loading/loading_indicator.dart';

class MediaUploadPage extends ConsumerStatefulWidget {
  final String eventId;

  const MediaUploadPage({
    super.key,
    required this.eventId,
  });

  @override
  ConsumerState<MediaUploadPage> createState() => _MediaUploadPageState();
}

class _MediaUploadPageState extends ConsumerState<MediaUploadPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _selectedImages = [];
  final List<String> _videoLinks = [];
  final TextEditingController _videoLinkController = TextEditingController();
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _videoLinkController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (_selectedImages.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum 3 images allowed')),
      );
      return;
    }

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() => _isUploading = true);
      try {
        final String imageUrl = await imageUpload(image.path);
        setState(() {
          _selectedImages.add(imageUrl);
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image: $e')),
        );
      } finally {
        setState(() => _isUploading = false);
      }
    }
  }

  void _addVideoLink() {
    if (_videoLinks.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum 3 videos allowed')),
      );
      return;
    }

    final link = _videoLinkController.text.trim();
    if (link.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a video link')),
      );
      return;
    }

    setState(() {
      _videoLinks.add(link);
      _videoLinkController.clear();
    });
  }

  Future<void> _saveMedia() async {
    if (_selectedImages.isEmpty && _videoLinks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one media item')),
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      final files = [
        ..._selectedImages.map((url) => {
              'type': 'image',
              'url': url,
            }),
        ..._videoLinks.map((url) => {
              'type': 'video',
              'url': url,
            }),
      ];
      final folderApiService = ref.watch(folderApiServiceProvider);
      await folderApiService.addFilesToPublicFolder(
        eventId: widget.eventId,
        files: files,
      );

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save media: $e')),
        );
      }
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: kPrimaryColor,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorWeight: 3,
          labelColor: kPrimaryColor,
          dividerColor: kBackgroundColor,
          unselectedLabelColor: kSecondaryTextColor,
          labelStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          tabs: const [
            Tab(text: 'Images'),
            Tab(text: 'Videos'),
          ],
        ),
        title: const Text(
          "Add Media",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: kWhite,
          ),
        ),
        backgroundColor: kBackgroundColor,
        scrolledUnderElevation: 0,
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
      ),
      body: _isUploading
          ? const Center(child: LoadingAnimation())
          : Column(
              children: [
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Images Tab
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: kCardBackgroundColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: kStrokeColor),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.info_outline,
                                      color: kSecondaryTextColor, size: 20),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'Select up to 3 images',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: kSecondaryTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            Expanded(
                              child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                ),
                                itemCount: 3,
                                itemBuilder: (context, index) {
                                  if (index < _selectedImages.length) {
                                    return Stack(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Image.network(
                                              _selectedImages[index],
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: double.infinity,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 4,
                                          right: 4,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: kWhite,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                  blurRadius: 4,
                                                ),
                                              ],
                                            ),
                                            child: IconButton(
                                              icon: const Icon(Icons.close,
                                                  size: 15),
                                              onPressed: () {
                                                setState(() {
                                                  _selectedImages
                                                      .removeAt(index);
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return GestureDetector(
                                      onTap: _pickImage,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: kCardBackgroundColor,
                                          border: Border.all(
                                              color: kStrokeColor, width: 2),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.add_photo_alternate,
                                                size: 32,
                                                color: kSecondaryTextColor),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Add Image',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: kSecondaryTextColor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Videos Tab
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: kCardBackgroundColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: kStrokeColor),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.info_outline,
                                      color: kSecondaryTextColor, size: 20),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'Add up to 3 YouTube video links',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: kSecondaryTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _videoLinkController,
                                    decoration: InputDecoration(
                                      hintText: 'Enter YouTube video link',
                                      hintStyle:
                                          TextStyle(color: kSecondaryTextColor),
                                      filled: true,
                                      fillColor: kCardBackgroundColor,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide:
                                            BorderSide(color: kStrokeColor),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide:
                                            BorderSide(color: kStrokeColor),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                            color: kPrimaryColor, width: 2),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 14),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                ElevatedButton(
                                  onPressed: _addVideoLink,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: kPrimaryColor,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Add',
                                    style: TextStyle(
                                      color: kWhite,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Expanded(
                              child: ListView.builder(
                                itemCount: _videoLinks.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                      color: kWhite,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 8),
                                      leading: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.red.shade50,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Icon(Icons.play_circle_outline,
                                            color: Colors.red.shade400),
                                      ),
                                      title: Text(
                                        _videoLinks[index],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      trailing: IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.grey.shade600),
                                        onPressed: () {
                                          setState(() {
                                            _videoLinks.removeAt(index);
                                          });
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: kCardBackgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: customButton(
                    label: 'Save Media',
                    onPressed: _isUploading ? null : _saveMedia,
                  ),
                ),
              ],
            ),
    );
  }
}
