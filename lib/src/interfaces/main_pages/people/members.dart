import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/notifiers/members_notifier.dart';
import 'package:ipaconnect/src/interfaces/components/loading/loading_indicator.dart';

import 'package:ipaconnect/src/data/services/api_routes/chat_api/chat_api_service.dart';
import 'package:ipaconnect/src/interfaces/main_pages/people/chat_screen.dart';
import 'package:ipaconnect/src/interfaces/main_pages/profile/profile_preview.dart';

import 'package:shimmer/shimmer.dart';

import 'dart:async';
import 'dart:developer';

class MembersPage extends ConsumerStatefulWidget {
  const MembersPage({super.key});

  @override
  ConsumerState<MembersPage> createState() => _MembersPageState();
}

class _MembersPageState extends ConsumerState<MembersPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  FocusNode _searchFocus = FocusNode();
  Timer? _debounce;
  String? selectedDistrictId;
  String? selectedDistrictName;
  String? businessTagSearch;
  List<String> selectedTags = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchInitialUsers();
  }

  Future<void> _fetchInitialUsers() async {
    await ref.read(membersNotifierProvider.notifier).fetchMoreUsers();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(membersNotifierProvider.notifier).fetchMoreUsers();
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      ref.read(membersNotifierProvider.notifier).searchUsers(query);
    });
  }

  void _onSearchSubmitted(String query) {
    ref.read(membersNotifierProvider.notifier).searchUsers(query);
  }

  @override
  Widget build(BuildContext context) {
    final users = ref.watch(membersNotifierProvider);
    final isLoading = ref.read(membersNotifierProvider.notifier).isLoading;
    final isFirstLoad = ref.read(membersNotifierProvider.notifier).isFirstLoad;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.zero,
        itemCount: 1 +
            (isFirstLoad
                ? 1
                : users.isNotEmpty
                    ? users.length + (isLoading ? 1 : 0)
                    : 1),
        itemBuilder: (context, index) {
          if (index == 0) {
            // Search bar and header widgets
            return Container(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          cursorColor: kWhite,
                          controller: _searchController,
                          focusNode: _searchFocus,
                          style: kBodyTitleR.copyWith(
                            fontSize: 14,
                            color: kSecondaryTextColor,
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 16),
                            filled: true,
                            fillColor: kCardBackgroundColor,
                            prefixIcon: const Icon(
                              Icons.search,
                              size: 20,
                              color: kSecondaryTextColor,
                            ),
                            hintText: 'Search Members',
                            hintStyle: kBodyTitleR.copyWith(
                              fontSize: 14,
                              color: kSecondaryTextColor,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: _onSearchChanged,
                          onSubmitted: _onSearchSubmitted,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            );
          }

          // Loading state
          if (isFirstLoad) {
            return const Center(child: LoadingAnimation());
          }

          // No members found
          if (!isFirstLoad && users.isEmpty && index == 1) {
            return Column(
              children: [
                SizedBox(height: 100),
                Center(
                  child: Text(
                    'No Members Found',
                    style: kSubHeadingL,
                  ),
                ),
              ],
            );
          }

          // User list
          final userIndex = index - 1;
          if (userIndex < users.length) {
            final user = users[userIndex];
            final userId = user.id ?? '';
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProfilePreviewFromModel(user: user),
                  ),
                );
              },
              child: Column(
                children: [
                  ListTile(
                    tileColor: kCardBackgroundColor,
                    leading: SizedBox(
                      height: 40,
                      width: 40,
                      child: ClipOval(
                        child: Image.network(
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            );
                          },
                          user.image ?? '',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return SvgPicture.asset(
                                'assets/svg/icons/dummy_person_small.svg');
                          },
                        ),
                      ),
                    ),
                    title: Text(
                      user.name ?? '',
                      style: kSmallTitleR.copyWith(color: kSecondaryTextColor),
                    ),
                    trailing: SizedBox(
                      width: 40,
                      height: 40,
                      child: IconButton(
                        icon: const Icon(
                          Icons.chat_bubble_outline,
                          color: kWhite,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () async {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) =>
                                const Center(child: LoadingAnimation()),
                          );
                          final chatApi = ref.read(chatApiServiceProvider);
                          final conversation =
                              await chatApi.create1to1Conversation(userId);
                          Navigator.of(context).pop();
                          if (conversation != null) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(userImage: user.image??'',
                                  conversationId: conversation.id ?? '',
                                  chatTitle: user.name ?? '',
                                  userId: userId,
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Failed to start chat.')),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  const Divider(
                    thickness: .2,
                    color: kPrimaryColor,
                    height: 1,
                  ),
                ],
              ),
            );
          }

          // Loading more indicator
          if (userIndex == users.length && isLoading) {
            return const Center(child: LoadingAnimation());
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _tagController.dispose();
    _debounce?.cancel();
    _searchFocus.dispose();
    super.dispose();
  }
}
