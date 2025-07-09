import 'package:flutter/material.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:shimmer/shimmer.dart';

class EditUserShimmer extends StatelessWidget {
  const EditUserShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: Colors.grey.shade400),
            onPressed: () {},
          ),
        ],
        backgroundColor: kBackgroundColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Profile Picture with Edit Icon
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                _buildShimmerCircle(radius: 60),
              ],
            ),
            const SizedBox(height: 20),

            const SizedBox(height: 90),
            // Personal Details Form Fields
            _buildShimmerField(),
            const SizedBox(height: 20),
            _buildShimmerField(),
            const SizedBox(height: 20),
            _buildShimmerField(),
            const SizedBox(height: 20),
            _buildShimmerField(),
            const SizedBox(height: 20),
            _buildShimmerField(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerCircle({double radius = 25}) {
    return Shimmer.fromColors(
      baseColor: kCardBackgroundColor,
      highlightColor: kStrokeColor,
      child: Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          color: kCardBackgroundColor,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildShimmerLine(
      {double width = double.infinity, double height = 16}) {
    return Shimmer.fromColors(
      baseColor: kCardBackgroundColor,
      highlightColor: kStrokeColor,
      child: Container(
        width: width,
        height: height,
        color: kCardBackgroundColor,
      ),
    );
  }

  Widget _buildShimmerField({double height = 50}) {
    return Shimmer.fromColors(
      baseColor: kCardBackgroundColor,
      highlightColor: kStrokeColor,
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: kCardBackgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
