import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/models/campaign_model.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_round_button.dart';
import 'package:ipaconnect/src/interfaces/components/animations/staggered_entrance.dart';

class CampaignDetailPage extends StatefulWidget {
  final CampaignModel campaign;
  const CampaignDetailPage({super.key, required this.campaign});

  @override
  State<CampaignDetailPage> createState() => _CampaignDetailPageState();
}

class _CampaignDetailPageState extends State<CampaignDetailPage> {
  @override
  Widget build(BuildContext context) {
    final campaign = widget.campaign;

    final target = campaign.targetAmount ?? 0;
    // final progress = (100 / target).clamp(0.0, 1.0);
    final dueDate = DateFormat('dd MMM yyyy').format(campaign.targetDate!);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF090D2C),
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
        centerTitle: true,
        title: Text('Campaign Details', style: kBodyTitleM),
      ),
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: StartupStagger(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                StaggerItem(
                  order: 0,
                  from: SlideFrom.bottom,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.network(
                          campaign.media ?? '',
                          fit: BoxFit.cover,
                        )),
                  ),
                ),
                const SizedBox(height: 12),
                StaggerItem(
                  order: 1,
                  from: SlideFrom.bottom,
                  child: Row(
                    children: [
                      Text('AED$target', style: kSmallTitleB),
                      const SizedBox(width: 60),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                StaggerItem(
                  order: 2,
                  from: SlideFrom.bottom,
                  child: Row(
                    children: [
                      Text('DUE DATE',
                          style: kSmallerTitleB.copyWith(color: kGrey, fontSize: 10)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: kStrokeColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_month, color: kPrimaryColor, size: 12),
                            const SizedBox(width: 4),
                            Text(
                              dueDate,
                              style: kSmallerTitleB.copyWith(color: kPrimaryColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                StaggerItem(
                  order: 3,
                  from: SlideFrom.bottom,
                  child: Text(
                    campaign.name ?? '',
                    style: kSubHeadingB.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                StaggerItem(
                  order: 4,
                  from: SlideFrom.bottom,
                  child: Text(
                    campaign.organizer ?? '',
                    style: kSmallerTitleR,
                  ),
                ),
                const SizedBox(height: 18),
                StaggerItem(
                  order: 5,
                  from: SlideFrom.bottom,
                  child: Text(
                    campaign.description ?? '',
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 12,
                        color: kSecondaryTextColor),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
