import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/models/notification_model.dart';
import 'package:ipaconnect/src/data/models/user_model.dart';
import 'package:ipaconnect/src/data/notifiers/user_notifier.dart';
import 'package:ipaconnect/src/data/router/nav_router.dart';
import 'package:ipaconnect/src/data/services/api_routes/chat_api/chat_api_service.dart';
import 'package:ipaconnect/src/data/services/api_routes/events_api/events_api.dart';
import 'package:ipaconnect/src/data/services/api_routes/notification_api/notification_api_service.dart';
import 'package:ipaconnect/src/data/services/api_routes/user_api/user_data/user_data_api.dart';
import 'package:ipaconnect/src/data/services/navigation_service.dart';
import 'package:ipaconnect/src/data/utils/globals.dart';
import 'package:ipaconnect/src/data/utils/secure_storage.dart';
import 'package:ipaconnect/src/interfaces/main_pages/people/chat_screen.dart'
    show ChatScreen;

// Create a provider for DeepLinkService
final deepLinkServiceProvider = Provider<DeepLinkService>((ref) {
  return DeepLinkService(ref);
});

class DeepLinkService {
  final Ref _ref;
  final _appLinks = AppLinks();
  Uri? _pendingDeepLink;

  // Constructor that takes a Ref
  DeepLinkService(this._ref);

  Uri? get pendingDeepLink => _pendingDeepLink;
  void clearPendingDeepLink() {
    _pendingDeepLink = null;
  }

  // Initialize and handle deep links
  Future<void> initialize(BuildContext context) async {
    try {
      // Handle deep link when app is started from terminated state
      final appLink = await _appLinks.getInitialLink();
      if (appLink != null) {
        _pendingDeepLink = appLink;
      }

      // Handle deep link when app is in background or foreground
      _appLinks.uriLinkStream.listen((uri) {
        _pendingDeepLink = uri;
        handleDeepLink(uri);
      });
    } catch (e) {
      debugPrint('Deep link initialization error: $e');
    }
  }

