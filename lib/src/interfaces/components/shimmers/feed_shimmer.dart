import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';

class FeedShimmer extends StatelessWidget {
  const FeedShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Shimmer.fromColors(
        baseColor: kCardBackgroundColor,
        highlightColor: kStrokeColor,
        child: Container(
          margin: const EdgeInsets.only(
            bottom: 20.0,
          ),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: kCardBackgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar, name, time
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 100,
                          height: 12,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: 60,
                          height: 10,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Post content
              Container(
                width: double.infinity,
                height: 14,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                height: 14,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                height: 14,
                color: Colors.white,
              ),
              const SizedBox(height: 16),
              // Post image
              Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 16),
              // Action buttons row
              Row(
                children: [
                  Container(width: 30, height: 30, color: Colors.white),
                  const SizedBox(width: 24),
                  Container(width: 30, height: 30, color: Colors.white),
                  const SizedBox(width: 24),
                  Container(width: 30, height: 30, color: Colors.white),
                  const Spacer(),
                  Container(width: 29, height: 29, color: Colors.white),
                ],
              ),
              const SizedBox(height: 16),
              // Add comment section
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 120,
                    height: 14,
                    color: Colors.white,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
