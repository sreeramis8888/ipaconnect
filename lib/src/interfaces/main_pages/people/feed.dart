import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/models/feed_model.dart';
import 'package:ipaconnect/src/data/models/user_model.dart';
import 'package:ipaconnect/src/data/notifiers/feed_notifier.dart';
import 'package:ipaconnect/src/data/services/api_routes/feed_api/feed_api_service.dart';
import 'package:ipaconnect/src/data/services/api_routes/user_api/user_data/user_data_api.dart';
import 'package:ipaconnect/src/data/utils/get_time_ago.dart';
import 'package:ipaconnect/src/data/utils/globals.dart';
import 'package:ipaconnect/src/interfaces/additional_screens/crop_image_screen.dart';
import 'package:ipaconnect/src/interfaces/components/loading/loading_indicator.dart';
import 'package:ipaconnect/src/interfaces/components/modals/add_feed_modalSheet.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../components/custom_widgets/expandable_text.dart';

class FeedView extends ConsumerStatefulWidget {
  const FeedView({super.key});

  @override
  ConsumerState<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends ConsumerState<FeedView> {
  final TextEditingController feedContentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);
    _fetchInitialUsers();
  }

  Future<void> _fetchInitialUsers() async {
    await ref.read(feedNotifierProvider.notifier).fetchMoreFeed();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(feedNotifierProvider.notifier).fetchMoreFeed();
    }
  }

  File? _feedImage;
  ImageSource? _feedImageSource;

  Future<File?> _pickFile() async {
    final picker = ImagePicker();

    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final File imageFile = File(pickedFile.path);
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CropImageScreen(imageFile: imageFile),
          ),
        );

        if (result != null) {
          final tempDir = await getTemporaryDirectory();
          final timestamp = DateTime.now().millisecondsSinceEpoch;
          final tempFile = File('${tempDir.path}/cropped_image_$timestamp.jpg');
          if (!tempFile.existsSync()) {
            tempFile.createSync(recursive: true);
          }
          await tempFile.writeAsBytes(result.bytes);

          setState(() {
            _feedImage = tempFile;
            _feedImageSource = ImageSource.gallery;
          });
          return _feedImage;
        }
      }
    } catch (e) {
      debugPrint("Error picking or cropping the image: $e");
    }

    return null;
  }

  void _openModalSheet({required String sheet}) {
    feedContentController.clear();
    _feedImage = null;
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return ShowAddFeedModal(
            pickImage: _pickFile,
            textController: feedContentController,
          );
        });
  }

  String selectedFilter = 'All'; // Default filter is 'All'

  // Example method to filter feeds
  List<FeedModel> filterFeeds(List<FeedModel> feeds) {
    if (selectedFilter == 'All') {
      return feeds;
    } else {
      return feeds.where((feed) => feed.type == selectedFilter).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final feeds = ref.watch(feedNotifierProvider);
    final isLoading = ref.read(feedNotifierProvider.notifier).isLoading;
    final isFirstLoad = ref.read(feedNotifierProvider.notifier).isFirstLoad;
    List<FeedModel> filteredFeeds = filterFeeds(feeds);

    return RefreshIndicator(
      backgroundColor: kWhite,
      color: Colors.red,
      onRefresh: () => ref.read(feedNotifierProvider.notifier).refreshFeed(),
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Row(
                //       children: [
                //         _buildChoiceChip('All'),
                //         _buildChoiceChip('Information'),
                //         _buildChoiceChip('Job'),
                //         _buildChoiceChip('Funding'),
                //         _buildChoiceChip('Requirement'),
                //       ],
                //     ),
                //   ),
                // ),
                // Feed list
                Expanded(
                  child: isFirstLoad
                      ? Center(
                          child: LoadingAnimation(),
                        )
                      : filteredFeeds.isEmpty
                          ? const Center(child: Text('No FEEDS'))
                          : ListView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.all(16.0),
                              itemCount: filteredFeeds.length +
                                  1, // +2 for Ad and spacer
                              itemBuilder: (context, index) {
                                if (index == filteredFeeds.length) {
                                  return isLoading
                                      ? const ReusableFeedPostSkeleton()
                                      : const SizedBox.shrink();
                                }

                                if (index == filteredFeeds.length + 1) {
                                  return const SizedBox(height: 80);
                                }

                                final feed = filteredFeeds[index];
                                if (feed.status == 'published') {
                                  return _buildPost(
                                    withImage: feed.media != null &&
                                        feed.media!.isNotEmpty,
                                    feed: feed,
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              },
                            ),
                ),
              ],
            ),
            Positioned(
              right: 30,
              bottom: 30,
              child: GestureDetector(
                onTap: () {
                  // if (subscriptionType != 'free') {
                  _openModalSheet(sheet: 'post');
                  // } else {
                  //   showDialog(
                  //     context: context,
                  //     builder: (context) => const UpgradeDialog(),
                  //   );
                  // }
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: kPrimaryColor,
                  ),
                  child: Icon(
                    Icons.add,
                    color: kWhite,
                    size: 27,
                  ),
                ),
              ),
            ),
          ],
        ),
        // floatingActionButton: FloatingActionButton.extended(
        //   onPressed: () => _openModalSheet(sheet: 'post'),
        //   label: const Text(
        //     '',
        //     style: TextStyle(color: kWhite),
        //   ),
        //   icon: const Icon(
        //     Icons.add,
        //     color: kWhite,
        //     size: 27,
        //   ),
        //   backgroundColor: const Color(0xFFE30613),
        // ),
      ),
    );
  }

  // // Method to build individual Choice Chips
  // Widget _buildChoiceChip(String label) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 4.0),
  //     child: ChoiceChip(
  //       label: Text(label),
  //       selected: selectedFilter == label,
  //       onSelected: (selected) {
  //         setState(() {
  //           selectedFilter = label;
  //         });
  //       },
  //       backgroundColor: kWhite, // Light green background color
  //       selectedColor: const Color(0xFFD3EDCA), // When selected

  //       shape: RoundedRectangleBorder(
  //         side: const BorderSide(color: Color.fromARGB(255, 214, 210, 210)),
  //         borderRadius: BorderRadius.circular(20.0), // Circular border
  //       ),
  //       showCheckmark: false, // Remove tick icon
  //     ),
  //   );
  // }

  Widget _buildPost({bool withImage = false, required FeedModel feed}) {
    return Consumer(
      builder: (context, ref, child) {
        final asyncUser = ref
            .watch(getUserDetailsByIdProvider(userId: feed.author?.id ?? ''));
        return asyncUser.when(
          data: (user) {
            // var receiver = ChatUser(
            //   id: user.id ?? '',
            //   fullName: user.fullName ?? '',
            //   image: user.image ?? '',
            // );

            // var sender = ChatUser(
            //   id: id,
            // );
            return ReusableBusinessPost(
                author: user??UserModel(name: 'Unkown'),
                withImage: feed.media != null ? true : false,
                business: feed,
                onLike: () async {
                  final feedApiService = ref.watch(feedApiServiceProvider);
                  await feedApiService.likeFeed(feedId:  feed.id!);
                  ref.read(feedNotifierProvider.notifier).refreshFeed();
                },
                onComment: () async {},
                onShare: () {
                  // businessEnquiry(
                  //     businessAuthor: user,
                  //     context: context,
                  //     onButtonPressed: () async {},
                  //     buttonText: 'MESSAGE',
                  //     businesss: feed,
                  //     receiver: receiver,
                  //     sender: sender);
                });
          },
          loading: () => const ReusableFeedPostSkeleton(),
          error: (error, stackTrace) {
            return const Center(
              child: Text('No Posts'),
            );
          },
        );
      },
    );
  }
}

