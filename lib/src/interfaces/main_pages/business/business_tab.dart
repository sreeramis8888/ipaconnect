import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/notifiers/business_category_notifier.dart';
import 'package:ipaconnect/src/data/services/navigation_service.dart';
import 'package:ipaconnect/src/interfaces/components/cards/business_category_card.dart';
import 'package:ipaconnect/src/interfaces/components/loading/loading_indicator.dart';

class BusinessCategoryTab extends ConsumerStatefulWidget {
  const BusinessCategoryTab({super.key});

  @override
  ConsumerState<BusinessCategoryTab> createState() =>
      _BusinessCategoryTabState();
}

class _BusinessCategoryTabState extends ConsumerState<BusinessCategoryTab> {
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchInitialCategories();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      ref
          .read(businessCategoryNotifierProvider.notifier)
          .searchCategories(query);
    });
  }

  void _onSearchSubmitted(String query) {
    ref.read(businessCategoryNotifierProvider.notifier).searchCategories(query);
  }

  Future<void> _fetchInitialCategories() async {
    await ref
        .read(businessCategoryNotifierProvider.notifier)
        .fetchMoreCategories();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(businessCategoryNotifierProvider.notifier).fetchMoreCategories();
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(businessCategoryNotifierProvider);
    final isLoading =
        ref.read(businessCategoryNotifierProvider.notifier).isLoading;
    final isFirstLoad =
        ref.read(businessCategoryNotifierProvider.notifier).isFirstLoad;

    return Column(
      children: [
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: _onSearchChanged,
                  onSubmitted: _onSearchSubmitted,
                  cursorColor: kWhite,
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
                    hintText: 'Search Categories',
                    hintStyle: kBodyTitleR.copyWith(
                      fontSize: 14,
                      color: kSecondaryTextColor,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        isFirstLoad
            ? Expanded(child: const Center(child: LoadingAnimation()))
            : categories.isEmpty
                ? Expanded(
                    child: Center(
                      child: Text(
                        'No Categories yet',
                        style: kSmallTitleR,
                      ),
                    ),
                  )
                : Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: GridView.builder(
                        controller: _scrollController,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: categories.length + (isLoading ? 2 : 0),
                        itemBuilder: (context, index) {
                          if (index == categories.length && isLoading) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: LoadingAnimation(),
                              ),
                            );
                          }
                          if (index < categories.length) {
                            final category = categories[index];
                            return GestureDetector(
                              onTap: () {
                                NavigationService navigationService =
                                    NavigationService();
                                navigationService.pushNamed('CategoryPage',
                                    arguments: category);
                              },
                              child: CategoryCard(
                                title: category.name,
                                iconUrl: category.icon ?? '',
                                count: category.companyCount ?? 0,
                              ),
                            );
                          }

                          // Fallback (shouldn't reach here)
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
      ],
    );
  }
}
