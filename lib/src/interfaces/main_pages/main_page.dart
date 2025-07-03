import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/models/user_model.dart';
import 'package:ipaconnect/src/data/notifiers/user_notifier.dart';
import 'package:ipaconnect/src/data/router/nav_router.dart';
import 'package:ipaconnect/src/data/services/api_routes/user_api/user_data/user_data_api.dart';
import 'package:ipaconnect/src/data/utils/globals.dart';
import 'package:ipaconnect/src/data/utils/secure_storage.dart';
import 'package:ipaconnect/src/interfaces/components/loading/loading_indicator.dart';
import 'package:ipaconnect/src/interfaces/components/shimmers/promotion_shimmers.dart';
import 'package:ipaconnect/src/interfaces/main_pages/business_page.dart';
import 'package:ipaconnect/src/interfaces/main_pages/home_page.dart';
import 'package:ipaconnect/src/interfaces/main_pages/news_bookmark/news_list_page.dart';
import 'package:ipaconnect/src/interfaces/main_pages/news_bookmark/news_page.dart';
import 'package:ipaconnect/src/interfaces/main_pages/people.dart';
import 'package:ipaconnect/src/interfaces/main_pages/profile/profile_page.dart';
import 'package:ipaconnect/src/interfaces/onboarding/login.dart';
import 'package:ipaconnect/src/interfaces/onboarding/registration.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:ipaconnect/src/interfaces/additional_screens/user_status_sreens.dart';

class IconResolver extends StatelessWidget {
  final String iconPath;
  final Color color;
  final double height;
  final double width;

  const IconResolver({
    Key? key,
    required this.iconPath,
    required this.color,
    this.height = 24,
    this.width = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (iconPath.startsWith('http') || iconPath.startsWith('https')) {
      return Image.network(
        iconPath,
        // color: color,
        height: height,
        width: width,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.error);
        },
      );
    } else {
      return SvgPicture.asset(
        iconPath,
        color: color,
        height: height,
        width: width,
      );
    }
  }
}

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  static List<Widget> _widgetOptions = <Widget>[];

  void _onItemTapped(int index) {
    HapticFeedback.selectionClick();
    setState(() {
      ref.read(currentNewsIndexProvider.notifier).state = 0;
      // _selectedIndex = index;
      ref.read(selectedIndexProvider.notifier).updateIndex(index);
    });
  }

  List<String> _inactiveIcons = [];
  List<String> _activeIcons = [];
  Future<void> _initialize({required UserModel user}) async {
    _widgetOptions = <Widget>[
      HomePage(
        user: user,
      ),
      BusinessCategoriesPage(),
      PeoplePage(),
      NewsListPage(),
      ProfilePage(user: user),
    ];
    _activeIcons = [
      'assets/svg/icons/nav_icons/active_home.svg',
      'assets/svg/icons/nav_icons/active_business.svg',
      'assets/svg/icons/nav_icons/active_chat.svg',
      'assets/svg/icons/nav_icons/active_news.svg',
      'assets/svg/icons/nav_icons/active_profile.svg',
    ];
    _inactiveIcons = [
      'assets/svg/icons/nav_icons/inactive_home.svg',
      'assets/svg/icons/nav_icons/inactive_business.svg',
      'assets/svg/icons/nav_icons/inactive_chat.svg',
      'assets/svg/icons/nav_icons/inactive_news.svg',
      'assets/svg/icons/nav_icons/inactive_profile.svg',
    ];

    await SecureStorage.write('id', user.id ?? '');
    id = user.id ?? '';
    log('main page user id:$id');
  }

  Widget _buildStatusPage(String status, UserModel user) {
    final List<String> labels = ['Home', 'Business', 'Chat', 'News', 'Profile'];

    final selectedIndex = ref.watch(selectedIndexProvider);
    switch (status.toLowerCase()) {
      case 'active':
        return Scaffold(
          body: Center(
            child: _widgetOptions.elementAt(selectedIndex),
          ),
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: .5,
                color: kPrimaryColor,
              ),
              Container(
                height: 80,
                decoration: BoxDecoration(
                  color: kWhite,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: BottomNavigationBar(
                  currentIndex: selectedIndex,
                  selectedItemColor: Colors.white,
                  unselectedItemColor: Colors.white54,
                  onTap: _onItemTapped,
                  showSelectedLabels: true,
                  showUnselectedLabels: false,
                  backgroundColor:
                      const Color(0xFF0D0D1F), // dark navy background
                  elevation: 0,
                  type: BottomNavigationBarType.fixed,
                  items: List.generate(5, (index) {
                    final isSelected = selectedIndex == index;
                    Widget iconWidget;
                    iconWidget = IconResolver(
                      iconPath: isSelected
                          ? _activeIcons[index]
                          : _inactiveIcons[index],
                      color: isSelected ? kWhite : Colors.grey,
                    );
                    return BottomNavigationBarItem(
                      label: '',
                      icon: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isSelected)
                            Column(
                              children: [
                                Transform.translate(
                                  offset: Offset(0, -7),
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Container(
                                      width: 38,
                                      height: 5,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.vertical(
                                          bottom: Radius.circular(6),
                                        ),
                                        gradient: LinearGradient(
                                          colors: [
                                            kPrimaryColor.withOpacity(0.85),
                                            kPrimaryColor.withOpacity(0.25),
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                kPrimaryColor.withOpacity(0.95),
                                            blurRadius: 38,
                                            spreadRadius: 10,
                                            offset: Offset(0, 8),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              AnimatedScale(
                                duration: const Duration(milliseconds: 300),
                                scale: isSelected ? 1.2 : 1.0,
                                child: iconWidget,
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            labels[index],
                            style: TextStyle(
                              color:
                                  isSelected ? Colors.white : Color(0xFFAEB9E1),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        );
      case 'inactive':
        return RegistrationPage(
          phone: user.phone ?? '',
        );
      case 'deleted':
        return const UserDeletedPage();
      case 'awaiting-payment':
      case 'awaiting_payment':
        return const UserAwaitingPaymentPage();
      case 'rejected':
        return const UserRejectedPage();
      case 'suspended':
        return const UserSuspendedPage();
      default:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => PhoneNumberScreen(),
          //   ),
          // );
        });
        // Return a loading screen while navigation occurs
        return const Scaffold(
          backgroundColor: kBackgroundColor,
          body: Center(
            child: LoadingAnimation(),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final selectedIndex = ref.watch(selectedIndexProvider);
      final asyncUser = ref.watch(userProvider);

      return asyncUser.when(
        loading: () {
          return Scaffold(
              backgroundColor: kBackgroundColor,
              body: buildShimmerPromotionsColumn(context: context));
        },
        error: (error, stackTrace) {
          log('im inside details main page error $error $stackTrace');
          return PhoneNumberScreen();
        },
        data: (user) {
          // if (user.fcm == null || user.fcm == '') {
          //   editUser({"fcm": fcmToken, "name": user.name, "phone": user.phone});
          // }
          // // Force name completion before anything else
          // if (user.name == null || user.name!.trim().isEmpty) {
          //   // Show the non-skippable profile completion screen
          //   // return const ProfileCompletionScreen();
          // }
          // subscriptionType = user.subscription ?? 'free';
          _initialize(user: user);
          return PopScope(
            canPop: selectedIndex != 0 ? false : true,
            onPopInvokedWithResult: (didPop, result) {
              log('im inside mainpage popscope');
              if (selectedIndex != 0) {
                ref.read(selectedIndexProvider.notifier).updateIndex(0);
              }
            },
            child: _buildStatusPage(user.status ?? '', user),
          );
        },
      );
    });
  }
}
