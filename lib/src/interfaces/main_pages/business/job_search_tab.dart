import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/notifiers/job_profiles_notifier.dart';
import 'package:ipaconnect/src/data/models/job_profile_model.dart';
import 'package:ipaconnect/src/interfaces/components/cards/job_profile_card.dart';
import 'package:ipaconnect/src/interfaces/components/loading/loading_indicator.dart';
import 'package:ipaconnect/src/interfaces/components/modals/job_filter_modal.dart';

class JobSearchTab extends ConsumerStatefulWidget {
  const JobSearchTab({super.key});

  @override
  ConsumerState<JobSearchTab> createState() => _JobSearchTabState();
}

class _JobSearchTabState extends ConsumerState<JobSearchTab> {
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;
  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);
    _fetchInitialFeeds();
  }

  Future<void> _fetchInitialFeeds() async {
    await ref.read(jobProfilesNotifierProvider.notifier).fetchMoreJobProfiles();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(jobProfilesNotifierProvider.notifier).fetchMoreJobProfiles();
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      ref.read(jobProfilesNotifierProvider.notifier).searchJobProfiles(query);
    });
  }

  void _onSearchSubmitted(String query) {
    ref.read(jobProfilesNotifierProvider.notifier).searchJobProfiles(query);
  }

  @override
  Widget build(BuildContext context) {
    final jobProfiles = ref.watch(jobProfilesNotifierProvider);
    final notifier = ref.read(jobProfilesNotifierProvider.notifier);
    final isLoading = notifier.isLoading;
    final isFirstLoad = notifier.isFirstLoad;

    return Container(
      color: kBackgroundColor,
      child: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: kCardBackgroundColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Icon(Icons.search,
                        color: kSecondaryTextColor, size: 22),
                  ),
                  Expanded(
                    child: TextField(
                      onChanged: _onSearchChanged,
                      onSubmitted: _onSearchSubmitted,
                      style: kBodyTitleR.copyWith(color: kWhite),
                      decoration: InputDecoration(
                        hintText: 'Search Profile',
                        hintStyle:
                            kBodyTitleR.copyWith(color: kSecondaryTextColor),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  // Filter button
                  // IconButton(
                  //   icon: const Icon(Icons.filter_alt_outlined, color: kSecondaryTextColor, size: 24),
                  //   onPressed: () async {
                  //     final filters = await showModalBottomSheet<Map<String, dynamic>>(
                  //       context: context,
                  //       backgroundColor: Colors.transparent,
                  //       isScrollControlled: true,
                  //       builder: (context) => const JobFilterModal(),
                  //     );
                  //     if (filters != null) {
                  //       ref.read(jobProfilesNotifierProvider.notifier).refreshJobProfiles(
                  //         category: filters['category'],
                  //         experience: filters['experience'],
                  //         noticePeriod: filters['noticePeriod'],
                  //         location: filters['location'],
                  //         search: filters['search'],
                  //       );
                  //     }
                  //   },
                  // ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: isFirstLoad
                ? const Center(child: LoadingAnimation())
                : jobProfiles.isEmpty
                    ? const Center(
                        child: Text('No job profiles found',
                            style: TextStyle(color: kWhite)))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        itemCount: jobProfiles.length + (isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == jobProfiles.length && isLoading) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: LoadingAnimation(),
                              ),
                            );
                          }
                          if (index < jobProfiles.length) {
                            final profile = jobProfiles[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: JobProfileCard(profile: profile),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
