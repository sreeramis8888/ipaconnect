import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';

class CustomRoundButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String iconPath;
  final Color iconColor;
  final Offset offset;
  final double padding;

  const CustomRoundButton({
    super.key,
    required this.iconPath,
    this.onTap,
    this.iconColor = const Color(0xFFAEB9E1),
    this.offset = const Offset(0, 0),
    this.padding = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color.fromARGB(255, 1, 17, 36),
            kCardBackgroundColor,
          ],
          stops: const [0.1, 0.5],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border.all(color: kStrokeColor),
        borderRadius: BorderRadius.circular(30),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Transform.translate(
            offset: offset,
            child: SvgPicture.asset(
              iconPath,
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }
}
