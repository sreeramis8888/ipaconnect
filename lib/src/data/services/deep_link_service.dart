// import 'package:app_links/app_links.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:ipaconnect/src/data/notifiers/user_notifier.dart';
// import 'package:ipaconnect/src/data/router/nav_router.dart';
// import 'package:ipaconnect/src/data/services/api_routes/events_api/events_api.dart';
// import 'package:ipaconnect/src/data/services/api_routes/user_api/user_data/user_data_api.dart';
// import 'package:ipaconnect/src/data/services/navigation_service.dart';
// import 'package:ipaconnect/src/data/utils/globals.dart';
// import 'package:ipaconnect/src/data/utils/secure_storage.dart';

// // Create a provider for DeepLinkService
// final deepLinkServiceProvider = Provider<DeepLinkService>((ref) {
//   return DeepLinkService(ref);
// });

// class DeepLinkService {
//   final Ref _ref;
//   final _appLinks = AppLinks();
//   Uri? _pendingDeepLink;

//   // Constructor that takes a Ref
//   DeepLinkService(this._ref);

//   Uri? get pendingDeepLink => _pendingDeepLink;
//   void clearPendingDeepLink() {
//     _pendingDeepLink = null;
//   }

//   // Initialize and handle deep links
//   Future<void> initialize(BuildContext context) async {
//     try {
//       // Handle deep link when app is started from terminated state
//       final appLink = await _appLinks.getInitialLink();
//       if (appLink != null) {
//         _pendingDeepLink = appLink;
//       }

//       // Handle deep link when app is in background or foreground
//       _appLinks.uriLinkStream.listen((uri) {
//         _pendingDeepLink = uri;
//         handleDeepLink(uri);
//       });
//     } catch (e) {
//       debugPrint('Deep link initialization error: $e');
//     }
//   }

//   Future<void> handleDeepLink(Uri uri) async {
//     try {
//       // First ensure token is loaded
//       if (token.isEmpty) {
//         String? savedtoken = await SecureStorage.read('fcmToken');
//         String? savedId = await SecureStorage.read('id');
//         if (savedtoken != null && savedtoken.isNotEmpty && savedId != null) {
//           token = savedtoken;
//           id = savedId;
//           LoggedIn = true;
//         }
//       }

//       final pathSegments = uri.pathSegments;
//       if (pathSegments.isEmpty) return;

//       debugPrint('Handling deep link: ${uri.toString()}');
//       debugPrint('Path segments: $pathSegments');

//       // Check if app is in the foreground
//       bool isAppForeground =
//           NavigationService.navigatorKey.currentState?.overlay != null;

//       if (!isAppForeground) {
//         debugPrint('App is not in foreground, navigating to mainpage first');
//         // App is in the background or terminated, go through splash & mainpage
//         NavigationService.navigatorKey.currentState?.pushNamedAndRemoveUntil(
//           'MainPage',
//           (route) => false,
//         );

//         await Future.delayed(Duration(milliseconds: 500)); // Ensure stability
//       }

//       // Now navigate to the deep link destination
//       switch (pathSegments[0]) {
//         case 'chat':
//           if (pathSegments.length > 1) {
//             final userId = pathSegments[1];
//             debugPrint('Navigating to chat with user: $userId');
//             try {
//               final userDataApiService = _ref.watch(userDataApiServiceProvider);
//               final user = await userDataApiService.fetchUserDetails();
//               if (NavigationService.navigatorKey.currentState != null) {
//                 NavigationService.navigatorKey.currentState
//                     ?.pushNamed('ChatScreen', arguments: {
//                   'sender': Participant(id: id),
//                   'receiver': Participant(
//                     id: user.id,
//                     name: user.name,
//                     profilePicture: user.profilePicture,
//                   ),
//                 });
//               } else {
//                 debugPrint('Navigator state is null, cannot navigate to chat');
//               }
//             } catch (e) {
//               debugPrint('Error fetching user: $e');
//               _showError('Unable to load profile: $e');
//             }
//           }
//           break;
//         case 'event':
//           if (pathSegments.length > 1) {
//             final eventId = pathSegments[1];
//             try {
//               final eventApiService = _ref.watch(eventsApiServiceProvider);
//               final event = await eventApiService.fetchEventById(eventId);
//               NavigationService.navigatorKey.currentState
//                   ?.pushNamed('/event_details', arguments: event);
//             } catch (e) {
//               debugPrint('Error fetching event: $e');
//               _showError('Unable to load event');
//             }
//           }
//           break;

//         case 'my_requirements':
//           try {
//             // First navigate to mainpage if not already there
//             if (NavigationService.navigatorKey.currentState != null) {
//               NavigationService.navigatorKey.currentState
//                   ?.pushNamedAndRemoveUntil(
//                 'MainPage',
//                 (route) => false,
//               );
//               await Future.delayed(Duration(milliseconds: 500));
//               NavigationService.navigatorKey.currentState
//                   ?.pushNamed('MyRequirements');
//             }
//           } catch (e) {
//             debugPrint('Error navigating to requirements: $e');
//             _showError('Unable to navigate to requirements');
//           }
//           break;

//         case 'my_products':
//           try {
//             // First navigate to mainpage if not already there
//             if (NavigationService.navigatorKey.currentState != null) {
//               NavigationService.navigatorKey.currentState
//                   ?.pushNamedAndRemoveUntil(
//                 'MainPage',
//                 (route) => false,
//               );
//               await Future.delayed(Duration(milliseconds: 500));

