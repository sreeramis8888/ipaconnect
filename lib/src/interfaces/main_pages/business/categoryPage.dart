import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/models/business_category_model.dart';
import 'package:ipaconnect/src/data/notifiers/companies_notifier.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_backButton.dart';
import 'package:ipaconnect/src/interfaces/components/cards/company_card.dart';
import 'package:ipaconnect/src/interfaces/components/loading/loading_indicator.dart';
import 'package:ipaconnect/src/interfaces/main_pages/business/company_details_page.dart';

class Categorypage extends ConsumerStatefulWidget {
  final BusinessCategoryModel category;
  const Categorypage({
    super.key,
    required this.category,
  });

  @override
  ConsumerState<Categorypage> createState() => _CategorypageState();
}

class _CategorypageState extends ConsumerState<Categorypage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchInitialCompanies();
  }

  Future<void> _fetchInitialCompanies() async {
    await ref
        .read(companiesNotifierProvider.notifier)
        .fetchMoreCompanies(widget.category.id);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref
          .read(companiesNotifierProvider.notifier)
          .fetchMoreCompanies(widget.category.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final companies = ref.watch(companiesNotifierProvider);
    final isLoading = ref.read(companiesNotifierProvider.notifier).isLoading;
    final isFirstLoad =
        ref.read(companiesNotifierProvider.notifier).isFirstLoad;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: PrimaryBackButton(),
        ),
        title: Text(
          widget.category.name,
          style: TextStyle(
            color: kSecondaryTextColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
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
                      hintText: 'Search Companies',
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
          SizedBox(
            height: 20,
          ),

          isFirstLoad
              ? const Center(child: LoadingAnimation())
              : companies.isEmpty
                  ? Expanded(
                      child: Center(
                        child: Text(
                          'No Categories yet',
                          style: kSmallTitleR,
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          if (index == companies.length && isLoading) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: LoadingAnimation(),
                              ),
                            );
                          }
                          if (index < companies.length) {
                            final company = companies[index];
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              child: CompanyCard(
                                companyName: company.name ?? '',
                                rating: 4.9,
                                position: company.user?.name ?? '',
                                industry: company.category ?? '',
                                location: company.contactInfo?.address ?? '',
                                isActive:
                                    company.status == 'active' ? true : false,
                                imageUrl: company.image,
                                onViewDetails: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CompanyDetailsPage(company: company),
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                        },
                      ),
                    ),
        ],
      ),
    );
  }
}
