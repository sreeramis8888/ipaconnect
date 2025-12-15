import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/models/notification_model.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_round_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ipaconnect/src/data/services/api_routes/notification_api/notification_api_service.dart';

class NotificationPage extends ConsumerWidget {
  final List<NotificationModel> notifications;
  const NotificationPage({super.key, required this.notifications});

  Future<void> _deleteNotification(
      String notificationId, WidgetRef ref, BuildContext context) async {
    final notificationService = ref.read(notificationApiServiceProvider);

    try {
      final success =
          await notificationService.deleteNotification(notificationId);

      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notification deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to delete notification'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting notification: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> _showDeleteConfirmationDialog(
        NotificationModel notification) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete Notification', style: kSmallTitleL),
            content: Text(
              'Are you sure you want to delete this notification?',
              style: kSmallerTitleR.copyWith(color: kSecondaryTextColor),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel', style: kSmallTitleB),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Delete',
                    style: kSmallTitleB.copyWith(color: Colors.red)),
                onPressed: () async {
                  Navigator.of(context).pop();
                  if (notification.id != null) {
                    await _deleteNotification(notification.id!, ref, context);
                  }
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: CustomRoundButton(
                offset: const Offset(4, 0),
                iconPath: 'assets/svg/icons/arrow_back_ios.svg',
              ),
            ),
          ),
        ),
        scrolledUnderElevation: 0,
        title: Text('Notifications',
            style: kBodyTitleB.copyWith(color: kSecondaryTextColor)),
        backgroundColor: kBackgroundColor,
        iconTheme: IconThemeData(color: kSecondaryTextColor),
      ),
      backgroundColor: kBackgroundColor,
      body: notifications.isEmpty
          ? Center(child: Text('No notifications', style: kBodyTitleR))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Dismissible(
                  key: Key(notification.id ?? 'notification_$index'),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    color: Colors.red,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  confirmDismiss: (direction) async {
                    await _showDeleteConfirmationDialog(notification);
                    return false; // Prevent automatic dismissal
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: kCardBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: kStrokeColor, width: 1),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (notification.subject != null)
                                    Text(notification.subject!,
                                        style: kSmallTitleL),
                                  if (notification.content != null) ...[
                                    const SizedBox(height: 8),
                                    Text(notification.content!,
                                        style: kSmallerTitleR.copyWith(
                                            color: kSecondaryTextColor)),
                                  ],
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () =>
                                  _showDeleteConfirmationDialog(notification),
                              icon: const Icon(Icons.delete_outline,
                                  color: Colors.red),
                              tooltip: 'Delete notification',
                            ),
                          ],
                        ),
                        if (notification.image != null &&
                            notification.image!.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              notification.image!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                height: 120,
                                color: kGrey,
                                child: const Center(
                                    child: Icon(Icons.broken_image,
                                        color: kGreyDark)),
                              ),
                            ),
                          ),
                        ],
                        if (notification.link != null &&
                            notification.link!.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          GestureDetector(
                            onTap: () async {
                              final url = Uri.parse(notification.link!);
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url,
                                    mode: LaunchMode.externalApplication);
                              }
                            },
                            child: Text(
                              notification.link!,
                              style: kSmallTitleB.copyWith(
                                  color: kPrimaryColor,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
