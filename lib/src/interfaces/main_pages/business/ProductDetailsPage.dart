import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ipaconnect/src/data/models/product_model.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_round_button.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_button.dart';
import 'package:ipaconnect/src/interfaces/components/shimmers/custom_shimmer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/notifiers/rating_notifier.dart';
import 'package:ipaconnect/src/data/models/rating_model.dart';
import 'package:ipaconnect/src/data/services/api_routes/rating_api/rating_api_service.dart';
import 'package:ipaconnect/src/interfaces/components/custom_widgets/star_rating.dart';

class ProductDetailsPage extends StatefulWidget {
  final String category;
  final ProductModel product;
  const ProductDetailsPage(
      {super.key, required this.product, required this.category});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int _currentIndex = 0;
  late final PageController _pageController;
  bool _showReviews = false;
  int _modalRating = 5;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // Optionally, you can prefetch reviews here if desired
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
          child: CustomRoundButton(
            offset: Offset(4, 0),
            iconPath: 'assets/svg/icons/arrow_back_ios.svg',
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
                  StarRating(
                    rating: product.rating ?? 0,
                    size: 20,
                    showNumber: true,
                    color: Colors.amber,
                    numberStyle: kBodyTitleR.copyWith(fontSize: 14),
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
                            icon: Icon(Icons.arrow_drop_down, color: kPrimaryColor),
                            label: Text('View Reviews', style: kBodyTitleR.copyWith(color: kPrimaryColor)),
                          ),
                        )
                      : _buildReviewsSection(context),
                  SizedBox(height: 24),
                  customButton(
                    label: 'Enquire Now',
                    onPressed: () {},
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
          notifier.fetchMoreRatings(entityId: widget.product.id ?? '', entityType: 'Product');
          return Center(child: CircularProgressIndicator());
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
                onPressed: () => notifier.fetchMoreRatings(entityId: widget.product.id ?? '', entityType: 'Product'),
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
                      style: kSmallerTitleR.copyWith(color: kSecondaryTextColor),
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
    String _review = '';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: BoxDecoration(
                color: kCardBackgroundColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 24,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                        child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                                color: kGreyDark,
                                borderRadius: BorderRadius.circular(2)))),
                    SizedBox(height: 16),
                    Center(child: Text('Add Review', style: kLargeTitleSB)),
                    SizedBox(height: 18),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                            5,
                            (i) => IconButton(
                                  icon: Icon(
                                    i < _modalRating
                                        ? Icons.star_rounded
                                        : Icons.star_border_rounded,
                                    color: Colors.amber,
                                    size: 28,
                                  ),
                                  splashRadius: 20,
                                  onPressed: () {
                                    setModalState(() {
                                      _modalRating = i + 1;
                                    });
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
                            targetId: widget.product.id ?? '',
                            targetType: 'Product',
                            rating: _modalRating,
                            review: _review,
                          );
                          Navigator.pop(context);
                          await notifier.refreshRatings(entityId: widget.product.id ?? '', entityType: 'Product');
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
      },
    );
  }
}
