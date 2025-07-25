import 'package:flutter/material.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/interfaces/components/shimmers/custom_shimmer.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String iconUrl;

  final int count;

  const CategoryCard({
    Key? key,
    required this.title,
    required this.iconUrl,
    required this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kCardBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: kStrokeColor,
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          // Count badge
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                count.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  child: Center(
                    child: ClipOval(
                      child: Image.network(
                        iconUrl,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;

                          return ClipOval(
                              child: ShimmerContainer(
                            width: 64,
                            height: 64,
                          ));
                        },
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.image,
                            color: Colors.white,
                            size: 32,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(title,
                    textAlign: TextAlign.center,
                    style: kSmallTitleR.copyWith(color: Color(0xFFF7F7F7))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
