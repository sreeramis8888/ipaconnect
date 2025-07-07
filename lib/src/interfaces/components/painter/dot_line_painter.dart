import 'package:flutter/material.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const dashWidth = 5.0;
    const dashSpace = 5.0;
    final paint = Paint()
      ..color = kStrokeColor
      ..strokeWidth = 2.0;

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
