import 'package:flutter/material.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/interfaces/components/loading/loading_indicator.dart';

const Color defaultGradientEnd = Color(0xFF00C0F3);
const Color defaultGradientStart = Color(0xFF0D74BC);

Widget customButton({
  required String label,
  required Function()? onPressed,
  Color labelColor = kWhite,
  int fontSize = 14,
  int buttonHeight = 45,
  bool isLoading = false,
  Color? buttonColor,
  Gradient? gradient,
  Color sideColor = Colors.transparent,
  Widget? icon,
}) {
  final Gradient effectiveGradient = const LinearGradient(
    stops: [0.4, .9],
    colors: [Color(0xFF1E3A81), Color(0xFF355BBB)],
  );

  final BorderRadius borderRadius = BorderRadius.circular(8);
  final bool useDefaultGradient = gradient == null && buttonColor == null;

  return SizedBox(
    height: buttonHeight.toDouble(),
    width: double.infinity,
    child: Material(
      color: Colors.transparent,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: isLoading || onPressed == null ? null : onPressed,
        borderRadius: borderRadius,
        child: Ink(
          decoration: BoxDecoration(
            gradient:
                gradient ?? (useDefaultGradient ? effectiveGradient : null),
            color:
                (gradient == null && buttonColor != null) ? buttonColor : null,
            borderRadius: borderRadius,
            border: Border.all(color: sideColor),
          ),
          child: Center(
            child: isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: LoadingAnimation(),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        icon,
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
