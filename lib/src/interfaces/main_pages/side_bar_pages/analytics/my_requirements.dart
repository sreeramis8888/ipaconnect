import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:intl/intl.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_round_button.dart';

import 'package:shimmer/shimmer.dart';
import 'package:ipaconnect/src/data/notifiers/feed_notifier.dart';

class MyRequirements extends ConsumerStatefulWidget {
  const MyRequirements({super.key});

  @override
  ConsumerState<MyRequirements> createState() => _MyRequirementsState();
}

class _MyRequirementsState extends ConsumerState<MyRequirements> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchInitialFeeds();
  }

  Future<void> _fetchInitialFeeds() async {
    await ref.read(feedNotifierProvider.notifier).fetchMoreMyFeed();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(feedNotifierProvider.notifier).fetchMoreMyFeed();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final myPosts = ref.watch(feedNotifierProvider);
    final notifier = ref.read(feedNotifierProvider.notifier);
    final isLoading = notifier.isLoading;
    final isFirstLoad = notifier.isFirstLoad;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
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
        scrolledUnderElevation: 0,
        title: Text('Reviews',
            style: kBodyTitleB.copyWith(color: kSecondaryTextColor)),
      ),
      body: isFirstLoad
          ? Center(child: CircularProgressIndicator())
          : myPosts.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: myPosts.length + (isLoading ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == myPosts.length) {
                              return Center(child: CircularProgressIndicator());
                            }
                            return _buildPostCard(
                              context,
                              myPosts[index].status ?? '',
                              myPosts[index].content ?? '',
                              '3 messages',
                              myPosts[index].createdAt!,
                              myPosts[index].id!,
                              imageUrl: myPosts[index].media,
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                )
              : Center(
                  child: Text('No Business Posts Added'),
                ),
    );
  }

  Widget _buildPostCard(BuildContext context, String status, String description,
      String messages, DateTime timestamp, String requirementId,
      {String? imageUrl}) {
    DateTime localDateTime = timestamp.toLocal();

    String formattedDate =
        DateFormat('h:mm a · MMM d, y').format(localDateTime);
    return Card(
      color: kCardBackgroundColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: kStrokeColor)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (imageUrl != "")
              Column(
                children: [
                  Image.network(imageUrl!,
                      loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      // If the image is fully loaded, show the image
                      return child;
                    }
                    // While the image is loading, show shimmer effect
                    return Container(
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    );
                  }),
                  SizedBox(height: 10),
                ],
              ),
            Text(
              description,
              style: kBodyTitleB,
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Status: ${status.toUpperCase()}',
                  style: TextStyle(
                    color: status == 'published' ? Colors.green : Colors.red,
                  ),
                ),
                Text(
                  formattedDate.toString(),
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFEB5757),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              onPressed: () {
                _showDeleteDialog(context, requirementId, imageUrl!);
              },
              child: const Text(
                'DELETE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, requirementId, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.question_mark_rounded,
                size: 70,
              ),
              SizedBox(height: 20),
              Text(
                'Delete Post?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                'Are you sure?',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child:
                        Text('No', style: TextStyle(color: Color(0xFF0E1877))),
                  ),
                  Consumer(
                    builder: (context, ref, child) {
                      return TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Color(0xFFEB5757)),
                        onPressed: () async {
                          // await deletePost(requirementId, context); // Removed deletePost
                          ref.invalidate(
                              feedNotifierProvider); // Invalidate feedNotifierProvider
                          Navigator.of(context).pop();
                        },
                        child: Text('Yes, Delete',
                            style: TextStyle(color: Colors.white)),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
