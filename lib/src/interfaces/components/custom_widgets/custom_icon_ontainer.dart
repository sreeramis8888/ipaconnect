import 'package:flutter/material.dart';
class CustomIconContainer extends StatelessWidget {
  final Widget icon;
  final String label;
  final double size;

  const CustomIconContainer({
    super.key,
    required this.icon,
    required this.label,
    this.size = 80.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        gradient: const RadialGradient(
          center: Alignment.topLeft,
          radius: 1.2,
          colors: [
            Colors.white,
            Color(0xFFE5E7EB),
          ],
          stops: [0.0, 1.0],
        ),
        border: Border.all(
          color: const Color(0xFF1789FF).withOpacity(0.1),
          width: 1.06,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF9CA3AF),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
