import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/notifiers/members_notifier.dart';
import 'package:ipaconnect/src/interfaces/components/loading/loading_indicator.dart';
import 'package:ipaconnect/src/interfaces/main_pages/profile/profile_page.dart';
import 'package:ipaconnect/src/data/services/api_routes/chat_api/chat_api_service.dart';
import 'package:ipaconnect/src/interfaces/main_pages/people/chat_screen.dart';

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

  void _showFilterBottomSheet() {
    String? tempDistrictId = selectedDistrictId;
    String? tempDistrictName = selectedDistrictName;

    // showModalBottomSheet(
    //   context: context,
    //   isScrollControlled: true,
    //   backgroundColor: kWhite,
    //   shape: const RoundedRectangleBorder(
    //     borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    //   ),
    //   builder: (context) => StatefulBuilder(
    //     builder: (context, setState) => Padding(
    //       padding: EdgeInsets.only(
    //         bottom: MediaQuery.of(context).viewInsets.bottom,
    //       ),
    //       child: Container(
    //         padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
    //         constraints: BoxConstraints(
    //           maxHeight: MediaQuery.of(context).size.height * 0.7,
    //         ),
    //         child: Column(
    //           mainAxisSize: MainAxisSize.min,
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             // Handle bar
    //             Center(
    //               child: Container(
    //                 width: 40,
    //                 height: 4,
    //                 decoration: BoxDecoration(
    //                   color: Colors.grey[300],
    //                   borderRadius: BorderRadius.circular(2),
    //                 ),
    //               ),
    //             ),
    //             const SizedBox(height: 16),

    //             // Header
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: [
    //                 const Text(
    //                   'Filter Members',
    //                   style: TextStyle(
    //                     fontSize: 18,
    //                     fontWeight: FontWeight.w600,
    //                   ),
    //                 ),
    //                 if (tempDistrictName != null || selectedTags.isNotEmpty)
    //                   TextButton(
    //                     onPressed: () {
    //                       setState(() {
    //                         tempDistrictId = null;
    //                         tempDistrictName = null;
    //                         selectedTags.clear();
    //                       });
    //                       ref.read(membersNotifierProvider.notifier).setTags([]);
    //                     },
    //                     style: TextButton.styleFrom(
    //                       foregroundColor: Colors.red[400],
    //                     ),
    //                     child: const Text('Reset'),
    //                   ),
    //               ],
    //             ),
    //             const SizedBox(height: 8),
    //             const Divider(),

    //             // Filter Options
    //             Flexible(
    //               child: SingleChildScrollView(
    //                 child: Column(
    //                   children: [
    //                     Theme(
    //                       data: Theme.of(context).copyWith(
    //                         dividerColor: Colors.transparent,
    //                       ),
    //                       child: ExpansionTile(
    //                         tilePadding: EdgeInsets.zero,
    //                         childrenPadding: EdgeInsets.zero,
    //                         title: Row(
    //                           children: [
    //                             const Icon(Icons.location_on_outlined),
    //                             const SizedBox(width: 8),
    //                             const Text(
    //                               'District',
    //                               style: TextStyle(
    //                                 fontSize: 16,
    //                                 fontWeight: FontWeight.w500,
    //                               ),
    //                             ),
    //                             if (tempDistrictName != null) ...[
    //                               const SizedBox(width: 8),
    //                               Container(
    //                                 padding: const EdgeInsets.symmetric(
    //                                   horizontal: 8,
    //                                   vertical: 2,
    //                                 ),
    //                                 decoration: BoxDecoration(
    //                                   color: Colors.blue[50],
    //                                   borderRadius: BorderRadius.circular(12),
    //                                 ),
    //                                 child: Text(
    //                                   '1 selected',
    //                                   style: TextStyle(
    //                                     fontSize: 12,
    //                                     color: Colors.blue[700],
    //                                   ),
    //                                 ),
    //                               ),
    //                             ],
    //                           ],
    //                         ),
    //                         children: [
    //                           Consumer(
    //                             builder: (context, ref, child) {
    //                               final asyncDistricts =
    //                                   ref.watch(fetchDistrictsProvider);
    //                               return asyncDistricts.when(
    //                                 data: (districts) {
    //                                   return ListView.builder(
    //                                     shrinkWrap: true,
    //                                     physics:
    //                                         const NeverScrollableScrollPhysics(),
    //                                     itemCount: districts.length,
    //                                     itemBuilder: (context, index) {
    //                                       final district = districts[index];
    //                                       return ListTile(
    //                                         dense: true,
    //                                         contentPadding:
    //                                             const EdgeInsets.symmetric(
    //                                                 horizontal: 12),
    //                                         title: Text(
    //                                           district.name,
    //                                           style: TextStyle(
    //                                             color: tempDistrictId ==
    //                                                     district.id
    //                                                 ? Colors.blue[700]
    //                                                 : null,
    //                                           ),
    //                                         ),
    //                                         trailing:
    //                                             tempDistrictId == district.id
    //                                                 ? Icon(Icons.check_circle,
    //                                                     color: Colors.blue[700])
    //                                                 : null,
    //                                         onTap: () {
    //                                           setState(() {
    //                                             tempDistrictId = district.id;
    //                                             tempDistrictName =
    //                                                 district.name;
    //                                           });
    //                                         },
    //                                       );
    //                                     },
    //                                   );
    //                                 },
    //                                 loading: () =>
    //                                     const Center(child: LoadingAnimation()),
    //                                 error: (error, stackTrace) =>
    //                                     const SizedBox(),
    //                               );
    //                             },
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                     const Divider(),
    //                     ExpansionTile(
    //                       tilePadding: EdgeInsets.zero,
    //                       childrenPadding: EdgeInsets.zero,
    //                       title: Row(
    //                         children: [
    //                           const Icon(Icons.tag),
    //                           const SizedBox(width: 8),
    //                           const Text(
    //                             'Business Tags',
    //                             style: TextStyle(
    //                               fontSize: 16,
    //                               fontWeight: FontWeight.w500,
    //                             ),
    //                           ),
    //                           if (selectedTags.isNotEmpty) ...[
    //                             const SizedBox(width: 8),
    //                             Container(
    //                               padding: const EdgeInsets.symmetric(
    //                                 horizontal: 8,
    //                                 vertical: 2,
    //                               ),
    //                               decoration: BoxDecoration(
    //                                 color: Colors.blue[50],
    //                                 borderRadius: BorderRadius.circular(12),
    //                               ),
    //                               child: Text(
    //                                 '${selectedTags.length} selected',
    //                                 style: TextStyle(
    //                                   fontSize: 12,
    //                                   color: Colors.blue[700],
    //                                 ),
    //                               ),
    //                             ),
    //                           ],
    //                         ],
    //                       ),
    //                       children: [
    //                         Padding(
    //                           padding: const EdgeInsets.only(
    //                             left: 12,
    //                             right: 12,
    //                             bottom: 16,
    //                           ),
    //                           child: Column(
    //                             children: [
    //                               TextField(
    //                                 controller: _tagController,
    //                                 decoration: InputDecoration(
    //                                   hintText: 'Search business tags',
    //                                   contentPadding:
    //                                       const EdgeInsets.symmetric(
    //                                     horizontal: 12,
    //                                     vertical: 8,
    //                                   ),
    //                                   border: OutlineInputBorder(
    //                                     borderRadius: BorderRadius.circular(8),
    //                                     borderSide: BorderSide(
    //                                         color: Colors.grey[300]!),
    //                                   ),
    //                                   enabledBorder: OutlineInputBorder(
    //                                     borderRadius: BorderRadius.circular(8),
    //                                     borderSide: BorderSide(
    //                                         color: Colors.grey[300]!),
    //                                   ),
    //                                 ),
    //                                 onChanged: (value) {
    //                                   if (value.endsWith(' ')) {
    //                                     final tag = value.trim();
    //                                     if (tag.isNotEmpty) {
    //                                       setState(() {
    //                                         if (!selectedTags.contains(tag)) {
    //                                           selectedTags.add(tag);
    //                                         }
    //                                         _tagController.clear();
    //                                         businessTagSearch = null;
    //                                       });
    //                                     }
    //                                   } else {
    //                                     setState(() {
    //                                       businessTagSearch = value;
    //                                     });
    //                                   }
    //                                 },
    //                               ),
    //                               const SizedBox(height: 12),
    //                               if (selectedTags.isNotEmpty)
    //                                 Wrap(
    //                                   spacing: 8,
    //                                   runSpacing: 8,
    //                                   children: selectedTags
    //                                       .map((tag) => Chip(
    //                                             label: Text(tag),
    //                                             deleteIcon: const Icon(
    //                                                 Icons.close,
    //                                                 size: 16),
    //                                             onDeleted: () {
    //                                               setState(() {
    //                                                 selectedTags.remove(tag);
    //                                               });
    //                                             },
    //                                             backgroundColor:
    //                                                 Colors.blue[50],
    //                                             side: BorderSide(
    //                                                 color: Colors.blue[200]!),
    //                                             labelStyle: TextStyle(
    //                                                 color: Colors.blue[700]),
    //                                           ))
    //                                       .toList(),
    //                                 ),
    //                               const SizedBox(height: 12),
    //                               if (businessTagSearch?.isNotEmpty ?? false)
    //                                 Consumer(
    //                                   builder: (context, ref, child) {
    //                                     final asyncBusinessTags = ref.watch(
    //                                       searchBusinessTagsProvider(
    //                                           search: businessTagSearch),
    //                                     );
    //                                     return asyncBusinessTags.when(
    //                                       data: (businessTags) {
    //                                         log('Business tags response: $businessTags');
    //                                         if (businessTags.isEmpty)
    //                                           return const SizedBox.shrink();
    //                                         return Container(
    //                                           constraints: const BoxConstraints(
    //                                             maxHeight: 250,
    //                                           ),
    //                                           decoration: BoxDecoration(
    //                                             color: kWhite,
    //                                             borderRadius:
    //                                                 BorderRadius.circular(8),
    //                                             boxShadow: [
    //                                               BoxShadow(
    //                                                 color: Colors.grey
    //                                                     .withOpacity(0.1),
    //                                                 spreadRadius: 1,
    //                                                 blurRadius: 4,
    //                                                 offset: const Offset(0, 2),
    //                                               ),
    //                                             ],
    //                                           ),
    //                                           child: ListView.builder(
    //                                             shrinkWrap: true,
    //                                             padding: EdgeInsets.zero,
    //                                             itemCount: businessTags.length,
    //                                             itemBuilder: (context, index) {
    //                                               final tag =
    //                                                   businessTags[index];
    //                                               log('Building tag at index $index: $tag');
    //                                               return Material(
    //                                                 color: Colors.transparent,
    //                                                 child: InkWell(
    //                                                   onTap: () {
    //                                                     setState(() {
    //                                                       if (selectedTags
    //                                                           .contains(tag)) {
    //                                                         selectedTags
    //                                                             .remove(tag);
    //                                                       } else {
    //                                                         selectedTags
    //                                                             .add(tag ?? '');
    //                                                       }
    //                                                       _tagController
    //                                                           .clear();
    //                                                       businessTagSearch =
    //                                                           null;
    //                                                     });
    //                                                     ref
    //                                                         .read(
    //                                                             peopleNotifierProvider
    //                                                                 .notifier)
    //                                                         .setTags(
    //                                                             selectedTags);
    //                                                   },
    //                                                   child: Padding(
    //                                                     padding:
    //                                                         const EdgeInsets
    //                                                             .symmetric(
    //                                                       horizontal: 12,
    //                                                       vertical: 8,
    //                                                     ),
    //                                                     child: Row(
    //                                                       children: [
    //                                                         Icon(
    //                                                           selectedTags
    //                                                                   .contains(
    //                                                                       tag)
    //                                                               ? Icons
    //                                                                   .check_circle
    //                                                               : Icons.tag,
    //                                                           size: 16,
    //                                                           color: selectedTags
    //                                                                   .contains(
    //                                                                       tag)
    //                                                               ? Colors
    //                                                                   .blue[700]
    //                                                               : Colors.grey[
    //                                                                   600],
    //                                                         ),
    //                                                         const SizedBox(
    //                                                             width: 8),
    //                                                         Text(
    //                                                           tag ?? '',
    //                                                           style: TextStyle(
    //                                                             color: selectedTags
    //                                                                     .contains(
    //                                                                         tag)
    //                                                                 ? Colors.blue[
    //                                                                     700]
    //                                                                 : Colors.grey[
    //                                                                     800],
    //                                                             fontSize: 14,
    //                                                           ),
    //                                                         ),
    //                                                       ],
    //                                                     ),
    //                                                   ),
    //                                                 ),
    //                                               );
    //                                             },
    //                                           ),
    //                                         );
    //                                       },
    //                                       loading: () => const Center(
    //                                         child: Padding(
    //                                           padding: EdgeInsets.all(8.0),
    //                                           child: LoadingAnimation(),
    //                                         ),
    //                                       ),
    //                                       error: (_, __) =>
    //                                           const SizedBox.shrink(),
    //                                     );
    //                                   },
    //                                 ),
    //                             ],
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ),

    //             // Apply Button
    //             const SizedBox(height: 16),
    //             SizedBox(
    //                 width: double.infinity,
    //                 child: customButton(
    //                   label: 'Apply',
    //                   onPressed: () {
    //                     setState(() {
    //                       selectedDistrictId = tempDistrictId;
    //                       selectedDistrictName = tempDistrictName;
    //                     });

    //                     final notifier =
    //                         ref.read(peopleNotifierProvider.notifier);
    //                     notifier.setDistrict(tempDistrictId);
    //                     notifier.setTags(selectedTags);

    //                     Navigator.pop(context);
    //                   },
    //                 )),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    final users = ref.watch(membersNotifierProvider);
    final isLoading = ref.read(membersNotifierProvider.notifier).isLoading;
    final isFirstLoad = ref.read(membersNotifierProvider.notifier).isFirstLoad;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
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
                            fillColor: kInputFieldcolor,
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
                      )

                      // const SizedBox(width: 8),
                      // Container(
                      //   decoration: BoxDecoration(
                      //     border: Border.all(
                      //       color: const Color.fromARGB(255, 216, 211, 211),
                      //     ),
                      //     borderRadius: BorderRadius.circular(8.0),
                      //   ),
                      //   child: IconButton(
                      //     icon: Icon(
                      //       Icons.filter_list,
                      //       color: selectedDistrictName != null
                      //           ? Colors.blue
                      //           : Colors.grey,
                      //     ),
                      //     onPressed: _showFilterBottomSheet,
                      //   ),
                      // ),
                    ],
                  ),
                  // if (selectedDistrictName != null || selectedTags.isNotEmpty)
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 8.0),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Wrap(
                  //         spacing: 8,
                  //         runSpacing: 8,
                  //         children: [
                  //           if (selectedDistrictName != null)
                  //             Chip(
                  //               label: Text(selectedDistrictName!),
                  //               onDeleted: () {
                  //                 setState(() {
                  //                   selectedDistrictId = null;
                  //                   selectedDistrictName = null;
                  //                 });
                  //                 ref
                  //                     .read(membersNotifierProvider.notifier)
                  //                     .setDistrict(null);
                  //               },
                  //             ),
                  //           ...selectedTags.map((tag) => Chip(
                  //                 label: Text(tag),
                  //                 onDeleted: () {
                  //                   setState(() {
                  //                     selectedTags.remove(tag);
                  //                   });
                  //                   ref
                  //                       .read(membersNotifierProvider.notifier)
                  //                       .setTags(selectedTags);
                  //                 },
                  //               )),
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (isFirstLoad)
              const Center(child: LoadingAnimation())
            else if (users.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: users.length + (isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == users.length) {
                    return const Center(child: LoadingAnimation());
                  }
                  final user = users[index];

                  final userId = user.id ?? '';
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(user: user),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        ListTile(
                          tileColor: kStrokeColor,
                          leading: SizedBox(
                            height: 40,
                            width: 40,
                            child: ClipOval(
                              child: Image.network(
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius:
                                            BorderRadius.circular(8.0),
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
                            style: kSmallTitleR.copyWith(
                                color: kSecondaryTextColor),
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
                                final chatApi =
                                    ref.read(chatApiServiceProvider);
                                final conversation = await chatApi
                                    .create1to1Conversation(userId);
                                Navigator.of(context)
                                    .pop();
                                if (conversation != null) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ChatScreen(
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
                          thickness: .5,
                          color: kPrimaryColor,
                          height: 1,
                        ),
                      ],
                    ),
                  );
                },
              )
            else
              Column(
                children: [
                  SizedBox(height: 100),
                  Center(
                    child: Text(
                      'No Members Found',
                      style: kSubHeadingL,
                    ),
                  ),
                ],
              ),
          ],
        ),
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
