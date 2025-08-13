import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/models/company_model.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/notifiers/products_notifier.dart';
import 'package:ipaconnect/src/data/utils/image_viewer.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_round_button.dart';
import 'package:ipaconnect/src/interfaces/components/cards/ProductCard.dart';
import 'package:ipaconnect/src/interfaces/components/custom_widgets/custom_video.dart';
import 'package:ipaconnect/src/interfaces/components/loading/loading_indicator.dart';
import 'package:ipaconnect/src/interfaces/components/modals/add_product_modal_sheet.dart';
import 'package:ipaconnect/src/data/utils/globals.dart' as globals;
import 'package:ipaconnect/src/data/notifiers/rating_notifier.dart';
import 'package:ipaconnect/src/interfaces/components/custom_widgets/star_rating.dart';
import 'package:ipaconnect/src/interfaces/components/modals/add_review_modal.dart';
import 'package:ipaconnect/src/interfaces/components/custom_widgets/review_bar_chart.dart';
import 'package:ipaconnect/src/data/notifiers/companies_notifier.dart';
import 'company_reviews_page.dart';
import 'package:ipaconnect/main.dart';
import 'package:ipaconnect/src/interfaces/components/animations/staggered_entrance.dart';

class CompanyDetailsPage extends ConsumerStatefulWidget {
  final CompanyModel company;
  const CompanyDetailsPage({super.key, required this.company});

  @override
  ConsumerState<CompanyDetailsPage> createState() => _CompanyDetailsPageState();
}

