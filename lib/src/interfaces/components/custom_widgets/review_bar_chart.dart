import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/models/rating_model.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_button.dart';

Map<int, int> getRatingDistribution(List<RatingModel> reviews) {
  Map<int, int> distribution = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
  for (var review in reviews) {
    distribution[review.rating] = (distribution[review.rating] ?? 0) + 1;
  }
  return distribution;
}

double getAverageRating(List<RatingModel> reviews) {
  if (reviews.isEmpty) return 0.0;
  int totalRating = reviews.fold(0, (sum, review) => sum + review.rating);
  return totalRating / reviews.length;
}

class ReviewBarChart extends StatelessWidget {
  final List<RatingModel> reviews;
  final VoidCallback? onViewAll;
  final VoidCallback? onWriteReview;
  const ReviewBarChart({
    super.key,
    required this.reviews,
    this.onViewAll,
    this.onWriteReview,
  });

  @override
  Widget build(BuildContext context) {
    final ratingDistribution = getRatingDistribution(reviews);
    final averageRating = getAverageRating(reviews);
    final totalReviews = reviews.length;
    final orange = Color(0xFFF9A63D);
    final lightBlue = Color(0xFFAEB9E1).withOpacity(.09);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Ratings & Reviews ($totalReviews)',
                style: TextStyle(
                  color: kWhite,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
            GestureDetector(
              onTap: onViewAll,
              child: Text(
                'View All',
                style: TextStyle(
                  color: kSecondaryTextColor,
                  fontSize: 12,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                children: List.generate(5, (index) {
                  int starCount = 5 - index;
                  int reviewCount = ratingDistribution[starCount] ?? 0;
                  double percentage =
                      totalReviews > 0 ? reviewCount / totalReviews : 0;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 16,
                          child: Text(
                            '$starCount',
                            style: TextStyle(
                              color: kSecondaryTextColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Stack(
                            children: [
                              Container(
                                height: 8,
                                decoration: BoxDecoration(
                                  color: lightBlue,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              FractionallySizedBox(
                                widthFactor: percentage,
                                child: Container(
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: orange,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      averageRating.toStringAsFixed(1),
                      style: const TextStyle(
                        color: kWhite,
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                        textBaseline: TextBaseline.alphabetic,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.star, color: orange, size: 22),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '$totalReviews Reviews',
                  style: TextStyle(
                    color: kSecondaryTextColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        customButton(
          label: 'Write a review',
          buttonColor: Color(0xFF1A3353),
          labelColor: kWhite,
          onPressed: onWriteReview,
        ),
      ],
    );
  }
}
