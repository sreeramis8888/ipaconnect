import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ipaconnect/src/data/models/product_model.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/notifiers/products_notifier.dart';
import 'package:ipaconnect/src/data/utils/globals.dart';

import 'package:ipaconnect/src/interfaces/components/buttons/custom_round_button.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_button.dart';
import 'package:ipaconnect/src/interfaces/components/loading/loading_indicator.dart';
import 'package:ipaconnect/src/interfaces/components/shimmers/custom_shimmer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/notifiers/rating_notifier.dart';
import 'package:ipaconnect/src/data/models/rating_model.dart';

import 'package:ipaconnect/src/interfaces/components/custom_widgets/star_rating.dart';
import 'package:ipaconnect/src/interfaces/components/modals/add_review_modal.dart';
import 'package:ipaconnect/src/data/services/api_routes/chat_api/chat_api_service.dart';
import 'package:ipaconnect/src/interfaces/main_pages/people/chat_screen.dart';

class ProductDetailsPage extends ConsumerStatefulWidget {
  final String category;
  final ProductModel product;
  final String companyUserId;
  const ProductDetailsPage(
      {super.key, required this.product, required this.category,required this.companyUserId, });

  @override
  ConsumerState<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends ConsumerState<ProductDetailsPage> {
  int _currentIndex = 0;
  late final PageController _pageController;
  bool _showReviews = false;
  int _reviewsToShow = 3;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // Refresh ratings for this product
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ratingNotifierProvider.notifier).refreshRatings(
        entityId: widget.product.id ?? '',
        entityType: 'Product',
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final images = product.images;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
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
        title: Text('View Product',
            style:
                kBodyTitleR.copyWith(fontSize: 16, color: kSecondaryTextColor)),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Images - Scrollable
            Container(
              width: double.infinity,
              height: 200,
              color: kCardBackgroundColor,
              child: images.isNotEmpty
                  ? PageView.builder(
                      controller: _pageController,
                      itemCount: images.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        final imageUrl = images[index].url;
                        return AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;

                              return ShimmerContainer(
                                width: double.infinity,
                                height: double.infinity,
                                borderRadius: BorderRadius.zero,
                              );
                            },
                            errorBuilder: (_, __, ___) => Center(
                              child: Icon(Icons.broken_image,
                                  color: kSecondaryTextColor, size: 60),
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Icon(Icons.image,
                          color: kSecondaryTextColor, size: 60),
                    ),
            ),
            // Dots indicator (animated)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(images.isNotEmpty ? images.length : 1,
                    (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: index == _currentIndex ? 20 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: index == _currentIndex
                          ? Colors.white
                          : Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
              ),
            ),
            // Product Info
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Product Information',
                      style: kBodyTitleB.copyWith(fontSize: 16)),
                  SizedBox(height: 6),
                  if (product.specifications.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: product.specifications
                          .map((spec) => Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('• ',
                                      style: TextStyle(
                                          color: kSecondaryTextColor)),
                                  Expanded(
                                      child: Text(spec,
                                          style: TextStyle(
                                              color: kSecondaryTextColor,
                                              fontWeight: FontWeight.w200))),
                                ],
                              ))
                          .toList(),
                    )
                  else
                    Text('-',
                        style: TextStyle(
                            color: kSecondaryTextColor,
                            fontWeight: FontWeight.w200)),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(FontAwesomeIcons.userTie,
                          color: kSecondaryTextColor, size: 14),
                      SizedBox(width: 6),
                      Text(
                        product.user.name,
                        style: kBodyTitleR.copyWith(
                            color: kSecondaryTextColor, fontSize: 13),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(0xFF1A233A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.category ?? '',
                      style: kBodyTitleR.copyWith(
                          color: Colors.white, fontSize: 11),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        '₹${product.actualPrice.toStringAsFixed(0)}',
                        style: kBodyTitleR.copyWith(
                          color: kPrimaryColor,
                          fontSize: 16,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: kPrimaryColor,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '₹${product.discountPrice.toStringAsFixed(0)}',
                        style: kBodyTitleB.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text('Ratings', style: kBodyTitleB.copyWith(fontSize: 15)),
                  Consumer(
                    builder: (context, ref, _) {
                      final ratings = ref.watch(ratingNotifierProvider);
                      final ratingNotifier =
                          ref.watch(ratingNotifierProvider.notifier);
                      double avgRating = 0;
                      if (ratings.isNotEmpty && ratingNotifier.isFirstLoad) {
                        avgRating = ratings
                                .map((r) => r.rating)
                                .fold(0, (a, b) => a + b) /
                            ratings.length;
                      } else {
                        avgRating = product.rating ?? 0;
                      }
                      return StarRating(
                        rating: avgRating,
                        size: 20,
                        showNumber: true,
                        color: Colors.amber,
                        numberStyle: kBodyTitleR.copyWith(fontSize: 14),
                      );
                    },
                  ),
                  SizedBox(height: 4),
                  !_showReviews
                      ? Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _showReviews = true;
                                // Optionally, trigger fetchMoreRatings here
                              });
                            },
                            icon: Icon(Icons.arrow_drop_down,
                                color: kPrimaryColor),
                            label: Text('View Reviews',
                                style:
                                    kBodyTitleR.copyWith(color: kPrimaryColor)),
                          ),
                        )
                      : _buildReviewsSection(context),
                  SizedBox(height: 24),
                  if(id!=widget.companyUserId)
                  customButton(
                    label: 'Enquire Now',
                    onPressed: () async {
                      // Show loading dialog
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => const Center(child: LoadingAnimation()),
                      );

                      try {
                        final chatApi = ref.read(chatApiServiceProvider);
                        final conversation = await chatApi.create1to1Conversation(product.user.id ?? '');
                        
                        Navigator.of(context).pop(); // Close loading dialog
                        
                        if (conversation != null) {
                          // Navigate to chat screen
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                conversationId: conversation.id ?? '',
                                chatTitle: product.user.name ?? '',
                                userId: product.user.id ?? '',
                                initialProductInquiry: {
                                  'product': product,
                                  'category': widget.category,
                                },
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Failed to start chat.'),
                              backgroundColor: kRed,
                            ),
                          );
                        }
                      } catch (e) {
                        Navigator.of(context).pop(); // Close loading dialog
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error: $e'),
                            backgroundColor: kRed,
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsSection(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final notifier = ref.read(ratingNotifierProvider.notifier);
        final ratings = ref.watch(ratingNotifierProvider);
        if (notifier.isFirstLoad) {
          notifier.fetchMoreRatings(
              entityId: widget.product.id ?? '', entityType: 'Product');
          return Center(child: LoadingAnimation());
        }
        if (ratings.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('No reviews yet', style: kBodyTitleR),
              SizedBox(height: 8),
              _addReviewButton(context, notifier, ref),
            ],
          );
        }
        final reviewsToDisplay = ratings.take(_reviewsToShow).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...reviewsToDisplay.map((rating) => _reviewTile(rating)).toList(),
            if (_reviewsToShow < ratings.length)
              TextButton(
                onPressed: () {
                  setState(() {
                    _reviewsToShow += 3;
                  });
                },
                child: Text('View More'),
              ),
            if (notifier.hasMore)
              TextButton(
                onPressed: () => notifier.fetchMoreRatings(
                    entityId: widget.product.id ?? '', entityType: 'Product'),
                child: Text('Load more'),
              ),
            SizedBox(height: 8),
            _addReviewButton(context, notifier, ref),
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
                    Text(rating.user.name ?? '',
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

  Widget _addReviewButton(
      BuildContext context, RatingNotifier notifier, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: customButton(
        label: 'Write a Review',
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: kCardBackgroundColor,
          builder: (context) => AddReviewModal(
            onSubmitted: () async {
              // After review is added, update product rating locally
              final ratings = ref.read(ratingNotifierProvider);
              if (ratings.isNotEmpty) {
                final avgRating =
                    ratings.map((r) => r.rating).fold(0, (a, b) => a + b) /
                        ratings.length;
                ref.read(productsNotifierProvider.notifier).updateProductRating(
                      productId: widget.product.id,
                      newRating: avgRating,
                    );
              }
            },
            entityId: widget.product.id,
            entityType: 'Product',
            notifier: notifier,
          ),
        ),
        buttonColor: kStrokeColor,
      ),
    );
  }
}