class _CompanyDetailsPageState extends ConsumerState<CompanyDetailsPage>
    with SingleTickerProviderStateMixin, RouteAware {
  late TabController _tabController;
  Timer? _debounce;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController.addListener(_onScroll);
    _fetchInitialProducts();
    // Refresh ratings for this company
    WidgetsBinding.instance.addPostFrameCallback((_) {
      routeObserver.subscribe(this, ModalRoute.of(context)!);
      ref.read(ratingNotifierProvider.notifier).refreshRatings(
            entityId: widget.company.id ?? '',
            entityType: 'Company',
          );
    });
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didPopNext() {
    // Called when coming back to this page
    ref.read(ratingNotifierProvider.notifier).refreshRatings(
          entityId: widget.company.id ?? '',
          entityType: 'Company',
        );
  }

  Future<void> _fetchInitialProducts() async {
    await ref
        .read(productsNotifierProvider.notifier)
        .fetchMoreProducts(widget.company.id);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref
          .read(productsNotifierProvider.notifier)
          .fetchMoreProducts(widget.company.id);
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      ref
          .read(productsNotifierProvider.notifier)
          .searchProducts(query, companyId: widget.company.id ?? '');
    });
  }

  void _onSearchSubmitted(String query) {
    ref
        .read(productsNotifierProvider.notifier)
        .searchProducts(query, companyId: widget.company.id ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final company = widget.company;
    final screenHeight = MediaQuery.of(context).size.height;
    double expandedHeight = screenHeight < 700 ? 280 : 220;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              backgroundColor: kBackgroundColor,
              elevation: 0,
              pinned: true,
              expandedHeight: expandedHeight,
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
              title: Text(
                company.name ?? '',
                style: TextStyle(
                  color: kSecondaryTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              centerTitle: false,
              flexibleSpace: FlexibleSpaceBar(
                background: StartupStagger(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 100,
                      bottom: 16,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StaggerItem(
                          order: 0,
                          from: SlideFrom.left,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: kCardBackgroundColor,
                              image: company.image != null
                                  ? DecorationImage(
                                      image: NetworkImage(company.image!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: company.image == null
                                ? Icon(Icons.business,
                                    size: 40, color: kSecondaryTextColor)
                                : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: StaggerItem(
                            order: 1,
                            from: SlideFrom.bottom,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF1A233A),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    company.category ?? '',
                                    style: TextStyle(
                                      color: kWhite,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Consumer(
                                  builder: (context, ref, _) {
                                    final ratings = ref.watch(ratingNotifierProvider);
                                    double avgRating = ratings.isNotEmpty
                                        ? ratings
                                                .map((r) => r.rating)
                                                .fold(0, (a, b) => a + b) /
                                            ratings.length
                                        : (company.rating ?? 0);
                                    return StarRating(
                                      rating: avgRating,
                                      size: 14,
                                      showNumber: true,
                                      color: Colors.amber,
                                      numberStyle: TextStyle(
                                        color: kSecondaryTextColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(height: 4),
                                Text(
                                  company.name ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: kBodyTitleB.copyWith(
                                      fontSize: 18, color: kWhite),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  company.status == 'active'
                                      ? '• Active'
                                      : '• Inactive',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: company.status == 'active'
                                        ? Color(0xFF00D615)
                                        : Colors.red,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              bottom: TabBar(
                controller: _tabController,
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
                tabs: const [
                  Tab(text: 'Company Overview'),
                  Tab(text: 'Products'),
                ],
              ),
            ),
          ],
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildOverviewTab(context),
              _buildProductsTab(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewTab(BuildContext context) {
    final company = widget.company;
    return Consumer(
      builder: (context, ref, _) {
        final notifier = ref.read(ratingNotifierProvider.notifier);
        final ratings = ref.watch(ratingNotifierProvider);
        // Fetch ratings if not already loaded
        if (notifier.isFirstLoad) {
          notifier.fetchMoreRatings(
              entityId: company.id ?? '', entityType: 'Company');
        }
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            const SizedBox(height: 16),
            // Company Overview
            Text('Company Overview', style: kBodyTitleB),
            const SizedBox(height: 4),
            Text(company.overview ?? '-',
                style: TextStyle(
                    fontWeight: FontWeight.w300, color: kSecondaryTextColor)),
            const SizedBox(height: 16),
            // Industry
            Text('Industry', style: kBodyTitleB),
            const SizedBox(height: 4),
            Text(company.category ?? '-',
                style: TextStyle(
                    fontWeight: FontWeight.w300, color: kSecondaryTextColor)),
            const SizedBox(height: 16),
            // Services
            Text('Services', style: kBodyTitleB),
            const SizedBox(height: 4),
            if (company.services != null && company.services!.isNotEmpty)
              ...company.services!
                  .map((s) => Text('• $s',
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: kSecondaryTextColor)))
                  .toList()
            else
              Text('-', style: kBodyTitleR),
            const SizedBox(height: 16),
            // Location (Map Placeholder)
            Text('Location', style: kBodyTitleB),
            const SizedBox(height: 4),
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: kCardBackgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  company.contactInfo?.address ?? '-',
                  style: kBodyTitleR,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Website
            Text('Website', style: kBodyTitleB),
            const SizedBox(height: 4),
            Text(company.contactInfo?.website ?? 'Link',
                style: TextStyle(color: kSecondaryTextColor)),
            const SizedBox(height: 16),
            // Established
            Text('Established', style: kBodyTitleB),
            const SizedBox(height: 4),
            Text(
                company.establishedDate != null
                    ? '${company.establishedDate!.year}'
                    : '-',
                style: TextStyle(color: kSecondaryTextColor)),
            const SizedBox(height: 16),
            // Team Size
            Text('Team Size', style: kBodyTitleB),
            const SizedBox(height: 4),
            Text(company.companySize ?? '-',
                style: TextStyle(color: kSecondaryTextColor)),
            const SizedBox(height: 16),
            Text('Opening Hours', style: kBodyTitleB),
            const SizedBox(height: 4),
            _buildOpeningHours(),
            const SizedBox(height: 16),
            Text('Photo Gallery', style: kBodyTitleB),
            const SizedBox(height: 4),
            _buildPhotoGallery(),
            const SizedBox(height: 16),
            Text('Video Gallery', style: kBodyTitleB),
            const SizedBox(height: 4),
            _buildVideoGallery(),
            const SizedBox(height: 16),

            ReviewBarChart(
              reviews: ratings,
              onViewAll: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CompanyReviewsPage(company: company),
                  ),
                );
              },
              onWriteReview: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: kCardBackgroundColor,
                  builder: (context) => AddReviewModal(
                    entityId: company.id ?? '',
                    entityType: 'Company',
                    notifier: notifier,
                    onSubmitted: () async {
                      final ratings = ref.read(ratingNotifierProvider);
                      if (ratings.isNotEmpty) {
                        final avgRating = ratings
                                .map((r) => r.rating)
                                .fold(0, (a, b) => a + b) /
                            ratings.length;
                        ref
                            .read(companiesNotifierProvider.notifier)
                            .updateCompanyRating(
                              companyId: company.id ?? '',
                              newRating: avgRating,
                            );
                      }
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }

  Widget _buildOpeningHours() {
    final oh = widget.company.openingHours;
    if (oh == null) return Text('-', style: kBodyTitleR);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (oh.sunday != null)
          Text('Sunday: ${oh.sunday}',
              style: TextStyle(color: kSecondaryTextColor)),
        if (oh.monday != null)
          Text('Monday: ${oh.monday}',
              style: TextStyle(color: kSecondaryTextColor)),
        if (oh.tuesday != null)
          Text('Tuesday: ${oh.tuesday}',
              style: TextStyle(color: kSecondaryTextColor)),
        if (oh.wednesday != null)
          Text('Wednesday: ${oh.wednesday}',
              style: TextStyle(color: kSecondaryTextColor)),
        if (oh.thursday != null)
          Text('Thursday: ${oh.thursday}',
              style: TextStyle(color: kSecondaryTextColor)),
        if (oh.friday != null)
          Text('Friday: ${oh.friday}',
              style: TextStyle(color: kSecondaryTextColor)),
        if (oh.saturday != null)
          Text('Saturday: ${oh.saturday}',
              style: TextStyle(color: kSecondaryTextColor)),
      ],
    );
  }

  Widget _buildPhotoGallery() {
    final photos = widget.company.gallery?.photos;
    if (photos == null || photos.isEmpty) {
      return Text('No photos available',
          style: TextStyle(color: kSecondaryTextColor));
    }
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: photos.length,
        separatorBuilder: (_, __) => SizedBox(width: 8),
        itemBuilder: (context, index) {
          final photo = photos[index];
          return InkWell(
            onTap: () => showImageViewer(photo.url ?? '', context),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                photo.url ?? '',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 80,
                  height: 80,
                  color: kCardBackgroundColor,
                  child: Icon(Icons.broken_image, color: kSecondaryTextColor),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVideoGallery() {
    final videos = widget.company.gallery?.videos;
    if (videos == null || videos.isEmpty) {
      return Text('No videos available', style: kBodyTitleR);
    }
    // Placeholder: just show video URLs as text
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: videos
          .map((v) => Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: customVideo(context: context, videoUrl: v.url ?? '')))
          .toList(),
    );
  }

  Widget _buildProductsTab(BuildContext context) {
    final products = ref.watch(productsNotifierProvider);
    final isLoading = ref.read(productsNotifierProvider.notifier).isLoading;
    final isFirstLoad = ref.read(productsNotifierProvider.notifier).isFirstLoad;
    final isOwner = widget.company.user?.id == globals.id;
    final categories = <String>[widget.company.category ?? 'General'];
    return StartupStagger(
      child: Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              // Search Bar
              StaggerItem(
                order: 0,
                from: SlideFrom.left,
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
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    filled: true,
                    fillColor: kCardBackgroundColor,
                    prefixIcon: const Icon(
                      Icons.search,
                      size: 20,
                      color: kSecondaryTextColor,
                    ),
                    hintText: 'Search Products',
                    hintStyle:  kSmallTitleL.copyWith(color: kSecondaryTextColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Product Grid
              isFirstLoad
                  ? const Center(child: LoadingAnimation())
                  : products.isEmpty
                      ? Expanded(
                          child: Center(
                            child: Text(
                              'No Products yet',
                              style: kSmallTitleL,
                            ),
                          ),
                        )
                      : Expanded(
                          child: StaggerItem(
                            order: 1,
                            from: SlideFrom.bottom,
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 220,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                childAspectRatio: MediaQuery.of(context)
                                        .size
                                        .width /
                                    (MediaQuery.of(context).size.height / 1.1),
                              ),
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                final product = products[index];
                                return StaggerItem(
                                  order: 2 + (index % 8),
                                  from: SlideFrom.bottom,
                                  child: ProductCard(
                                    companyUserId: widget.company.user?.id ?? '',
                                    category: widget.company.category ?? '',
                                    product: product,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
            ],
          ),
        ),
        if (isOwner)
          Positioned(
            bottom: 24,
            right: 24,
            child: FloatingActionButton(
              backgroundColor: kPrimaryColor,
              child: const Icon(Icons.add, color: kWhite),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => AddProductModalSheet(
                    categories: categories,
                    companyId: widget.company.id ?? '',
                  ),
                );
              },
            ),
          ),
      ],
    ),
    );
  }
}
