import 'package:flutter/material.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:shimmer/shimmer.dart';

Widget buildShimmerPromotionsColumn({
  required BuildContext context,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 90),
      shimmerTop(context: context),
      const SizedBox(height: 20),
      shimmerBanner(context: context),
      const SizedBox(height: 16),
      shimmerNotice(context: context),
      const SizedBox(height: 16),
      shimmerPoster(context: context),
      const SizedBox(height: 16),
    ],
  );
}

Widget shimmerTop({
  required BuildContext context,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 20),
      Padding(
        padding: const EdgeInsets.only(left: 15, top: 10),
        child: Shimmer.fromColors(
          baseColor: kCardBackgroundColor,
          highlightColor: kStrokeColor,
          child: Container(
            height: 25,
            width: 150,
            color: kCardBackgroundColor,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 15, top: 10, bottom: 10),
        child: Shimmer.fromColors(
          baseColor: kCardBackgroundColor,
          highlightColor: kStrokeColor,
          child: Container(
            height: 20,
            width: 250,
            color: kCardBackgroundColor,
          ),
        ),
      ),
    ],
  );
}

Widget shimmerBanner({
  required BuildContext context,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Shimmer.fromColors(
      baseColor: kCardBackgroundColor,
      highlightColor: kStrokeColor,
      child: Container(
        width: MediaQuery.of(context).size.width - 32,
        height: 175,
        decoration: BoxDecoration(
          color: kCardBackgroundColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),
  );
}

Widget shimmerNotice({
  required BuildContext context,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Shimmer.fromColors(
      baseColor: kCardBackgroundColor,
      highlightColor: kStrokeColor,
      child: Container(
        width: MediaQuery.of(context).size.width - 32,
        height: 200,
        decoration: BoxDecoration(
          color: kCardBackgroundColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),
  );
}

Widget shimmerPoster({
  required BuildContext context,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Shimmer.fromColors(
      baseColor: kCardBackgroundColor,
      highlightColor: kStrokeColor,
      child: Container(
        width: MediaQuery.of(context).size.width - 32,
        height: 400,
        decoration: BoxDecoration(
          color: kCardBackgroundColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),
  );
}
