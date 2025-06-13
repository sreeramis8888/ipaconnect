import 'package:flutter/material.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';

Widget customButton({
  required String label,
  required Function()? onPressed,
  Color sideColor = kPrimaryLightColor,
  Color labelColor = kWhite,
  int fontSize = 16,
  int buttonHeight = 45,
  Color buttonColor = kPrimaryLightColor,
  bool isLoading = false,
}) {
  return SizedBox(
    height: buttonHeight.toDouble(),
    width: double.infinity,
    child: ElevatedButton(
      onPressed: isLoading || onPressed == null
          ? null
          : () {
              final result = onPressed();
              if (result is Future) {
                result.then((_) {});
              }
            },
      style: ButtonStyle(
        elevation: WidgetStateProperty.all<double>(0),
        backgroundColor: WidgetStateProperty.all<Color>(buttonColor),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: sideColor),
          ),
        ),
      ),
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
                fontWeight: FontWeight.w500,
                color: labelColor,
                fontSize: double.parse(fontSize.toString()),
              ),
            ),
    ),
  );
}
