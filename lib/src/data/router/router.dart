import 'package:flutter/material.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/models/business_category_model.dart';
import 'package:ipaconnect/src/data/models/events_model.dart';
import 'package:ipaconnect/src/data/models/user_model.dart';
import 'package:ipaconnect/src/interfaces/main_pages/analytics/analytics.dart';
import 'package:ipaconnect/src/interfaces/main_pages/analytics/create_analytics.dart';
import 'package:ipaconnect/src/interfaces/main_pages/business/categoryPage.dart';
import 'package:ipaconnect/src/interfaces/main_pages/event/event_details.dart';
import 'package:ipaconnect/src/interfaces/main_pages/event/event_member_list.dart';
import 'package:ipaconnect/src/interfaces/main_pages/event/events_page.dart';

import 'package:ipaconnect/src/interfaces/main_pages/home_page.dart';
import 'package:ipaconnect/src/interfaces/main_pages/main_page.dart';
import 'package:ipaconnect/src/interfaces/main_pages/profile/editUser.dart';
import 'package:ipaconnect/src/interfaces/main_pages/profile/preview.dart';
import 'package:ipaconnect/src/interfaces/main_pages/splash_screen.dart';
import 'package:ipaconnect/src/interfaces/main_pages/store/my_orders_page.dart';
import 'package:ipaconnect/src/interfaces/main_pages/store/store_page.dart';
import 'package:ipaconnect/src/interfaces/main_pages/store/cart_page.dart';
import 'package:ipaconnect/src/interfaces/main_pages/store/address_selection_page.dart';
import 'package:ipaconnect/src/interfaces/main_pages/store/add_address_page.dart';
import 'package:ipaconnect/src/interfaces/onboarding/approval_waiting.dart';
import 'package:ipaconnect/src/interfaces/onboarding/login.dart';

import '../../interfaces/onboarding/registration.dart';
import 'package:ipaconnect/src/interfaces/main_pages/business/ProductDetailsPage.dart';
import 'package:ipaconnect/src/interfaces/main_pages/levels/hierarchies.dart';

Route<dynamic> generateRoute(RouteSettings? settings) {
  Widget? page;
  RouteTransitionsBuilder transitionsBuilder =
      (context, animation, secondaryAnimation, child) {
    const begin = Offset(0.0, 1.0);
    const end = Offset.zero;
    const curve = Curves.easeOutCubic;
    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  };
  Duration transitionDuration = const Duration(milliseconds: 300);

  switch (settings?.name) {
    case 'Splash':
      page = SplashScreen();
      transitionsBuilder = (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      };
      transitionDuration = const Duration(milliseconds: 500);
      break;
    case 'MainPage':
      page = MainPage();
    case 'EditUser':
      page = EditUser();
    case 'SendAnalyticRequest':
      page = SendAnalyticRequestPage();
    case 'Analytics':
      page = AnalyticsPage();
      break;
    case 'PhoneNumber':
      page = PhoneNumberScreen();
      break;
    case 'RegistrationPage':
      String phone = settings?.arguments as String;
      page = RegistrationPage(phone: phone);
      transitionsBuilder = (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      };
      transitionDuration = const Duration(milliseconds: 400);
      break;
    case 'ApprovalWaitingPage':
      page = ApprovalWaitingPage();
      transitionsBuilder = (context, animation, secondaryAnimation, child) {
        return RotationTransition(
          turns: animation,
          child: child,
        );
      };
      transitionDuration = const Duration(milliseconds: 500);
      break;
    case 'CategoryPage':
      BusinessCategoryModel category =
          settings?.arguments as BusinessCategoryModel;
      page = Categorypage(category: category);
      break;
    case 'ProfilePreview':
      UserModel user = settings?.arguments as UserModel;
      page = ProfilePreview(user: user);
      break;
    case 'EventDetails':
      EventsModel event = settings?.arguments as EventsModel;
      page = EventDetailsPage(event: event);
      transitionsBuilder = (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Slide from right
        const end = Offset.zero;
        const curve = Curves.easeOutCubic;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      };
      transitionDuration = const Duration(milliseconds: 300);
      break;
    case 'EventMemberList':
      EventsModel event = settings?.arguments as EventsModel;
      page = EventMemberList(event: event);
      break;
    case 'EventsPage':
      page = EventsPage();
      break;
    case 'MyOrdersPage':
      page = MyOrdersPage();
      break;
    case 'StorePage':
      String userCurrency = settings?.arguments as String;
      page = StorePage(userCurrency: userCurrency);
      break;
    case 'CartPage':
      String userCurrency = settings?.arguments as String;
      page = CartPage(
        userCurrency: userCurrency,
      );
      break;
    // case 'AddressSelectionPage':
    //   page = AddressSelectionPage();
    //   break;
    // case 'AddAddressPage':
    //   page = AddAddressPage();
    //   break;
    case 'ProductDetails':
      final args = settings?.arguments as Map<String, dynamic>;
      page = ProductDetailsPage(
          product: args['product'], category: args['category']);
      transitionsBuilder = (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Slide from right
        const end = Offset.zero;
        const curve = Curves.easeOutCubic;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      };
      transitionDuration = const Duration(milliseconds: 300);
      break;
    case 'Hierarchies':
      page = HierarchiesPage();
      break;
    default:
      return MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: kCardBackgroundColor,
          body: Center(
            child: Text(
              'No path for  ${settings?.name}',
              style: kSmallTitleB,
            ),
          ),
        ),
      );
  }
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page!,
    transitionsBuilder: transitionsBuilder,
    transitionDuration: transitionDuration,
  );
}
