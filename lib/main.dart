import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ipaconnect/firebase_options.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/services/navigation_service.dart';
import 'package:ipaconnect/src/data/services/notification_service/notification_service.dart';
import 'package:ipaconnect/src/data/utils/install_checker.dart';
import 'package:ipaconnect/src/data/utils/secure_storage.dart';
import 'package:ipaconnect/src/data/services/snackbar_service.dart';
import 'package:ipaconnect/src/data/router/router.dart' as router;

import 'package:ipaconnect/src/data/services/crashlytics_service.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final checker = InstallChecker();
  await checker.checkFirstInstall();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  await CrashlyticsService.setCrashlyticsCollectionEnabled(true);
  await loadSecureData();
  await dotenv.load(fileName: ".env");
  FirebaseAuth.instance.setSettings(appVerificationDisabledForTesting: false);
  Stripe.publishableKey = dotenv.env['STRIPE_KEY'] ?? '';
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationService = ref.watch(notificationServiceProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      notificationService.initialize();

      final darkBg = kBackgroundColor;
      await FlutterStatusbarcolor.setStatusBarColor(darkBg);
      FlutterStatusbarcolor.setStatusBarWhiteForeground(
        useWhiteForeground(darkBg),
      );
      final navBg = kCardBackgroundColor;
      await FlutterStatusbarcolor.setNavigationBarColor(navBg);
      FlutterStatusbarcolor.setNavigationBarWhiteForeground(
        useWhiteForeground(navBg),
      );
    });

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigationService.navigatorKey,
      scaffoldMessengerKey: SnackbarService.scaffoldMessengerKey,
      onGenerateRoute: router.generateRoute,
      initialRoute: 'Splash',
      title: 'IPA',
      theme: ThemeData(
        brightness: Brightness.dark,
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      navigatorObservers: [routeObserver],
      builder: (context, child) {
        return SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: child,
          ),
        );
      },
    );
  }
}
