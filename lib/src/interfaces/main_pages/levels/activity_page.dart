import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/models/analytics_model.dart';
import 'package:ipaconnect/src/data/services/api_routes/analytics_api/analytics_api.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_round_button.dart';
import 'package:ipaconnect/src/interfaces/components/loading/loading_indicator.dart';

class ActivityPage extends ConsumerWidget {
  final String hierarchyId;
  const ActivityPage({Key? key, required this.hierarchyId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncActivities =
        ref.watch(fetchAnalyticsByHierarchyProvider(hierarchyId));

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
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
        title: Text('Activities',
            style:
                kBodyTitleR.copyWith(fontSize: 16, color: kSecondaryTextColor)),
        centerTitle: false,
      ),
      body: asyncActivities.when(
        data: (activities) {
          if (activities.isEmpty) {
            return Center(
                child: Text(
              'No Activity Found',
              style: kSmallTitleR,
            ));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final activity = activities[index];
              final formattedDate = activity.createdAt != null
                  ? DateFormat('dd.MM.yyyy').format(activity.createdAt!)
                  : '';
              return Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: kCardBackgroundColor,
                    border: Border.all(
                      color: kStrokeColor,
                    )),
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
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
                                Text(
                                  activity.type == 'Business'
                                      ? 'Business Seller'
                                      : "Host",
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          activity.sender?.image ?? ''),
                                      backgroundColor: kStrokeColor,
                                      child: activity.sender?.image != null
                                          ? null
                                          : Icon(Icons.person, color: kWhite),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        style: kSmallTitleR,
                                        activity.sender?.name ??
                                            activity.sender?.toString() ??
                                            '',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 5,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  activity.type == 'Business'
                                      ? 'Business Buyer'
                                      : "Guest",
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        style: kSmallTitleR,
                                        activity.receiver?.name ??
                                            activity.receiver?.toString() ??
                                            '',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 5,
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          activity.receiver?.image ?? ''),
                                      backgroundColor: kStrokeColor,
                                      child: activity.receiver?.image != null
                                          ? null
                                          : Icon(Icons.person, color: kWhite),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (activity.type == 'Referral' &&
                          activity.referral != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            Text('Referral', style: kSmallTitleB),
                            const SizedBox(height: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Name: ',
                                      style: kSmallerTitleR,
                                    ),
                                    Expanded(
                                      child: Text(
                                        style: kSmallerTitleR,
                                        activity.referral?.name ?? '',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 5,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      'Email: ',
                                      style: kSmallerTitleR,
                                    ),
                                    Expanded(
                                      child: Text(
                                        style: kSmallerTitleR,
                                        activity.referral?.email ?? '',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 5,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      'Phone: ',
                                      style: kSmallerTitleR,
                                    ),
                                    Expanded(
                                      child: Text(
                                        activity.referral?.phone ?? '',
                                        style: kSmallerTitleR,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 5,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      const Divider(
                        height: 24,
                        thickness: 1,
                        color: kStrokeColor,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              activity.title ?? '',
                              style: const TextStyle(
                                color: kWhite,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 5,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (activity.type == 'Business')
                            Text.rich(
                              TextSpan(
                                text: 'Amount Paid: ',
                                style:
                                    const TextStyle(color: kSecondaryTextColor),
                                children: [
                                  TextSpan(
                                    text: activity.amount?.toString() ?? '',
                                    style: const TextStyle(color: Colors.blue),
                                  ),
                                ],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          Text(
                            formattedDate,
                            style: const TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: LoadingAnimation()),
        error: (e, st) => const Center(child: Text('No Activities')),
      ),
    );
  }
}
