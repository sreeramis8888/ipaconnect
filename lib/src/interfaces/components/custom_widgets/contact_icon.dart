import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';


class ContactIcon extends StatelessWidget {
  final IconData? icon;
  final String? svgPath;
  final Color iconColor;

  final double padding;
  final double borderRadius;
  final bool useGradient;
  final List<Color>? gradientColors;
  final double? iconSize;

  const ContactIcon({
    Key? key,
    this.icon,
    this.svgPath,
    this.iconColor = kPrimaryColor,
    this.padding = 2.0,
    this.borderRadius = 5.0,
    this.useGradient = true,
    this.gradientColors,
    this.iconSize,
  }) : assert(icon != null || svgPath != null, 'Either icon or svgPath must be provided'),
       super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: useGradient
          ? ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: gradientColors ?? [
                  const Color(0xFFE83A33),
                  const Color(0xFF96120D),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: _buildIcon(),
            )
          : _buildIcon(),
    );
  }

  Widget _buildIcon() {
    if (svgPath != null) {
      return SvgPicture.asset(
        svgPath!,
        color: useGradient ? Colors.white : iconColor,
        width: iconSize,
        height: iconSize,
      );
    } else {
      return Icon(
        icon!,
        color: useGradient ? Colors.white : iconColor,
        size: iconSize,
      );
    }
  }
}