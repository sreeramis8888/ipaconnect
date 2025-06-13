import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings? settings) {
  switch (settings?.name) {
    // case 'Splash':
    //   return MaterialPageRoute(builder: (context) => SplashScreen());
    // case 'PhoneNumber':
    //   return MaterialPageRoute(builder: (context) => PhoneNumberScreen());
    // case 'MainPage':
    //   return MaterialPageRoute(builder: (context) => const MainPage());
    // case 'ProfileCompletion':
    //   return MaterialPageRoute(
    //       builder: (context) => const ProfileCompletionScreen());
    // case 'Card':
    //   UserModel user = settings?.arguments as UserModel;
    //   return MaterialPageRoute(
    //       builder: (context) => IDCardScreen(
    //             user: user,
    //           ));
    // case 'ProfilePreview':
    //   UserModel user = settings?.arguments as UserModel;
    //   return MaterialPageRoute(
    //       builder: (context) => ProfilePreview(
    //             user: user,
    //           ));
    // case 'ProfilePreviewUsingID':
    //   String userId = settings?.arguments as String;
    //   return MaterialPageRoute(
    //       builder: (context) => ProfilePreviewUsingId(
    //             userId: userId,
    //           ));
    // case 'ViewMoreEvent':
    //   Event event = settings?.arguments as Event;
    //   return MaterialPageRoute(
    //       builder: (context) => ViewMoreEventPage(
    //             event: event,
    //           ));
    // case 'MemberAllocation':
    //   UserModel newUser = settings?.arguments as UserModel;
    //   return MaterialPageRoute(
    //       builder: (context) => AllocateMember(
    //             newUser: newUser,
    //           ));
    // case 'EventMemberList':
    //   Event event = settings?.arguments as Event;
    //   return MaterialPageRoute(
    //       builder: (context) => EventMemberList(
    //             event: event,
    //           ));
    // case 'EditUser':
    //   return MaterialPageRoute(builder: (context) => EditUser());
    // case 'IndividualPage':
    //   final args = settings?.arguments as Map<String, dynamic>?;
    //   Participant sender = args?['sender'];
    //   Participant receiver = args?['receiver'];

    //   return MaterialPageRoute(
    //       builder: (context) => IndividualPage(
    //             receiver: receiver,
    //             sender: sender,
    //           ));
    // case 'ChangeNumber':
    //   return MaterialPageRoute(builder: (context) => ChangeNumberPage());
    // case 'NotificationPage':
    //   return MaterialPageRoute(builder: (context) => NotificationPage());
    // case 'AboutPage':
    //   return MaterialPageRoute(builder: (context) => AboutPage());
    // case 'News':
    //   return MaterialPageRoute(builder: (context) => NewsPage());
    // case 'MemberCreation':
    //   return MaterialPageRoute(builder: (context) => MemberCreationPage());
    // case 'MyEvents':
    //   return MaterialPageRoute(builder: (context) => MyEventsPage());
    // case 'MyProducts':
    //   return MaterialPageRoute(builder: (context) => MyProductPage());
    // case 'EnterProductsPage':
    //   return MaterialPageRoute(builder: (context) => EnterProductsPage());
    // case 'MyBusinesses':
    //   return MaterialPageRoute(builder: (context) => MyBusinessesPage());
    // case 'AnalyticsPage':
    //   return MaterialPageRoute(builder: (context) => AnalyticsPage());
    // case 'SendAnalyticRequest':
    //   return MaterialPageRoute(builder: (context) => SendAnalyticRequestPage());

    // case 'RequestNFC':
    //   return MaterialPageRoute(builder: (context) => RequestNFCPage());
    // case 'MyReviews':
    //   return MaterialPageRoute(builder: (context) => MyReviewsPage());
    // case 'States':
    //   return MaterialPageRoute(builder: (context) => StatesPage());

    // case 'MySubscriptionPage':
    //   return MaterialPageRoute(builder: (context) => MySubscriptionPage());

    // case 'Terms':
    //   return MaterialPageRoute(builder: (context) => TermsAndConditionsPage());

    // case 'PrivacyPolicy':
    //   return MaterialPageRoute(builder: (context) => PrivacyPolicyPage());

    // case 'ProfileAnalytics':
    //   UserModel user = settings?.arguments as UserModel;
    //   return MaterialPageRoute(
    //       builder: (context) => ProfileAnalyticsPage(
    //             user: user,
    //           ));
    // case 'ActivityPage':
    //   String chapterId = settings?.arguments as String;
    //   return MaterialPageRoute(
    //       builder: (context) => ActivityPage(
    //             chapterId: chapterId,
    //           ));
    // case 'MyEnquiries':
    //   return MaterialPageRoute(builder: (context) => const MyEnquiriesPage());
    default:
      return MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Center(
            child: Text('No path for ${settings?.name}'),
          ),
        ),
      );
  }
}
