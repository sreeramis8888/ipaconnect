import 'package:flutter/material.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/services/navigation_service.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../data/constants/color_constants.dart';

class ApprovalWaitingPage extends StatelessWidget {
  const ApprovalWaitingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: kBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: kBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 130,
              height: 130,
              child: LoadingIndicator(
                indicatorType: Indicator.ballRotateChase,
                colors: [kPrimaryColor],
                strokeWidth: 2,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Your request to join has been sent',
              textAlign: TextAlign.center,
              style: kHeadTitleB,
            ),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Access to the app will be made available to you soon! Thank you for your patience.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Color(0xFFAEB9E1)),
              ),
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () {
                NavigationService().pushNamedReplacement('PhoneNumber');
              },
              icon: Icon(Icons.logout, color: kPrimaryColor),
              label: Text(
                'Logout',
                style: kSmallTitleB.copyWith(color: kPrimaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
