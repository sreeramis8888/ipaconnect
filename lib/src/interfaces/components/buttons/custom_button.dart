import 'package:flutter/material.dart';

const Color defaultGradientEnd = Color(0xFF00C0F3);
const Color defaultGradientStart = Color(0xFF0D74BC);

Widget customButton({
  required String label,
  required Function()? onPressed,
  Color labelColor = Colors.white,
  int fontSize = 16,
  int buttonHeight = 45,
  bool isLoading = false,
  Color? buttonColor,
  Gradient? gradient,
  Color sideColor = Colors.transparent,
}) {
  final Gradient effectiveGradient = gradient ??
      const LinearGradient(
        stops: [0.1, 0.8],
        colors: [defaultGradientStart, defaultGradientEnd],
      );

  return SizedBox(
    height: buttonHeight.toDouble(),
    width: double.infinity,
    child: InkWell(
      onTap: isLoading || onPressed == null ? null : onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Ink(
        decoration: BoxDecoration(
          gradient: gradient == null ? effectiveGradient : gradient,
          color: gradient == null ? null : buttonColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: sideColor),
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(labelColor),
                  ),
                )
              : Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: labelColor,
                    fontSize: fontSize.toDouble(),
                  ),
                ),
        ),
      ),
    ),
  );
}
