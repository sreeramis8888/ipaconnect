import 'package:flutter/material.dart';

const Color defaultGradientEnd = Color(0xFF00C0F3);
const Color defaultGradientStart = Color(0xFF0D74BC);
Widget customButton({
  required String label,
  required Function()? onPressed,
  Color labelColor = Colors.white,
  int fontSize = 14,
  int buttonHeight = 45,
  bool isLoading = false,
  Color? buttonColor,
  Gradient? gradient,
  Color sideColor = Colors.transparent,
  Widget? icon,
}) {
  final Gradient effectiveGradient = gradient ??
      const LinearGradient(
        stops: [0.4, .9],
        colors: [defaultGradientStart, defaultGradientEnd],
      );

  final BorderRadius borderRadius = BorderRadius.circular(8);

  return SizedBox(
    height: buttonHeight.toDouble(),
    width: double.infinity,
    child: Material(
      color: Colors.transparent, // Important to avoid white bleed
      borderRadius: borderRadius, // Apply same radius
      child: InkWell(
        onTap: isLoading || onPressed == null ? null : onPressed,
        borderRadius: borderRadius, // Apply same radius here
        child: Ink(
          decoration: BoxDecoration(
            gradient: gradient == null ? effectiveGradient : gradient,
            color: gradient == null ? null : buttonColor,
            borderRadius: borderRadius, // Apply same radius here too
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
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        icon!,
                        const SizedBox(width: 8),
                      ],
                      Text(
                        label,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: labelColor,
                          fontSize: fontSize.toDouble(),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    ),
  );
}
