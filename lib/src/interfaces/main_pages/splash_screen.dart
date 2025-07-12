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
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_upgrade_version/flutter_upgrade_version.dart';

import '../../data/constants/color_constants.dart';
import '../../data/utils/secure_storage.dart';

class SplashScreen extends ConsumerStatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  bool isAppUpdateRequired = false;
  String isFirstLaunch = 'false';
  bool openedAppSettings = false;
  bool hasVersionCheckError = false;
  String errorMessage = '';
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _opacityAnimation;

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

    _controller.forward();

    checkFirstLaunch().then((_) {
      handlePermissions();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
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
    if (isFirstLaunch == 'true') {
      await SecureStorage.write('has_launched_before', 'true');
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
      print("FCM Token: $token");
    } catch (e) {
      print('Error getting FCM token: $e');
      fcmToken = '';
    }
  }

  void proceedWithAppFlow() {
    // checkAppVersion(context, ref).then((_) {
    //   if (!isAppUpdateRequired && !hasVersionCheckError) {
    //     initialize();
    //   }
    // });
    initialize();
  }

  // Future<void> checkAppVersion(BuildContext context, WidgetRef ref) async {
  //   try {
  //     log('Checking app version...');
  //     final apiService = ref.read(apiServiceProvider);
  //     final response = await apiService.get('/settings');
  //     log(response.data.toString());
  //     if (response.success && response.data != null) {
  //       final appVersionResponse = AppVersionResponse.fromJson(response.data!);
  //       await checkForUpdate(appVersionResponse, context);
  //     } else {
  //       log('Failed to fetch app version: ${response.statusCode}');
  //       log('Failed to fetch app version: $errorMessage');
  //       setState(() {
  //         hasVersionCheckError = true;
  //         errorMessage = 'Server is down. Please try again later.';
  //       });
  //     }
  //   } catch (e) {
  //     log('Error checking app version: $e');
  //     setState(() {
  //       hasVersionCheckError = true;
  //       errorMessage =
  //           'An error occurred while checking for updates. Please try again.';
  //     });
  //   }
  // }

  // Future<void> checkForUpdate(AppVersionResponse response, context) async {
  //   PackageInfo packageInfo = await PackageManager.getPackageInfo();
  //   final currentVersion = int.parse(packageInfo.version.split('.').join());
  //   log('Current version: $currentVersion');
  //   log('New version: ${response.version}');

  //   if (currentVersion < response.version && response.force) {
  //     isAppUpdateRequired = true;
  //     showUpdateDialog(response, context);
  //   }
  // }

  // void showUpdateDialog(AppVersionResponse response, BuildContext context) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) => AlertDialog(
  //       title: Text('Update Required'),
  //       content: Text(response.updateMessage),
  //       actions: [
  //         TextButton(
  //           onPressed: () {
  //             launchURL(response.applink);
  //           },
  //           child: Text('Update Now'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Future<void> retryVersionCheck() async {
  //   setState(() {
  //     hasVersionCheckError = false;
  //     errorMessage = '';
  //   });
  //   proceedWithAppFlow();
  // }

  Future<void> initialize() async {
    final _deepLinkService = ref.watch(deepLinkServiceProvider);
    NavigationService navigationService = NavigationService();
    await checktoken();
    Timer(Duration(seconds: 2), () async {
      if (!isAppUpdateRequired) {
        print('Logged in : $LoggedIn');
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
            navigationService.pushNamedReplacement('MySubscriptionPage');
            return;
          }
         if (user != null && user.status == 'pending') {
          NavigationService().pushNamedReplacement('ApprovalWaitingPage'); return;
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
      backgroundColor: Color(0xFF1B1E4A),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _opacityAnimation.value,
                  child: Transform.rotate(
                    angle: _rotationAnimation.value,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Container(
                        child: SvgPicture.asset(
                          'assets/svg/splash_logo.svg',
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (hasVersionCheckError)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      errorMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: null, // retryVersionCheck,
                      child: Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
