import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final double rating;
  final int starCount;
  final double size;
  final Color color;
  final Color? emptyColor;
  final bool showNumber;
  final TextStyle? numberStyle;

  const StarRating({
    Key? key,
    required this.rating,
    this.starCount = 5,
    this.size = 18,
    this.color = Colors.amber,
    this.emptyColor,
    this.showNumber = false,
    this.numberStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> stars = [];
    for (int i = 0; i < starCount; i++) {
      final double starValue = i + 1;
      if (rating >= starValue) {
        stars.add(Icon(Icons.star, color: color, size: size));
      } else if (rating >= starValue - 0.5) {
        stars.add(Icon(Icons.star_half, color: color, size: size));
      } else {
        stars.add(Icon(Icons.star_border, color: emptyColor ?? color.withOpacity(0.3), size: size));
      }
    }
    if (showNumber) {
      stars.add(SizedBox(width: 6));
      stars.add(Text(
        rating.toStringAsFixed(1),
        style: numberStyle ?? TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: size * 0.9),
      ));
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: stars,
    );
  }
} 