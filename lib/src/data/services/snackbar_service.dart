import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';



class SnackbarService {
  static GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
      String message) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.white),
          SizedBox(width: 10),
          Expanded(child: Text(message)),
        ],
      ),
      backgroundColor: kPrimaryColor,
      behavior:
          SnackBarBehavior.floating, 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.all(16), 
      duration: Duration(seconds: 4), 
      action: SnackBarAction(
        label: 'DISMISS',
        textColor: Colors.white,
        onPressed: () {
    
        },
      ),
    );

    log(scaffoldMessengerKey.currentState!.mounted.toString());
    return scaffoldMessengerKey.currentState!.showSnackBar(snackBar);
  }
}