class ReusableBusinessPost extends ConsumerStatefulWidget {
  final FeedModel business;
  final bool withImage;
  final UserModel author;
  final Function onLike;
  final Function onComment;
  final Function onShare;

  const ReusableBusinessPost({
    super.key,
    required this.business,
    this.withImage = false,
    required this.onLike,
    required this.onComment,
    required this.onShare,
    required this.author,
  });

  @override
  _ReusableBusinessPostState createState() => _ReusableBusinessPostState();
}

class _ReusableBusinessPostState extends ConsumerState<ReusableBusinessPost>
    with SingleTickerProviderStateMixin {
  FocusNode commentFocusNode = FocusNode();
  bool isLiked = false;
  bool showHeartAnimation = false;
  late AnimationController _animationController;
  TextEditingController commentController = TextEditingController();
  int likes = 0;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  initialize() async {
    if (widget.business.likes != null) {
      if (widget.business.likes!.contains(id)) {
        isLiked = true;
      }
    }
    likes = widget.business.likes?.length ?? 0;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  void _toggleLike() {
    setState(() {
      likes = isLiked == true ? likes - 1 : likes + 1;
      isLiked = !isLiked;
      showHeartAnimation = true;
      widget.onLike();
    });
    _animationController.forward().then((_) {
      _animationController.reset();
      setState(() {
        showHeartAnimation = false;
      });
    });
  }

  void _openCommentModal() {
    log('comments: ${widget.business.comments?.length}');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30),
          child: Container(
            decoration: const BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20.0),
                bottom: Radius.circular(20.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  title: const Text('Comments'),
                  backgroundColor: kWhite,
                  automaticallyImplyLeading: false,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20.0),
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: widget.business.comments?.length ?? 0,
                        itemBuilder: (context, index) {
                          return Consumer(
                            builder: (context, ref, child) {
                              return ListTile(
                                leading: ClipOval(
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    child: widget.business.comments?[index].user
                                                ?.image !=
                                            null
                                        ? Image.network(
                                            fit: BoxFit.fill,
                                            widget.business.comments![index]
                                                .user!.image!)
                                        : const Icon(Icons.person),
                                  ),
                                ),
                                title: Text(
                                    widget.business.comments![index].user !=
                                            null
                                        ? widget.business.comments![index].user!
                                                .name ??
                                            'Unknown User'
                                        : 'Unknown User'),
                                subtitle: Text(
                                    widget.business.comments?[index].comment ??
                                        ''),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    _buildCommentInputField(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCommentInputField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              focusNode: commentFocusNode,
              controller: commentController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                hintText: "Add a comment...",
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: const Text(
                'Post',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                if (commentController.text != '') {
                  FocusScope.of(context).unfocus();   final feedApiService = ref.watch(feedApiServiceProvider);
                  await feedApiService. commentFeed(
                      feedId: widget.business.id!,
                      comment: commentController.text);
                  await ref
                      .read(feedNotifierProvider.notifier)
                      .refreshFeed();
                  commentController.clear();
                  commentFocusNode.unfocus();
                }
              })
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    commentFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kWhite,
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                ClipOval(
                  child: Container(
                    width: 40,
                    height: 40,
                    color: Colors.grey[200],
                    child: widget.author.image != null
                        ? Image.network(
                            widget.author.image!,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.person, color: Colors.grey),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.author.name ?? 'Unknown User',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        timeAgo(widget.business.createdAt!),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.business.author != id)
                  IconButton(
                    icon: const Icon(Icons.more_vert, color: Colors.grey),
                    onPressed: () {
                      // Show options menu
                    },
                  ),
              ],
            ),
          ),

          // // Post title
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
          //   child: Text(
          //     widget.business. ?? 'Post Title',
          //     style: const TextStyle(
          //       fontWeight: FontWeight.bold,
          //       fontSize: 18,
          //     ),
          //   ),
          // ),

          const SizedBox(height: 8),

          // Post content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ExpandableText(text: widget.business.content ?? ''),
          ),

          const SizedBox(height: 12),

          // Hashtags
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              '#FamilyHistory #FoundersStory',
              style: TextStyle(
                color: Colors.blue[700],
                fontSize: 14,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Post image
          if (widget.withImage && widget.business.media != null)
            _buildPostImage(widget.business.media!),

          const SizedBox(height: 16),

          // Action buttons row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                // Like button with count
                GestureDetector(
                  onTap: _toggleLike,
                  child: Row(
                    children: [
                      Icon(
                        isLiked ? Icons.favorite : Icons.favorite_outline,
                        color: isLiked ? Colors.red : kBlack,
                        size: 30,
                      ),
                      Text(
                        '$likes',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 24),

                // Comment button with count
                GestureDetector(
                  onTap: _openCommentModal,
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/svg/icons/comment.svg'),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.business.comments?.length ?? 0}',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 24),

                // Share button with count
                if (widget.business.author != id)
                  GestureDetector(
                    onTap: () => widget.onShare(),
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/svg/icons/share.svg'),
                        const SizedBox(width: 4),
                        Text(
                          '32', // You can replace this with actual share count
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                const Spacer(),

                // Bookmark button
                Icon(
                  Icons.bookmark_border,
                  color: Colors.grey[600],
                  size: 29,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Add comment section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GestureDetector(
              onTap: _openCommentModal,
              child: Row(
                children: [
                  ClipOval(
                    child: Container(
                      width: 32,
                      height: 32,
                      color: Colors.grey[200],
                      child: const Icon(Icons.person,
                          color: Colors.grey, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Add a comment...',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Divider
          Container(
            height: 8,
            color: Colors.grey[100],
          ),
        ],
      ),
    );
  }

  Widget _buildPostImage(String imageUrl) {
    return GestureDetector(
      onDoubleTap: _toggleLike,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(
              maxHeight: 400,
            ),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 300,
                    color: Colors.grey[300],
                  ),
                );
              },
            ),
          ),
          if (showHeartAnimation)
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: showHeartAnimation ? 1.0 : 0.0,
              child: Icon(
                Icons.favorite,
                color: Colors.red.withOpacity(0.8),
                size: 100,
              ),
            ),
        ],
      ),
    );
  }
}

class ReusableFeedPostSkeleton extends StatelessWidget {
  const ReusableFeedPostSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kWhite,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Color.fromARGB(255, 213, 208, 208)),
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                _buildShimmerContainer(height: 12, width: 100),
                const SizedBox(height: 15),
              ],
            ),
            // Image Skeleton
            _buildShimmerContainer(height: 400.0, width: double.infinity),
            const SizedBox(height: 16),
            // Content Text Skeleton
            _buildShimmerContainer(height: 14, width: double.infinity),
            const SizedBox(height: 16),
            // User Info Skeleton
            Row(
              children: [
                // User Avatar
                ClipOval(
                  child: _buildShimmerContainer(height: 30, width: 30),
                ),
                const SizedBox(width: 8),
                // User Info (Name, Company)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildShimmerContainer(height: 12, width: 100),
                    const SizedBox(height: 4),
                    _buildShimmerContainer(height: 12, width: 60),
                  ],
                ),
                const Spacer(),
                // Post Date Skeleton
                _buildShimmerContainer(height: 12, width: 80),
              ],
            ),
            const SizedBox(height: 16),
            // Action Buttons Skeleton
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _buildShimmerCircle(height: 30, width: 30),
                    const SizedBox(width: 8),
                    _buildShimmerCircle(height: 30, width: 30),
                    const SizedBox(width: 8),
                    _buildShimmerCircle(height: 30, width: 30),
                  ],
                ),
                // Likes Count Skeleton
                _buildShimmerContainer(height: 14, width: 60),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerContainer(
      {required double height, required double width}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        color: Colors.grey[300],
      ),
    );
  }

  Widget _buildShimmerCircle({required double height, required double width}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
