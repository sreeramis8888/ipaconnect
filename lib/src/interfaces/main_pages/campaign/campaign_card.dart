import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/models/campaign_model.dart';
import 'package:ipaconnect/src/data/models/home_model.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_button.dart';

class CampaignCard extends StatelessWidget {
  final CampaignModel campaign;
  final VoidCallback? onLearnMore;

  const CampaignCard({
    Key? key,
    required this.campaign,
    this.onLearnMore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int collected = 3200;
    final int target = 5000;

    final progress = (collected / target).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: kStrokeColor),
        color: kCardBackgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: AspectRatio(
              aspectRatio: 15 / 8,
              child: Image.network(campaign.media ?? ''),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '#tag',
                        style: const TextStyle(
                            color: kWhite,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Row(
                //   children: [
                //     Text(
                //       '₹$collected',
                //       style: kSubHeadingB.copyWith(color: kGreen),
                //     ),
                //     const SizedBox(width: 4),
                //     const Text('collected out of '),
                //     Text(
                //       '₹$target',
                //       style: kSmallTitleB,
                //     ),
                //     const SizedBox(width: 8),
                //     Expanded(
                //       child: LinearProgressIndicator(
                //         value: progress,
                //         backgroundColor: kGreyLight,
                //         color: kGreen,
                //         minHeight: 7,
                //         borderRadius: BorderRadius.circular(8),
                //       ),
                //     ),
                //   ],
                // ),
                const SizedBox(height: 8),
                if (campaign.targetDate != null)
                  Row(
                    children: [
                      Text('DUE DATE',
                          style: kSmallerTitleB.copyWith(
                              color: kGrey, fontSize: 10)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: kStrokeColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_month,
                                color: kWhite, size: 12),
                            const SizedBox(width: 4),
                            Text(
                              DateFormat('d MMMM y')
                                  .format(campaign.targetDate!),
                              style: kSmallerTitleB.copyWith(
                                  color: kPrimaryLightColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 10),
                Text(
                  campaign.name ?? '',
                  style: kSubHeadingB,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  campaign.description ?? '',
                  style: kSmallerTitleR,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: customButton(
                        labelColor: kWhite,
                        sideColor: kStrokeColor,
                        buttonColor: kStrokeColor,
                        label: 'Learn More',
                        onPressed: onLearnMore ?? () {},
                      ),
                    ),
                    // const SizedBox(width: 12),
                    // Expanded(
                    //   child: customButton(
                    //     label: 'Donate Now',
                    //     onPressed: onDonate,
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