//               NavigationService.navigatorKey.currentState
//                   ?.pushNamed('/my_products');
//             }
//           } catch (e) {
//             debugPrint('Error navigating to products: $e');
//             _showError('Unable to navigate to products');
//           }
//           break;

//         case 'my_subscription':
//           try {
//             // First navigate to mainpage if not already there
//             if (NavigationService.navigatorKey.currentState != null) {
//               NavigationService.navigatorKey.currentState
//                   ?.pushNamedAndRemoveUntil(
//                 'MainPage',
//                 (route) => false,
//               );
//               await Future.delayed(Duration(milliseconds: 500));
//               NavigationService.navigatorKey.currentState
//                   ?.pushNamed('/my_subscription');
//             }
//           } catch (e) {
//             debugPrint('Error navigating to subscription: $e');
//             _showError('Unable to navigate to subscription');
//           }
//           break;

//         case 'requirements':
//           try {
//             if (NavigationService.navigatorKey.currentState != null) {
//               NavigationService.navigatorKey.currentState
//                   ?.pushNamedAndRemoveUntil(
//                 'MainPage',
//                 (route) => false,
//               );
//               await Future.delayed(Duration(milliseconds: 500));
//               _ref.read(selectedIndexProvider.notifier).updateIndex(4);
//             }
//           } catch (e) {
//             debugPrint('Error updating tab: $e');
//             _showError('Unable to navigate to requirements');
//           }
//           break;

//         case 'products':
//           if (pathSegments.length > 1) {
//             final productId = pathSegments[1];
//             try {
//               final product = await fetchProductById(productId);
//               final user =
//                   await ApiRoutes().fetchUserDetails(product.sellerId ?? '');
//               final receiver = Participant(
//                 id: user.id,
//                 name: user.name,
//                 profilePicture: user.profilePicture,
//               );
//               final sender = Participant(id: id);

//               // First navigate to mainpage if not already there
//               if (navigatorKey.currentState != null) {
//                 navigatorKey.currentState?.pushNamedAndRemoveUntil(
//                   'MainPage',
//                   (route) => false,
//                 );
//                 await Future.delayed(Duration(milliseconds: 500));
//                 _ref.read(selectedIndexProvider.notifier).updateIndex(1);
//                 if (navigatorKey.currentContext != null) {
//                   showModalBottomSheet(
//                     isScrollControlled: true,
//                     context: navigatorKey.currentContext!,
//                     builder: (context) => ProductDetailsModal(
//                       receiver: receiver,
//                       sender: sender,
//                       product: product,
//                     ),
//                   );
//                 }
//               }
//             } catch (e) {
//               debugPrint('Error fetching product: $e');
//               _showError('The Product no longer exists');
//             }
//           } else {
//             try {
//               // First navigate to mainpage if not already there
//               if (navigatorKey.currentState != null) {
//                 navigatorKey.currentState?.pushNamedAndRemoveUntil(
//                   'MainPage',
//                   (route) => false,
//                 );
//                 await Future.delayed(Duration(milliseconds: 500));
//                 _ref.read(selectedIndexProvider.notifier).updateIndex(1);
//               }
//             } catch (e) {
//               debugPrint('Error updating tab: $e');
//               _showError('Unable to navigate to products');
//             }
//           }
//           break;
//         case 'news':
//           try {
//             // First navigate to mainpage if not already there
//             if (navigatorKey.currentState != null) {
//               navigatorKey.currentState?.pushNamedAndRemoveUntil(
//                 'MainPage',
//                 (route) => false,
//               );
//               await Future.delayed(Duration(milliseconds: 500));
//               _ref.read(selectedIndexProvider.notifier).updateIndex(3);
//             }
//           } catch (e) {
//             debugPrint('Error updating tab: $e');
//             _showError('Unable to navigate to requirements');
//           }
//           break;

//         case 'mainpage':
//           navigatorKey.currentState?.pushNamedAndRemoveUntil(
//             'MainPage',
//             (route) => false,
//           );
//           break;

//         default:
//           List<NotificationModel> notifications =
//               await NotificationApiService(token: token)
//                   .fetchUnreadNotifications(id);

//           navigatorKey.currentState
//               ?.pushNamed('/notification', arguments: notifications);

//           break;
//       }
//     } catch (e) {
//       debugPrint('Deep link handling error: $e');
//       _showError('Unable to process the notification');
//     }
//   }

//   void _showError(String message) {
//     if (navigatorKey.currentContext != null) {
//       ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
//         SnackBar(content: Text(message)),
//       );
//     }
//   }

//   String? getDeepLinkPath(String screen, {String? id}) {
//     switch (screen) {
//       case 'chat':
//         return id != null ? 'kssia://app/chat/$id' : 'kssia://app/chat';
//       case 'event':
//         return id != null ? 'kssia://app/event/$id' : 'kssia://app/event';
//       case 'my_subscription':
//         return 'kssia://app/my_subscription';
//       case 'my_products':
//         return 'kssia://app/my_products';
//       case 'my_requirements':
//         return 'kssia://app/my_requirements';
//       case 'in-app':
//         return 'kssia://app/notification';
//       case 'products':
//         return id != null ? 'kssia://app/products/$id' : 'kssia://app/products';
//       case 'news':
//         return 'kssia://app/news';
//       case 'requirements':
//         return 'kssia://app/requirements';
//       case 'mainpage':
//         return 'kssia://app/mainpage';
//       default:
//         return null;
//     }
//   }
// }
