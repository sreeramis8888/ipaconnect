import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:ipaconnect/src/data/models/appversion_model.dart';
import 'package:ipaconnect/src/data/models/user_model.dart';
import 'package:ipaconnect/src/data/notifiers/user_notifier.dart';
import 'package:ipaconnect/src/data/services/api_service.dart';
import 'package:ipaconnect/src/data/services/deep_link_service.dart';
import 'package:ipaconnect/src/data/services/navigation_service.dart';
import 'package:ipaconnect/src/data/services/notification_service/get_fcm.dart';
import 'package:ipaconnect/src/data/utils/globals.dart';
import 'package:ipaconnect/src/data/utils/launch_url.dart';
import 'package:ipaconnect/src/data/utils/white_status_bar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_upgrade_version/flutter_upgrade_version.dart';

import '../../data/constants/color_constants.dart';
import '../../data/utils/secure_storage.dart';

class SplashScreen extends ConsumerStatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  bool isAppUpdateRequired = false;
  String isFirstLaunch = 'false';
  bool openedAppSettings = false;
  bool hasVersionCheckError = false;
  String errorMessage = '';
  late AnimationController _controller;
  late AnimationController _backgroundController;
  late AnimationController _textController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _backgroundOpacityAnimation;
  late Animation<Offset> _backgroundSlideAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<Offset> _textSlideAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1800),
    );
    _scaleAnimation = TweenSequence([
      TweenSequenceItem(
          tween: Tween(begin: 0.2, end: 1.2)
              .chain(CurveTween(curve: Curves.easeOutBack)),
          weight: 60),
      TweenSequenceItem(
          tween: Tween(begin: 1.2, end: 1.0)
              .chain(CurveTween(curve: Curves.elasticOut)),
          weight: 40),
    ]).animate(_controller);
    _rotationAnimation = Tween<double>(begin: -0.2, end: 0.0)
        .chain(CurveTween(curve: Curves.easeOutExpo))
        .animate(_controller);
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .chain(CurveTween(curve: Curves.easeIn))
        .animate(_controller);

    // Background image animations
    _backgroundController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    );
    _backgroundOpacityAnimation = Tween<double>(begin: 0.0, end: 1)
        .chain(CurveTween(curve: Curves.easeIn))
        .animate(_backgroundController);
    _backgroundSlideAnimation = Tween<Offset>(
      begin: Offset(0.0, -0.5),
      end: Offset.zero,
    )
        .chain(CurveTween(curve: Curves.easeOutCubic))
        .animate(_backgroundController);

    // Welcome text animations
    _textController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _textOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .chain(CurveTween(curve: Curves.easeIn))
        .animate(_textController);
    _textSlideAnimation = Tween<Offset>(
      begin: Offset(0.0, 0.5),
      end: Offset.zero,
    ).chain(CurveTween(curve: Curves.easeOutBack)).animate(_textController);

    _controller.forward();

    checkFirstLaunch().then((_) {
      handlePermissions();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    _backgroundController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && openedAppSettings) {
      openedAppSettings = false;
      handlePermissions();
    }
  }

  Future<void> checkFirstLaunch() async {
    isFirstLaunch = await SecureStorage.read('has_launched_before') ?? 'false';
    // Note: isFirstLaunch will be 'false' for first-time users
    // We'll set it to 'true' after they complete the intro screens

    // Start background and text animations for first-time users
    if (isFirstLaunch == 'false') {
      Future.delayed(Duration(milliseconds: 500), () {
        _backgroundController.forward();
      });
      Future.delayed(Duration(milliseconds: 1000), () {
        _textController.forward();
      });
    }
  }

  Future<void> handlePermissions() async {
    if (Platform.isIOS) {
      await handleIOSPermissions();
    } else {
      await handleAndroidPermissions();
    }
  }

  Future<void> handleIOSPermissions() async {
    final settings = await FirebaseMessaging.instance.getNotificationSettings();

    if (settings.authorizationStatus == AuthorizationStatus.notDetermined) {
      final newSettings = await FirebaseMessaging.instance.requestPermission();
      if (newSettings.authorizationStatus == AuthorizationStatus.authorized) {
        await setupFCM();
      }
    } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
      await showiOSPermissionDialog();
    } else if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      await setupFCM();
    }

    proceedWithAppFlow();
  }

  Future<void> handleAndroidPermissions() async {
    final status = await Permission.notification.status;

    if (status.isGranted) {
      await setupFCM();
      proceedWithAppFlow();
    } else if (status.isPermanentlyDenied) {
      await showAndroidPermissionDialog();
    } else {
      final result = await Permission.notification.request();
      if (result.isGranted) {
        await setupFCM();
      }
      proceedWithAppFlow();
    }
  }

  Future<void> showiOSPermissionDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Enable Notifications'),
        content: Text(
            'You have previously denied notification permissions. Please enable them in Settings.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              proceedWithAppFlow();
            },
            child: Text('Skip'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              openedAppSettings = true;
              await openAppSettings();
            },
            child: Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> showAndroidPermissionDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Enable Notifications'),
        content:
            Text('Please enable notification permissions from app settings.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              proceedWithAppFlow();
            },
            child: Text('Skip'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await openAppSettings();
            },
            child: Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> setupFCM() async {
    try {
      await getFcmToken(context);
    } catch (e) {
      print('Error getting FCM token: $e');
      fcmToken = '';
    }
  }

  void proceedWithAppFlow() {
    checkAppVersion(context, ref).then((_) {
      if (!isAppUpdateRequired && !hasVersionCheckError) {
        initialize();
      }
    });
    // Remove the unconditional initialize() call below to prevent navigation on version check error
    // initialize();
  }

  Future<void> checkAppVersion(BuildContext context, WidgetRef ref) async {
    try {
      log('Starting app version check via API /settings');
      final apiService = ref.read(apiServiceProvider);
      final response = await apiService.get('/settings');
      log('Received response from /settings API: ${response.data.toString()}');
      if (response.success && response.data != null) {
        final appVersionResponse = AppVersionResponse.fromJson(response.data!);
        log('Successfully parsed app version response');
        await checkForUpdate(appVersionResponse, context);
      } else {
        log('Failed to fetch app version: status code ${response.statusCode}');
        log('Failed to fetch app version: $errorMessage');
        setState(() {
          hasVersionCheckError = true;
          errorMessage = 'Server is down. Please try again later.';
        });
      }
    } catch (e) {
      log('Error checking app version: $e');
      setState(() {
        hasVersionCheckError = true;
        errorMessage =
            'An error occurred while checking for updates. Please try again.';
      });
    }
  }

  Future<void> checkForUpdate(AppVersionResponse response, context) async {
    log('Checking for available updates...');
    PackageInfo packageInfo = await PackageManager.getPackageInfo();
    final currentVersion = int.parse(packageInfo.version.split('.').join());
    log('Current app version: $currentVersion');
    log('Server app version: ${response.version}');
    log('Force update flag: ${response.force}');

    if (currentVersion < response.version && response.force) {
      log('App update is required. Current version: $currentVersion, New version: ${response.version}');
      // isAppUpdateRequired = true;
      showUpdateDialog(response, context);
      log('Update dialog shown to user');
    } else if (currentVersion < response.version && !response.force) {
      log('Update available but not forced. Current: $currentVersion, New: ${response.version}');
    } else {
      log('App is up to date. Current: $currentVersion, Server: ${response.version}');
    }
  }

  void showUpdateDialog(AppVersionResponse response, BuildContext context) {
    log('Displaying mandatory update dialog with message: ${response.updateMessage}');
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Update Required',style: TextStyle(color: kWhite),),
        content: Text(response.updateMessage,
        style: TextStyle(
          color: Colors.white,
        ),),
        actions: [
          TextButton(
            onPressed: () {
              log('User clicked Update Now, launching URL: ${response.applink}');
              launchURL(response.applink);
            },
            child: Text('Update Now'),
          ),
        ],
      ),
    );
  }

  Future<void> retryVersionCheck() async {
    setState(() {
      hasVersionCheckError = false;
      errorMessage = '';
    });
    proceedWithAppFlow();
  }

  Future<void> initialize() async {
    final _deepLinkService = ref.watch(deepLinkServiceProvider);
    NavigationService navigationService = NavigationService();
    await checktoken();
    Timer(Duration(seconds: 2), () async {
      if (!isAppUpdateRequired) {
        print('Logged in : $LoggedIn');
        print('First launch : $isFirstLaunch');

        // Check if it's the first launch
        if (isFirstLaunch == 'false') {
          // Show intro screens for first-time users
          navigationService.pushNamedReplacement('OnboardingScreen');
          return;
        }

        if (LoggedIn) {
          final container = ProviderContainer();
          final asyncUser = container.read(userProvider);
          UserModel? user;
          if (asyncUser is AsyncData<UserModel>) {
            user = asyncUser.value;
          } else {
            await container.read(userProvider.notifier).refreshUser();
            final refreshed = container.read(userProvider);
            if (refreshed is AsyncData<UserModel>) {
              user = refreshed.value;
            }
          }
          if (user != null && user.status == 'awaiting-payment') {
            navigationService.pushNamedReplacement('SubscriptionPage',
                arguments: user.countryCode);
            return;
          }
          if (user != null && user.status == 'pending') {
            NavigationService().pushNamedReplacement('ApprovalWaitingPage');
            return;
          }

          final pendingDeepLink = _deepLinkService.pendingDeepLink;
          if (pendingDeepLink != null) {
            navigationService.pushNamedReplacement('MainPage').then((_) {
              _deepLinkService.handleDeepLink(pendingDeepLink);
              _deepLinkService.clearPendingDeepLink();
            });
          } else {
            navigationService.pushNamedReplacement('MainPage');
          }
        } else {
          navigationService.pushNamedReplacement('PhoneNumber');
        }
      }
    });
  }

  Future<void> checktoken() async {
    String? savedtoken = await SecureStorage.read('token') ?? '';
    String? savedId = await SecureStorage.read('id') ?? '';
    log('token:$savedtoken');
    log('userId:$savedId');
    if (savedtoken != '' && savedtoken.isNotEmpty) {
      setState(() {
        LoggedIn = true;
        token = savedtoken;
        id = savedId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF1D09CD), // Fallback color matching the theme
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1D09CD),
              const Color.fromARGB(255, 33, 16, 73),
              const Color.fromARGB(255, 14, 11, 78),
            ],
          ),
          image: DecorationImage(
            image: const AssetImage('assets/pngs/subcription_bg.png'),
            fit: BoxFit.cover,
            opacity: 0.9,
          ),
        ),
        child: Stack(
          children: [
            // Animated background image for first-time users (on top)
            if (isFirstLaunch == 'false')
              AnimatedBuilder(
                animation: _backgroundController,
                builder: (context, child) {
                  return SlideTransition(
                    position: _backgroundSlideAnimation,
                    child: FadeTransition(
                      opacity: _backgroundOpacityAnimation,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          child: Image.asset(
                              'assets/splash_assets/splash_intro_bg.png'),
                        ),
                      ),
                    ),
                  );
                },
              ),
    
            // // Main logo animation
            // Align(
            //   alignment: Alignment.center,
            //   child: AnimatedBuilder(
            //     animation: _controller,
            //     builder: (context, child) {
            //       return Opacity(
            //         opacity: _opacityAnimation.value,
            //         child: Transform.rotate(
            //           angle: _rotationAnimation.value,
            //           child: Transform.scale(
            //             scale: _scaleAnimation.value,
            //             child: Container(
            //               width: 140,
            //               height: 140,
            //               child:
            //                   SvgPicture.asset('assets/svg/icons/ipa_logo.svg'),
            //             ),
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // ),
            // Main logo as GIF
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Image.asset(
                  'assets/gif/ipa_logo.gif',
                  fit: BoxFit.cover,
                ),
              ),
            ),
                
            // Welcome text for first-time users
            if (isFirstLaunch == 'false' && !hasVersionCheckError)
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 100.0),
                  child: AnimatedBuilder(
                    animation: _textController,
                    builder: (context, child) {
                      return SlideTransition(
                        position: _textSlideAnimation,
                        child: FadeTransition(
                          opacity: _textOpacityAnimation,
                          child: Text(
                            'Welcome to IPA Connect',
                            style: TextStyle(
                              color: kWhite,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
    
            // Error message overlay - positioned above welcome text when both exist
            if (hasVersionCheckError)
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: isFirstLaunch == 'false' ? 180.0 : 100.0,
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Text(
                              errorMessage,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: kWhite,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 12),
                            TextButton(
                              onPressed: retryVersionCheck,
                              style: TextButton.styleFrom(
                                backgroundColor: kWhite.withOpacity(0.2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              child: Text(
                                'Retry',
                                style: TextStyle(
                                  color: kWhite,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
