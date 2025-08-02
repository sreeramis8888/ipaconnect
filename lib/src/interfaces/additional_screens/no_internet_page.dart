import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';

class NoInternetPage extends StatelessWidget {
  const NoInternetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // App Logo
              SvgPicture.asset(
                'assets/svg/ipaconnect_logo.svg',
                height: 90,
              ),
              const SizedBox(height: 36),
              // No Internet Icon
              Container(
                decoration: BoxDecoration(
                  color: kCardBackgroundColor,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: kBlack.withOpacity(0.15),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(32),
                child: Icon(
                  Icons.wifi_off,
                  color: kRed,
                  size: 64,
                ),
              ),
              const SizedBox(height: 36),
              // Main Title
              Text(
                'No Internet Connection',
                style: kDisplayTitleSB.copyWith(color: kWhite),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Subtitle
              Text(
                'It looks like you are offline.\nPlease check your network settings.\nWe will reconnect automatically.',
                style: kBodyTitleR.copyWith(color: kSecondaryTextColor),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 