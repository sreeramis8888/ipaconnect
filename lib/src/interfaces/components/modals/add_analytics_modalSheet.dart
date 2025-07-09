import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:intl/intl.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/models/analytics_model.dart';
import 'package:ipaconnect/src/data/services/api_routes/analytics_api/analytics_api.dart';
import 'package:ipaconnect/src/data/services/navigation_service.dart';
import 'package:ipaconnect/src/data/utils/globals.dart';
import 'package:ipaconnect/src/data/utils/launch_url.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_button.dart';

class AnalyticsModalSheet extends ConsumerWidget {
  final AnalyticsModel analytic;
  final String tabBarType;
  const AnalyticsModalSheet({
    Key? key,
    required this.tabBarType,
    required this.analytic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) { final analyticsApiService =
                      ref.watch(analyticsApiServiceProvider);
    NavigationService navigationService = NavigationService();
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 25, top: 10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag Indicator
            Center(
              child: Container(
                height: 4,
                width: 60,
                decoration: BoxDecoration(
                  color: kBlack54,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // User Info Row
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(analytic.userImage ?? ''),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        analytic.username ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        analytic.title ?? '',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Details Section

            _buildDetailRow('Request Type', analytic.type ?? ''),
            _buildDetailRow('Title', analytic.title ?? ''),
            if (analytic.date != null && analytic.time != null)
              _buildDetailRow(
                  'Date',
                  DateFormat("d'th' MMMM yyyy")
                      .format(analytic.date!.toLocal())),
            if (analytic.time != null)
              _buildDetailRow('Time', ' ${analytic.time}'),
            if (analytic.amount != null)
              _buildDetailRow('Amount', analytic.amount.toString() ?? ''),
            if (analytic.status == 'meeting_scheduled' &&
                analytic.meetingLink != null)
              InkWell(
                  onTap: () {
                    launchURL(analytic.meetingLink ?? '');
                  },
                  child: _buildDetailRow(
                      'Meeting Link', analytic.meetingLink ?? '')),
            _buildDetailRow('Status', analytic.status ?? '',
                statusColor: _getStatusColor(analytic.status ?? '')),
            const SizedBox(height: 8),
            const Text(
              'Description',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              analytic.description ?? '',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 15),

            if (analytic.referral?.name != '' &&
                analytic.referral?.name != null)
              const Text(
                'Referral Details:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            if (analytic.referral?.name != '' &&
                analytic.referral?.name != null)
              const SizedBox(height: 4),
            if (analytic.referral?.name != '' &&
                analytic.referral?.name != null)
              _buildDetailRow('name', analytic.referral?.name ?? ''),
            if (analytic.referral?.email != '' &&
                analytic.referral?.email != null)
              _buildDetailRow('email', analytic.referral?.email ?? ''),
            if (analytic.referral?.phone != '' &&
                analytic.referral?.phone != null)
              _buildDetailRow('phone', analytic.referral?.phone ?? ''),
            if (analytic.referral?.address != '' &&
                analytic.referral?.address != null)
              _buildDetailRow('address', analytic.referral?.address ?? ''),
            if (analytic.referral?.info != '' &&
                analytic.referral?.info != null)
              _buildDetailRow('info', analytic.referral?.info ?? ''),
            SizedBox(
              height: 20,
            ),
            if (tabBarType == 'sent' || analytic.user_id == id)
              Flexible(
                  child: customButton(
                sideColor: kRedDark,
                buttonColor: kRedDark,
                label: 'Cancel Request',
                onPressed: () async {
                 
                  await analyticsApiService.deleteAnalytic(
                      analyticId: analytic.id ?? '');
                  ref.invalidate(fetchAnalyticsProvider);
                  navigationService.pop();
                },
              )),
            if (tabBarType != 'sent' &&
                tabBarType != 'history' &&
                analytic.status != 'rejected' &&
                analytic.status != 'completed' &&
                analytic.user_id != id)
              Row(
                children: [
                  if (analytic.status != 'meeting_scheduled')
                    Flexible(
                        child: customButton(
                      sideColor: kRedDark,
                      buttonColor: kRedDark,
                      label: 'Reject',
                      onPressed: () async {
                        await analyticsApiService.updateAnalyticStatus(
                            analyticId: analytic.id ?? '', action: 'rejected');
                        ref.invalidate(fetchAnalyticsProvider);
                        navigationService.pop();
                      },
                    )),
                  if (analytic.status != 'meeting_scheduled')
                    SizedBox(
                      width: 20,
                    ),
                  if (analytic.type != 'One v One Meeting' &&
                      analytic.status != 'accepted')
                    Flexible(
                        child: customButton(
                      sideColor: kGreen,
                      buttonColor: kGreen,
                      label: 'Accept',
                      onPressed: () async {
                        await analyticsApiService.updateAnalyticStatus(
                            analyticId: analytic.id ?? '', action: 'accepted');

                        ref.invalidate(fetchAnalyticsProvider);
                        navigationService.pop();
                      },
                    )),
                  if (analytic.type == 'One v One Meeting' &&
                      analytic.status != 'meeting_scheduled')
                    Flexible(
                        child: customButton(
                      sideColor: kGreen,
                      buttonColor: kBlue,
                      label: 'Schedule',
                      onPressed: () async {
                        await analyticsApiService.updateAnalyticStatus(
                            analyticId: analytic.id ?? '',
                            action: 'meeting_scheduled');

                        ref.invalidate(fetchAnalyticsProvider);
                        navigationService.pop();
                      },
                    )),
                  if (analytic.status == 'meeting_scheduled')
                    Flexible(
                        child: customButton(
                      sideColor: kRedDark,
                      buttonColor: kRedDark,
                      label: 'Reject',
                      onPressed: () async {
                        await analyticsApiService.updateAnalyticStatus(
                            analyticId: analytic.id ?? '', action: 'rejected');

                        ref.invalidate(fetchAnalyticsProvider);
                        navigationService.pop();
                      },
                    )),
                  if (analytic.status == 'meeting_scheduled')
                    SizedBox(
                      width: 10,
                    ),
                  if (analytic.status == 'meeting_scheduled')
                    Flexible(
                        child: customButton(
                      sideColor: kGreen,
                      buttonColor: kGreen,
                      label: 'Complete',
                      onPressed: () async {
                        await analyticsApiService.updateAnalyticStatus(
                            analyticId: analytic.id ?? '', action: 'completed');

                        ref.invalidate(fetchAnalyticsProvider);
                        navigationService.pop();
                      },
                    )),
                ],
              )
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? statusColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey),
          ),
          Spacer(),
          if (statusColor != null)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                value,
                style: TextStyle(color: kWhite),
              ),
            )
          else
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "accepted":
        return kGreen;
      case "rejected":
        return kRed;
      case "meeting_scheduled":
        return Color(0xFF2B74E1);
      default:
        return Colors.grey;
    }
  }
}
