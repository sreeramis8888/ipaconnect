import 'package:flutter/material.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingAnimation extends StatelessWidget {
  final double size;

  const LoadingAnimation({super.key, this.size = 30});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: LoadingIndicator(
        indicatorType: Indicator.lineSpinFadeLoader,
        colors: const [kPrimaryColor],
        strokeWidth: 2,
   
   
      ),
    );
  }
}
