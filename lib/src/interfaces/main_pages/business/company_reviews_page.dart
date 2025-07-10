import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/models/company_model.dart';
import 'package:ipaconnect/src/data/models/rating_model.dart';
import 'package:ipaconnect/src/data/notifiers/rating_notifier.dart';
import 'package:ipaconnect/src/data/utils/get_time_ago.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_button.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_round_button.dart';
import 'package:ipaconnect/src/interfaces/components/loading/loading_indicator.dart';
import 'package:ipaconnect/src/interfaces/components/modals/add_review_modal.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';

class CompanyReviewsPage extends ConsumerWidget {
  final CompanyModel company;
  const CompanyReviewsPage({super.key, required this.company});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(ratingNotifierProvider.notifier);
    final ratings = ref.watch(ratingNotifierProvider);
    if (notifier.isFirstLoad) {
      notifier.fetchMoreRatings(
          entityId: company.id ?? '', entityType: 'Company');
      return const Center(child: LoadingAnimation());
    }
    return Scaffold(
      appBar: AppBar(
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
        scrolledUnderElevation: 0,
        title: Text('Reviews',
            style: kBodyTitleB.copyWith(color: kSecondaryTextColor)),
        backgroundColor: kBackgroundColor,
        iconTheme: IconThemeData(color: kSecondaryTextColor),
      ),
      backgroundColor: kBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ratings.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No reviews yet', style: kBodyTitleR),
                  SizedBox(height: 8),
                  _addReviewButton(context, notifier),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        ...ratings
                            .map((rating) => _reviewTile(rating))
                            .toList(),
                        if (notifier.hasMore)
                          TextButton(
                            onPressed: () => notifier.fetchMoreRatings(
                                entityId: company.id ?? '',
                                entityType: 'Company'),
                            child: Text('Load more'),
                          ),
                      ],
                    ),
                  ),
                  _addReviewButton(context, notifier),
                ],
              ),
      ),
    );
  }

  Widget _reviewTile(RatingModel rating) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
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
                          // Name and Stars in a row
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
    );
  }

  Widget _addReviewButton(BuildContext context, RatingNotifier notifier) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: customButton(
          buttonColor: kStrokeColor,
          label: 'Write a Review',
          onPressed: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: kCardBackgroundColor,
            builder: (context) => AddReviewModal(
              entityId: company.id ?? '',
              entityType: 'Company',
              notifier: notifier,
            ),
          ),
        ));
  }
}
