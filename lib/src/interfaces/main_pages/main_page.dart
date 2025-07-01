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
import 'package:ipaconnect/src/interfaces/main_pages/home_page.dart';
import 'package:ipaconnect/src/interfaces/main_pages/news_bookmark/news_list_page.dart';
import 'package:ipaconnect/src/interfaces/main_pages/news_bookmark/news_page.dart';
import 'package:ipaconnect/src/interfaces/main_pages/people.dart';
import 'package:ipaconnect/src/interfaces/main_pages/profile/profile_page.dart';
import 'package:ipaconnect/src/interfaces/onboarding/login.dart';
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
      Text(''),
      PeoplePage(),
      NewsListPage(),
      ProfilePage(user: user),
    ];
    _activeIcons = [
      'assets/svg/icons/nav_icons/active_home.svg',
      'assets/svg/iconsnav_icons//active_business.svg',
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
    final selectedIndex = ref.watch(selectedIndexProvider);
    switch (status.toLowerCase()) {
      case 'active':
        return Scaffold(
          body: Center(
            child: _widgetOptions.elementAt(selectedIndex),
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: kWhite,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                items: List.generate(4, (index) {
                  final isSelected = selectedIndex == index;
                  final isProfile = index == 2;

                  Widget iconWidget;

                  if (isProfile) {
                    if (isSelected) {
                      iconWidget = user.image != null && user.image != ''
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(user.image!),
                              radius: 15,
                            )
                          : SvgPicture.asset(
                              'assets/svg/icons/dummy_person_small.svg',
                              height: 24,
                              width: 24,
                            );
                    } else {
                      iconWidget = IconResolver(
                        iconPath: _inactiveIcons[index],
                        color: Colors.grey,
                      );
                    }
                  } else {
                    iconWidget = IconResolver(
                      iconPath: isSelected
                          ? _activeIcons[index]
                          : _inactiveIcons[index],
                      color: isSelected ? kWhite : Colors.grey,
                    );
                  }

                  return BottomNavigationBarItem(
                    label: '',
                    icon: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      padding: isSelected
                          ? const EdgeInsets.all(10)
                          : EdgeInsets.zero,
                      decoration: isSelected
                          ? BoxDecoration(
                              shape: BoxShape.circle,
                              color: kPrimaryLightColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.red.withOpacity(0.6),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ],
                            )
                          : null,
                      child: AnimatedScale(
                        duration: const Duration(milliseconds: 300),
                        scale: isSelected ? 1.2 : 1.0,
                        child: iconWidget,
                      ),
                    ),
                  );
                }),
                currentIndex: selectedIndex,
                selectedItemColor: kPrimaryColor,
                unselectedItemColor: Colors.grey,
                onTap: (index) {
                  HapticFeedback.selectionClick();
                  _onItemTapped(index);
                },
                showSelectedLabels: false,
                showUnselectedLabels: false,
                backgroundColor: Colors
                    .transparent, // Set transparent to allow container color
                elevation: 0,
              ),
            ),
          ),
        );
      case 'inactive':
        return const UserInactivePage();
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
            child: _buildStatusPage(user.status ?? 'unknown', user),
          );
        },
      );
    });
  }
}
