import 'package:flutter/material.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';

class CustomIconContainer extends StatelessWidget {
  final Widget icon;
  final String label;
  final double size;
  final VoidCallback? onTap;

  const CustomIconContainer({
    super.key,
    required this.icon,
    required this.label,
    this.size = 80.0,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size - 5,
        height: size + 10,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              // Color(0x802EA7FF),
              Color(0xFF10243F),
              // Color(0x331C1B33),
              Color(0xFF1C3559), 
            ],
            stops: [0.0, .7],
          ),
          border: Border.all(
            color: 
            // Color(0x1A17B9FF),
            Color(0x33FFFFFF),
            width: 1,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x6617B9FF), 
              blurRadius: 8,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            if (label != '') const SizedBox(height: 4),
            if (label != '')
              Text(
                maxLines: 2,
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: kSecondaryTextColor,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
    );
  }
}
