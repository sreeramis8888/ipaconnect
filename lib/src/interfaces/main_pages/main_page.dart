import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/models/user_model.dart';
import 'package:ipaconnect/src/data/notifiers/user_notifier.dart';
import 'package:ipaconnect/src/data/router/nav_router.dart';
import 'package:ipaconnect/src/data/services/api_routes/subscription_api/subscription_api_service.dart';
import 'package:ipaconnect/src/data/services/api_routes/user_api/user_data/user_data_api.dart';
import 'package:ipaconnect/src/data/utils/currency_converted.dart';
import 'package:ipaconnect/src/data/utils/globals.dart';
import 'package:ipaconnect/src/data/utils/secure_storage.dart';
import 'package:ipaconnect/src/interfaces/components/loading/loading_indicator.dart';
import 'package:ipaconnect/src/interfaces/components/shimmers/promotion_shimmers.dart';
import 'package:ipaconnect/src/interfaces/main_pages/business_page.dart';
import 'package:ipaconnect/src/interfaces/main_pages/home_page.dart';
import 'package:ipaconnect/src/interfaces/main_pages/news_bookmark/news_list_page.dart';
import 'package:ipaconnect/src/interfaces/main_pages/news_bookmark/news_page.dart';
import 'package:ipaconnect/src/interfaces/main_pages/people.dart';
import 'package:ipaconnect/src/interfaces/main_pages/profile/profile_preview.dart';
import 'package:ipaconnect/src/interfaces/onboarding/login.dart';
import 'package:ipaconnect/src/interfaces/onboarding/registration.dart';
import 'package:ipaconnect/src/data/services/socket_service.dart';
import 'package:ipaconnect/src/interfaces/additional_screens/user_status_sreens.dart';
import 'package:ipaconnect/src/interfaces/additional_screens/subscription_page.dart';
import 'package:ipaconnect/src/interfaces/additional_screens/payment_success_page.dart';
import 'package:ipaconnect/src/data/notifiers/payment_navigation_provider.dart';
import 'package:ipaconnect/src/data/notifiers/user_notifier.dart';

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
    // Connect socket only
    SocketService().connect();
    // Ensure global variables are in sync with SecureStorage
    _loadSecureDataIfNeeded();

    // Add a listener to watch for token changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (token.isNotEmpty && id.isNotEmpty) {
        ref.read(userProvider.notifier).refreshUser();
      }
    });
  }

  Future<void> _loadSecureDataIfNeeded() async {
    // Always ensure global variables are in sync with SecureStorage
    await loadSecureData();
    log('MainPage - After loadSecureData - token: $token, id: $id, LoggedIn: $LoggedIn');

    // If we have a valid token, refresh the user provider to fetch fresh data
    if (token.isNotEmpty && id.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(userProvider.notifier).refreshUser();
      });
    }
  }

  Future<void> _clearInvalidToken() async {
    // Clear both global variables and SecureStorage when token is invalid
    token = '';
    id = '';
    LoggedIn = false;
    await SecureStorage.delete('token');
    await SecureStorage.delete('id');
    await SecureStorage.delete('LoggedIn');

    // Clear user provider cache to ensure fresh data on next login
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userProvider.notifier).revertToInitialState();
    });
  }

  @override
  void dispose() {
    // Disconnect socket when main page is disposed
    SocketService().disconnect();
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
      ProfilePreviewById(userId: user.id ?? ''),
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
    log('main pagetoken:$token');
  }

  Widget _buildStatusPage(String status, UserModel user, WidgetRef ref) {
    final List<String> labels = ['Home', 'Business', 'Chat', 'News', 'Profile'];

    final selectedIndex = ref.watch(selectedIndexProvider);
    switch (status.toLowerCase()) {
      case 'active':
        return Scaffold(
          backgroundColor: Color(0xFF00031A),
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
              ClipRect(
                child: Container(
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
                    selectedItemColor: kWhite,
                    unselectedItemColor: Colors.white54,
                    onTap: _onItemTapped,
                    showSelectedLabels: true,
                    showUnselectedLabels: false,
                    backgroundColor: Color(0xFF00031A),
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
                                              color: kPrimaryColor
                                                  .withOpacity(0.95),
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
                                color: isSelected ? kWhite : Color(0xFFAEB9E1),
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
              ),
            ],
          ),
        );
      case 'inactive':
        return RegistrationPage();
      case 'deleted':
        return const UserDeletedPage();
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
        return Scaffold(
          backgroundColor: Color(0xFF00031A),
          body: Center(
            child: buildShimmerPromotionsColumn(context: context),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final selectedIndex = ref.watch(selectedIndexProvider);

      // Only watch userProvider if we have a valid token
      log('MainPage - Current token: $token, id: $id');
      final asyncUser = token.isNotEmpty && id.isNotEmpty
          ? ref.watch(userProvider)
          : const AsyncValue<UserModel>.loading();

      return asyncUser.when(
        loading: () {
          return Scaffold(
              backgroundColor: Color(0xFF00031A),
              body: SingleChildScrollView(
                  child: buildShimmerPromotionsColumn(context: context)));
        },
        error: (error, stackTrace) {
          log('im inside details main page error $error $stackTrace');
          // Clear invalid token and redirect to login
          _clearInvalidToken();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              'PhoneNumber',
              (route) => false,
            );
          });
          return Scaffold(
            backgroundColor: Color(0xFF00031A),
            body: Center(
              child: buildShimmerPromotionsColumn(context: context),
            ),
          );
        },
        data: (user) {
          log('MainPage - User data received: ${user.name}, status: ${user.status}');
          if (user.status == null || user.id == null) {
            log('User is null or invalid');
            // If user is null but we have a token, clear it and redirect to login
            if (token.isNotEmpty || id.isNotEmpty) {
              _clearInvalidToken();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  'PhoneNumber',
                  (route) => false,
                );
              });
              return Scaffold(
                backgroundColor: Color(0xFF00031A),
                body: Center(
                  child: buildShimmerPromotionsColumn(context: context),
                ),
              );
            }
          }

          _initialize(user: user);
          if (user.status != null) {
            return PopScope(
              canPop: selectedIndex != 0 ? false : true,
              onPopInvokedWithResult: (didPop, result) {
                log('im inside mainpage popscope');
                if (selectedIndex != 0) {
                  ref.read(selectedIndexProvider.notifier).updateIndex(0);
                }
              },
              child: _buildStatusPage(user.status ?? '', user, ref),
            );
          } else {
            // Clear both global variables and SecureStorage when user status is null
            LoggedIn = false;
            id = '';
            token = '';
            _clearInvalidToken();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                'PhoneNumber',
                (route) => false,
              );
            });
            return Scaffold(
              backgroundColor: Color(0xFF00031A),
              body: Center(
                child: buildShimmerPromotionsColumn(context: context),
              ),
            );
          }
        },
      );
    });
  }
}
