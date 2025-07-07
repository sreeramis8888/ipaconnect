import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';

class ContactIcon extends StatelessWidget {
  final IconData? icon;
  final String? svgPath;
  final Color iconColor;
  final double padding;
  final double borderRadius;
  final double? iconSize;

  const ContactIcon({
    Key? key,
    this.icon,
    this.svgPath,
    this.iconColor = kPrimaryColor,
    this.padding = 2.0,
    this.borderRadius = 5.0,
    this.iconSize = 24,
  })  : assert(icon != null || svgPath != null,
            'Either icon or svgPath must be provided'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: kStrokeColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: _buildIcon(),
      ),
    );
  }

  Widget _buildIcon() {
    if (svgPath != null) {
      return SvgPicture.asset(
        svgPath!,
        color: iconColor,
        width: iconSize,
        height: iconSize,
      );
    } else {
      return Icon(
        icon!,
        color: iconColor,
        size: iconSize,
      );
    }
  }
}
