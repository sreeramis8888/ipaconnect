import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/interfaces/main_pages/people/chat_dash.dart';
import 'package:ipaconnect/src/interfaces/main_pages/people/members.dart';
import 'people/feed.dart';

class PeoplePage extends ConsumerWidget {
  const PeoplePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: kBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, 4),
                      blurRadius: 6,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: const TabBar(
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
                  unselectedLabelStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  tabs: [
                    Tab(text: "Feed"),
                    Tab(text: "Members"),
                    Tab(text: "Chat"),
                  ],
                ),
              ),

              // Tab content
              Expanded(
                child: TabBarView(
                  children: [FeedView(), MembersPage(), ChatDash()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
