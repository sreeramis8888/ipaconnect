import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/services/navigation_service.dart';
import 'package:ipaconnect/src/data/notifiers/hierarchyUsers_notifier.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_button.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_round_button.dart';
import 'package:ipaconnect/src/interfaces/components/loading/loading_indicator.dart';
import 'create_notification_page.dart';

class HierarchyMembers extends ConsumerStatefulWidget {
  final String hierarchyName;
  final String hierarchyId;
  const HierarchyMembers(
      {super.key, required this.hierarchyId, required this.hierarchyName});

  @override
  ConsumerState<HierarchyMembers> createState() => _HierarchyMembersState();
}

class _HierarchyMembersState extends ConsumerState<HierarchyMembers> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    ref
        .read(hierarchyusersNotifierProvider.notifier)
        .fetchMoreHierarchyUsers(hierarchyId: widget.hierarchyId);

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final notifier = ref.read(hierarchyusersNotifierProvider.notifier);
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !notifier.isLoading &&
        notifier.hasMore) {
      notifier.fetchMoreHierarchyUsers(hierarchyId: widget.hierarchyId);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await ref
        .read(hierarchyusersNotifierProvider.notifier)
        .refreshHierarchyUsers(hierarchyId: widget.hierarchyId);
  }

  @override
  Widget build(BuildContext context) {
    NavigationService navigationService = NavigationService();
    final users = ref.watch(hierarchyusersNotifierProvider);
    final notifier = ref.read(hierarchyusersNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
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
        scrolledUnderElevation: 0,
        title: Text(
          "Members",
          style: kBodyTitleR.copyWith(color: kSecondaryTextColor),
        ),
        centerTitle: false,
        backgroundColor: kBackgroundColor,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: RefreshIndicator(
        backgroundColor: kCardBackgroundColor,
        onRefresh: _onRefresh,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.hierarchyName,
                      style: kSmallTitleL,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 120,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: customButton(
                          fontSize: 14,
                          buttonHeight: 30,
                          labelColor: kPrimaryColor,
                          label: 'Get Activity',
                          onPressed: () {
                            navigationService.pushNamed('ActivityPage',
                                arguments: widget.hierarchyId);
                          },
                          buttonColor: kCardBackgroundColor,
                          sideColor: kPrimaryColor),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Expanded(
                child: users.isEmpty && notifier.isLoading
                    ? const Center(child: LoadingAnimation())
                    : users.isEmpty
                        ? const Center(child: Text('NO MEMBERS'))
                        : ListView.builder(
                            controller: _scrollController,
                            itemCount:
                                users.length + (notifier.hasMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index < users.length) {
                                final member = users[index];
                                return Card(
                                  elevation: 0.1,
                                  color: kCardBackgroundColor,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: ListTile(
                                    tileColor: kCardBackgroundColor,
                                    leading: CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(member.image ?? ''),
                                    ),
                                    title: Text(
                                      member.name ?? '',
                                      style: kSmallTitleL,
                                    ),
                                    subtitle: Text(
                                      (member.companies != null &&
                                              member.companies!.isNotEmpty)
                                          ? (member.companies!.first.name ??
                                              ' ')
                                          : " ",
                                      style: TextStyle(
                                          color: kSecondaryTextColor,
                                          fontSize: 12),
                                    ),
                                    trailing: Icon(Icons.arrow_forward_ios),
                                    onTap: () {
                                      print(member.companies);

                                      navigationService.pushNamed(
                                          'ProfilePreview',
                                          arguments: member);
                                    },
                                  ),
                                );
                              } else {
                                // Show loading indicator at the end
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Center(child: LoadingAnimation()),
                                );
                              }
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => CreateNotificationPage(
      //           hierarchyId: widget.hierarchyId,
      //           hierarchyName: widget.hierarchyName,
      //         ),
      //       ),
      //     );
      //   },
      //   backgroundColor: kPrimaryColor,
      //   child: const Icon(Icons.notifications_active_outlined, color: kWhite),
      // ),
    );
  }
}