  Future<void> handleDeepLink(Uri uri) async {
    try {
      // First ensure token is loaded
      if (token.isEmpty) {
        String? savedtoken = await SecureStorage.read('fcmToken');
        String? savedId = await SecureStorage.read('id');
        if (savedtoken != null && savedtoken.isNotEmpty && savedId != null) {
          token = savedtoken;
          id = savedId;
          LoggedIn = true;
        }
      }

      final pathSegments = uri.pathSegments;
      if (pathSegments.isEmpty) return;

      debugPrint('Handling deep link: ${uri.toString()}');
      debugPrint('Path segments: $pathSegments');

      // Check if app is in the foreground
      bool isAppForeground =
          NavigationService.navigatorKey.currentState?.overlay != null;

      if (!isAppForeground) {
        debugPrint('App is not in foreground, navigating to mainpage first');
        NavigationService.navigatorKey.currentState?.pushNamedAndRemoveUntil(
          'MainPage',
          (route) => false,
        );

        await Future.delayed(Duration(milliseconds: 500));
      }

      switch (pathSegments[0]) {
        case 'chat':
          if (pathSegments.length > 1) {
            final userId = pathSegments[1];
            try {
              final chatApi = _ref.read(chatApiServiceProvider);
              final conversation = await chatApi.create1to1Conversation(userId);
              UserModel? otherMember = conversation?.members
                  ?.firstWhere((m) => m.id != id, orElse: () => UserModel());

              if (conversation != null) {
                NavigationService.navigatorKey.currentState?.push(
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      userImage: otherMember?.image ?? '',
                      conversationId: conversation.id ?? '',
                      chatTitle: otherMember?.name ?? '',
                      userId: userId,
                    ),
                  ),
                );
              } else {
                _showError('Failed to start chat.');
              }
            } catch (e) {
              debugPrint('Error starting chat: $e');
              _showError('Failed to start chat.');
            }
          }
          break;
        case 'event':
          if (pathSegments.length > 1) {
            final eventId = pathSegments[1];
            try {
              final eventApiService = _ref.watch(eventsApiServiceProvider);
              final event = await eventApiService.fetchEventById(eventId);
              NavigationService.navigatorKey.currentState
                  ?.pushNamed('EventDetails', arguments: event);
            } catch (e) {
              debugPrint('Error fetching event: $e');
              _showError('Unable to load event');
            }
          }
          break;

        case 'my_requirements':
          try {
            if (NavigationService.navigatorKey.currentState != null) {
              NavigationService.navigatorKey.currentState
                  ?.pushNamedAndRemoveUntil(
                'MainPage',
                (route) => false,
              );
              await Future.delayed(Duration(milliseconds: 500));
              NavigationService.navigatorKey.currentState
                  ?.pushNamed('MyRequirements');
            }
          } catch (e) {
            debugPrint('Error navigating to requirements: $e');
            _showError('Unable to navigate to requirements');
          }
          break;

        // case 'my_products':
        //   try {
        //     if (NavigationService.navigatorKey.currentState != null) {
        //       NavigationService.navigatorKey.currentState
        //           ?.pushNamedAndRemoveUntil(
        //         'MainPage',
        //         (route) => false,
        //       );
        //       await Future.delayed(Duration(milliseconds: 500));

        //       NavigationService.navigatorKey.currentState
        //           ?.pushNamed('/my_products');
        //     }
        //   } catch (e) {
        //     debugPrint('Error navigating to products: $e');
        //     _showError('Unable to navigate to products');
        //   }
        //   break;

        // case 'my_subscription':
        //   try {
        //     // First navigate to mainpage if not already there
        //     if (NavigationService.navigatorKey.currentState != null) {
        //       NavigationService.navigatorKey.currentState
        //           ?.pushNamedAndRemoveUntil(
        //         'MainPage',
        //         (route) => false,
        //       );
        //       await Future.delayed(Duration(milliseconds: 500));
        //       NavigationService.navigatorKey.currentState
        //           ?.pushNamed('/my_subscription');
        //     }
        //   } catch (e) {
        //     debugPrint('Error navigating to subscription: $e');
        //     _showError('Unable to navigate to subscription');
        //   }
        //   break;

        case 'requirements':
          try {
            if (NavigationService.navigatorKey.currentState != null) {
              NavigationService.navigatorKey.currentState
                  ?.pushNamedAndRemoveUntil(
                'MainPage',
                (route) => false,
              );
              await Future.delayed(Duration(milliseconds: 500));
              _ref.read(selectedIndexProvider.notifier).updateIndex(4);
            }
          } catch (e) {
            debugPrint('Error updating tab: $e');
            _showError('Unable to navigate to requirements');
          }
          break;

        case 'news':
          try {
            // First navigate to mainpage if not already there
            if (NavigationService.navigatorKey.currentState != null) {
              NavigationService.navigatorKey.currentState
                  ?.pushNamedAndRemoveUntil(
                'MainPage',
                (route) => false,
              );
              await Future.delayed(Duration(milliseconds: 500));
              _ref.read(selectedIndexProvider.notifier).updateIndex(3);
            }
          } catch (e) {
            debugPrint('Error updating tab: $e');
            _showError('Unable to navigate to requirements');
          }
          break;

        case 'mainpage':
          NavigationService.navigatorKey.currentState?.pushNamedAndRemoveUntil(
            'MainPage',
            (route) => false,
          );
          break;

        default:
          final notificationApiService =
              _ref.watch(notificationApiServiceProvider);
          List<NotificationModel> notifications =
              await notificationApiService.fetchNotifications();

          NavigationService.navigatorKey.currentState
              ?.pushNamed('NotificationPage', arguments: notifications);

          break;
      }
    } catch (e) {
      debugPrint('Deep link handling error: $e');
      _showError('Unable to process the notification');
    }
  }

  void _showError(String message) {
    if (NavigationService.navigatorKey.currentContext != null) {
      ScaffoldMessenger.of(NavigationService.navigatorKey.currentContext!)
          .showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  String? getDeepLinkPath(String screen, {String? id}) {
    switch (screen) {
      case 'chat':
        return id != null
            ? 'ipaconnect://app/chat/$id'
            : 'ipaconnect://app/chat';
      case 'event':
        return id != null
            ? 'ipaconnect://app/event/$id'
            : 'ipaconnect://app/event';
      case 'my_subscription':
        return 'ipaconnect://app/my_subscription';
      case 'my_products':
        return 'ipaconnect://app/my_products';
      case 'my_requirements':
        return 'ipaconnect://app/my_requirements';
      case 'in-app':
        return 'ipaconnect://app/notification';
      case 'products':
        return id != null
            ? 'ipaconnect://app/products/$id'
            : 'ipaconnect://app/products';
      case 'news':
        return 'ipaconnect://app/news';
      case 'requirements':
        return 'ipaconnect://app/requirements';
      case 'mainpage':
        return 'ipaconnect://app/mainpage';
      default:
        return null;
    }
  }
}
