import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/models/company_model.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/notifiers/products_notifier.dart';
import 'package:ipaconnect/src/data/utils/youtube_player.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_round_button.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_button.dart';
import 'package:ipaconnect/src/interfaces/components/cards/ProductCard.dart';
import 'package:ipaconnect/src/interfaces/components/loading/loading_indicator.dart';
import 'package:ipaconnect/src/interfaces/components/modals/add_product_modal_sheet.dart';
import 'package:ipaconnect/src/data/utils/globals.dart' as globals;
import 'package:ipaconnect/src/data/notifiers/rating_notifier.dart';
import 'package:ipaconnect/src/data/models/rating_model.dart';
import 'package:ipaconnect/src/data/services/api_routes/rating_api/rating_api_service.dart';
import 'package:ipaconnect/src/interfaces/components/custom_widgets/star_rating.dart';

class CompanyDetailsPage extends ConsumerStatefulWidget {
  final CompanyModel company;
  const CompanyDetailsPage({super.key, required this.company});

  @override
  ConsumerState<CompanyDetailsPage> createState() => _CompanyDetailsPageState();
}

class _CompanyDetailsPageState extends ConsumerState<CompanyDetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController.addListener(_onScroll);
    _fetchInitialProducts();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    final company = widget.company;
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
              expandedHeight: 210,
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
                background: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 100, bottom: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
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
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Static Category Badge
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
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            // Static Rating Row
                            StarRating(
                              rating: company.rating ?? 0,
                              size: 14,
                              showNumber: true,
                              color: Colors.amber,
                              numberStyle: TextStyle(
                                color: kSecondaryTextColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 4),
                            // Company Name
                            Text(
                              company.name ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: kBodyTitleB.copyWith(
                                  fontSize: 18, color: Colors.white),
                            ),
                            const SizedBox(height: 4),
                            // Status
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
                    ],
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
                      fontWeight: FontWeight.w300, color: kSecondaryTextColor)))
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
        // Opening Hours
        Text('Opening Hours', style: kBodyTitleB),
        const SizedBox(height: 4),
        _buildOpeningHours(),
        const SizedBox(height: 16),
        // Photo Gallery (Placeholder)
        Text('Photo Gallery', style: kBodyTitleB),
        const SizedBox(height: 4),
        _buildPhotoGallery(),
        const SizedBox(height: 16),
        // Video Gallery (Placeholder)
        Text('Video Gallery', style: kBodyTitleB),
        const SizedBox(height: 4),
        _buildVideoGallery(),
        const SizedBox(height: 16),
        // Reviews (Placeholder)
        Text('Reviews', style: kBodyTitleB),
        const SizedBox(height: 4),
        _buildReviews(),
      ],
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
          return ClipRRect(
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
              child: YouTubePlayerWidget(
                  videoId: extractVideoId(v.url ?? '') ?? '')))
          .toList(),
    );
  }

  Widget _buildReviews() {
    return Consumer(
      builder: (context, ref, _) {
        final notifier = ref.read(ratingNotifierProvider.notifier);
        final ratings = ref.watch(ratingNotifierProvider);
        if (notifier.isFirstLoad) {
          notifier.fetchMoreRatings(
              entityId: widget.company.id ?? '', entityType: 'Company');
          return Center(child: LoadingAnimation());
        }
        if (ratings.isEmpty) {
          return Column(
            children: [
              Text('No reviews yet', style: kBodyTitleR),
              SizedBox(height: 8),
              _addReviewButton(context, notifier),
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...ratings.map((rating) => _reviewTile(rating)).toList(),
            if (notifier.hasMore)
              TextButton(
                onPressed: () => notifier.fetchMoreRatings(
                    entityId: widget.company.id ?? '', entityType: 'Company'),
                child: Text('Load more'),
              ),
            SizedBox(height: 8),
            _addReviewButton(context, notifier),
          ],
        );
      },
    );
  }

  Widget _reviewTile(RatingModel rating) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kCardBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kPrimaryColor.withOpacity(0.15), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: kPrimaryColor.withOpacity(0.15),
            child: Icon(Icons.person, color: kPrimaryColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(rating.userName,
                        style: kBodyTitleSB.copyWith(color: kWhite)),
                    const SizedBox(width: 8),
                    Text(
                      '${rating.createdAt.toLocal()}'.split(' ')[0],
                      style:
                          kSmallerTitleR.copyWith(color: kSecondaryTextColor),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: List.generate(
                      5,
                      (i) => Icon(
                            i < rating.rating
                                ? Icons.star_rounded
                                : Icons.star_border_rounded,
                            color: Colors.amber,
                            size: 18,
                          )),
                ),
                const SizedBox(height: 6),
                Text(
                  rating.review,
                  style: kBodyTitleR.copyWith(color: kSecondaryTextColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _addReviewButton(BuildContext context, RatingNotifier notifier) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: customButton(
        label: 'Add Review',
        icon: Icon(Icons.rate_review, color: kWhite, size: 20),
        onPressed: () => _showAddReviewModal(context, notifier),
        buttonColor: kPrimaryColor,
        labelColor: kWhite,
        fontSize: 15,
        buttonHeight: 44,
      ),
    );
  }

  void _showAddReviewModal(BuildContext context, RatingNotifier notifier) {
    final _formKey = GlobalKey<FormState>();
    int _rating = 0;
    String _review = '';
    showModalBottomSheet(
      backgroundColor: kCardBackgroundColor,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 24,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                    child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                            color: kGreyDark,
                            borderRadius: BorderRadius.circular(2)))),
                SizedBox(height: 16),
                Center(child: Text('Add Review', style: kBodyTitleB)),
                SizedBox(height: 18),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                        5,
                        (i) => IconButton(
                              icon: Icon(
                                i < _rating
                                    ? Icons.star_rounded
                                    : Icons.star_border_rounded,
                                color: Colors.amber,
                                size: 28,
                              ),
                              splashRadius: 20,
                              onPressed: () {
                                _rating = i + 1;
                                (context as Element).markNeedsBuild();
                              },
                            )),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Write your review',
                    labelStyle:
                        kBodyTitleR.copyWith(color: kSecondaryTextColor),
                    filled: true,
                    fillColor: kBackgroundColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: kPrimaryColor.withOpacity(0.2)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: kPrimaryColor.withOpacity(0.2)),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  ),
                  maxLines: 3,
                  style: kBodyTitleR.copyWith(color: kWhite),
                  onChanged: (val) => _review = val,
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Enter review' : null,
                ),
                SizedBox(height: 18),
                customButton(
                  label: 'Submit',
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await notifier.addRating(
                        userId: 'userId',
                        userName: 'User',
                        targetId: widget.company.id ?? '',
                        targetType: 'Company',
                        rating: _rating,
                        review: _review,
                      );
                      Navigator.pop(context);
                      await notifier.refreshRatings(
                          entityId: widget.company.id ?? '',
                          entityType: 'Company');
                    }
                  },
                  buttonColor: kPrimaryColor,
                  labelColor: kWhite,
                  fontSize: 16,
                  buttonHeight: 44,
                ),
                SizedBox(height: 18),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductsTab(BuildContext context) {
    final products = ref.watch(productsNotifierProvider);
    final isLoading = ref.read(productsNotifierProvider.notifier).isLoading;
    final isFirstLoad = ref.read(productsNotifierProvider.notifier).isFirstLoad;
    final isOwner = widget.company.user?.id == globals.id;
    // Example categories, replace with real data if needed
    final categories = <String>[widget.company.category ?? 'General'];
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              // Search Bar
              TextField(
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
              const SizedBox(height: 16),
              // Product Grid
              isFirstLoad
                  ? const Center(child: LoadingAnimation())
                  : products.isEmpty
                      ? Expanded(
                          child: Center(
                            child: Text(
                              'No Products yet',
                              style: kSmallTitleR,
                            ),
                          ),
                        )
                      : Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 220,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio: 0.50,
                            ),
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              final product = products[index];
                              return ProductCard(
                                category: widget.company.category ?? '',
                                product: product,
                              );
                            },
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
    );
  }
}
