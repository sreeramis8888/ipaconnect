import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'people/feed.dart';

class PeoplePage extends ConsumerWidget {
  const PeoplePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final userAsync = ref.watch(userProvider);
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   userAsync.whenOrNull(data: (user) {
    //     if (user.status == 'trial') {
    //       showDialog(
    //         context: context,
    //         builder: (_) => const PremiumDialog(),
    //       );
    //     }
    //   });
    // });

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: kWhite,
        appBar: AppBar(
          backgroundColor: kWhite,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              const Icon(
                Icons.people,
                color: kPrimaryColor,
                size: 30,
              ),
              const SizedBox(width: 12),
              const Text(
                'Community',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
              decoration: const BoxDecoration(
                color: kWhite,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 4), 
                    blurRadius: 6, 
                    spreadRadius: 0, 
                  ),
                ],
              ),
              child: TabBar(
                indicatorColor: kPrimaryColor,
                indicatorSize: TabBarIndicatorSize.tab,
                enableFeedback: true,
                indicatorWeight: 3,
                isScrollable: false,
                labelColor: kPrimaryColor,
                unselectedLabelColor: Colors.grey,
                labelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                tabs: const [
                  Tab(text: "Feed"),
                  Tab(text: "Members"),
                  Tab(text: "Chat"),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            const FeedView(),
            const Text(''),
            Text(''),
          ],
        ),
      ),
    );
  }
}
