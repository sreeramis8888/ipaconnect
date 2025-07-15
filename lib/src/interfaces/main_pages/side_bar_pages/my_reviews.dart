import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/models/rating_model.dart';
import 'package:ipaconnect/src/data/notifiers/rating_notifier.dart';
import 'package:ipaconnect/src/data/services/navigation_service.dart';
import 'package:ipaconnect/src/data/utils/get_time_ago.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_round_button.dart';
import 'package:ipaconnect/src/interfaces/components/loading/loading_indicator.dart';

class MyReviewsPage extends ConsumerStatefulWidget {
  const MyReviewsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<MyReviewsPage> createState() => _MyReviewsPageState();
}

class _MyReviewsPageState extends ConsumerState<MyReviewsPage> {
  String _selectedType = 'All';
  final List<String> _types = ['All', 'Company', 'Product'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchRatings();
    });
  }

  void _fetchRatings({bool reset = true}) {
    final notifier = ref.read(ratingNotifierProvider.notifier);
    if (reset) {
      notifier.pageNo = 1;
      notifier.ratings = [];
      notifier.hasMore = true;
      notifier.isFirstLoad = true;
    }
    String type = _selectedType.toLowerCase();
    notifier.fetchMoreMyRatings(
        entityType: type == 'all' ? 'all' : type.capitalize());
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(ratingNotifierProvider.notifier);
    final ratings = ref.watch(ratingNotifierProvider);
    final isLoading = notifier.isLoading && notifier.isFirstLoad;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: CustomRoundButton(
              offset: const Offset(4, 0),
              iconPath: 'assets/svg/icons/arrow_back_ios.svg',
            ),
          ),
        ),
        scrolledUnderElevation: 0,
        title: Text('My Reviews',
            style: kBodyTitleB.copyWith(color: kSecondaryTextColor)),
        backgroundColor: kBackgroundColor,
        iconTheme: const IconThemeData(color: kSecondaryTextColor),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _types.map((type) {
                final bool isSelected = _selectedType == type;
                return GestureDetector(
                  onTap: () {
                    if (!isSelected) {
                      setState(() {
                        _selectedType = type;
                      });
                      _fetchRatings();
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? kPrimaryColor : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? kPrimaryColor : kStrokeColor,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      type,
                      style: TextStyle(
                        color: isSelected ? Colors.white : kSecondaryTextColor,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: LoadingAnimation())
                : ratings.isEmpty
                    ? Center(
                        child: Text('No reviews found', style: kBodyTitleR))
                    : Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: ratings.length,
                              itemBuilder: (context, index) {
                                return _reviewTile(ratings[index]);
                              },
                            ),
                          ),
                          if (notifier.hasMore && !notifier.isLoading)
                            TextButton(
                              onPressed: () => _fetchRatings(reset: false),
                              child: const Text('Load more'),
                            ),
                          if (notifier.isLoading && !notifier.isFirstLoad)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: LoadingAnimation(),
                            ),
                        ],
                      ),
          ),
        ],
      ),
    );
  }

  Widget _reviewTile(RatingModel rating) {
    return GestureDetector(
      onTap: () {
        NavigationService navigationService = NavigationService();
        navigationService.pushNamed('ProfilePreviewById',
            arguments: rating.user.id);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: kCardBackgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: kPrimaryColor.withOpacity(0.15),
              radius: 20,
              child: rating.user.image != null && rating.user.image != ''
                  ? Icon(Icons.person, color: kPrimaryColor)
                  : Image.network(
                      rating.user.image ?? '',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                          width: 80,
                          height: 80,
                          color: kCardBackgroundColor,
                          child: Icon(Icons.person, color: kPrimaryColor)),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  rating.user.name ?? '',
                                  style: kBodyTitleSB.copyWith(
                                    color: kWhite,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Row(
                                  children: List.generate(
                                    5,
                                    (i) => Icon(
                                      i < rating.rating
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: Colors.lightBlueAccent,
                                      size: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Text(
                        timeAgo(rating.createdAt),
                        style: kSmallerTitleR.copyWith(
                          color: kSecondaryTextColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    rating.review,
                    style: kBodyTitleR.copyWith(
                      color: kSecondaryTextColor,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension StringCasingExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }
}
