import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/models/campaign_model.dart';
import 'package:ipaconnect/src/data/services/api_routes/campain_api/campaign_api.dart';
import 'package:ipaconnect/src/data/notifiers/campaigns_notifier.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_round_button.dart';
import 'package:ipaconnect/src/interfaces/components/loading/loading_indicator.dart';
import 'package:ipaconnect/src/interfaces/main_pages/campaign/campaign_card.dart';
import 'package:ipaconnect/src/interfaces/main_pages/campaigns/campaign_detail_page.dart';

class CampaignsMainScreen extends ConsumerStatefulWidget {
  const CampaignsMainScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CampaignsMainScreen> createState() =>
      _CampaignsMainScreenState();
}

class _CampaignsMainScreenState extends ConsumerState<CampaignsMainScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchInitialCampaigns();
  }

  Future<void> _fetchInitialCampaigns() async {
    await ref.read(campaignsNotifierProvider.notifier).fetchMoreCampaigns();
  }

  void _onScroll() {
    final notifier = ref.read(campaignsNotifierProvider.notifier);
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      notifier.fetchMoreCampaigns();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final campaigns = ref.watch(campaignsNotifierProvider);
    final notifier = ref.read(campaignsNotifierProvider.notifier);
    final isLoading = notifier.isLoading;
    final isFirstLoad = notifier.isFirstLoad;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        centerTitle: true,
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
        title: Text('Campaigns',
            style: kBodyTitleM.copyWith(color: kSecondaryTextColor)),
      ),
      body: RefreshIndicator(
        backgroundColor: kPrimaryColor,
        color: Colors.red,
        onRefresh: () => notifier.refreshCampaigns(),
        child: isFirstLoad
            ? const Center(child: LoadingAnimation())
            : campaigns.isEmpty
                ? Center(child: Text('No Campaigns', style: kBodyTitleB))
                : Column(
                    children: [
                      const SizedBox(height: 20),
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: campaigns.length + 1,
                          itemBuilder: (context, index) {
                            if (index == campaigns.length) {
                              return isLoading
                                  ? const LoadingAnimation()
                                  : const SizedBox.shrink();
                            }
                            final campaign = campaigns[index];
                            final isMyCampaign = false;
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: CampaignCard(
                                campaign: campaign,
                                onLearnMore: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        CampaignDetailPage(campaign: campaign),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
