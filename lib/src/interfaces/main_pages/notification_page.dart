import 'package:flutter/material.dart';
import 'package:ipaconnect/src/data/models/notification_model.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_round_button.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationPage extends StatelessWidget {
  final List<NotificationModel> notifications;
  const NotificationPage({Key? key, required this.notifications})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: CustomRoundButton(
              offset: Offset(4, 0),
              iconPath: 'assets/svg/icons/arrow_back_ios.svg',
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
                return Container(
                  decoration: BoxDecoration(
                    color: kCardBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: kStrokeColor, width: 1),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (notification.subject != null)
                        Text(notification.subject!, style: kSmallTitleR),
                      if (notification.content != null) ...[
                        const SizedBox(height: 8),
                        Text(notification.content!,
                            style: kSmallerTitleR.copyWith(
                                color: kSecondaryTextColor)),
                      ],
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
                );
              },
            ),
    );
  }
}








































