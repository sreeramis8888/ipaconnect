import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/models/user_model.dart';
import 'package:ipaconnect/src/data/router/nav_router.dart';
import 'package:ipaconnect/src/data/services/navigation_service.dart';
import 'package:ipaconnect/src/data/utils/launch_url.dart';
import 'package:ipaconnect/src/data/utils/white_status_bar.dart';

import 'package:ipaconnect/src/interfaces/components/buttons/custom_round_button.dart';
import 'package:ipaconnect/src/interfaces/components/cards/news_card.dart';
import 'package:ipaconnect/src/interfaces/components/custom_widgets/custom_event_widget.dart';
import 'package:ipaconnect/src/interfaces/components/custom_widgets/custom_icon_container.dart';
import 'package:ipaconnect/src/interfaces/components/loading/loading_indicator.dart';
import 'package:ipaconnect/src/interfaces/main_pages/campaign/campaign_card.dart';
import 'package:ipaconnect/src/interfaces/main_pages/news_bookmark/news_page.dart';
import 'package:ipaconnect/src/interfaces/main_pages/profile/digital_card.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../data/models/promotions_model.dart';
import 'package:ipaconnect/src/interfaces/main_pages/sidebar/custom_sidebar.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import '../components/custom_widgets/custom_video.dart';
import 'package:ipaconnect/src/data/services/api_routes/home_api/home_api_service.dart';
import 'package:ipaconnect/src/data/services/api_routes/notification_api/notification_api_service.dart';
// Unused imports removed
import 'campaigns/campaign_detail_page.dart';

class HomePage extends ConsumerStatefulWidget {
  final UserModel user;
  const HomePage({
    required this.user,
    super.key,
  });

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with TickerProviderStateMixin {
  final _advancedDrawerController = AdvancedDrawerController();
  int _currentBannerIndex = 0;
  int _currentNoticeIndex = 0;
  int _currentPosterIndex = 0;
  int _currentVideoIndex = 0;
  late final AnimationController _startupController;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    // _notificationsFuture will be initialized in build with ref
    _startupController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void dispose() {
    _startupController.dispose();
    super.dispose();
  }

  Widget _buildStaggered(
      {required int order,
      required Offset beginOffset,
      required Widget child}) {
    final double start = (order * 0.08).clamp(0.0, 1.0);
    final double end = (start + 0.45).clamp(0.0, 1.0);
    final animation = CurvedAnimation(
      parent: _startupController,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(begin: beginOffset, end: Offset.zero)
            .animate(animation),
        child: child,
      ),
    );
  }

  Widget _animateFromLeft({required int order, required Widget child}) {
    return _buildStaggered(
        order: order, beginOffset: const Offset(-0.1, 0), child: child);
  }

  Widget _animateFromBottom({required int order, required Widget child}) {
    return _buildStaggered(
        order: order, beginOffset: const Offset(0, 0.1), child: child);
  }

  Widget _animatedSection({required int order, required Widget child}) {
    return _animateFromBottom(order: order, child: child);
  }

  // Future<List<NotificationModel>> _fetchNotifications(WidgetRef ref) async {
  //   final notificationApiService = ref.read(notificationApiServiceProvider);
  //   final notifications = await notificationApiService.fetchNotifications();
  //   setState(() {
  //     _notifications = notifications;
  //   });
  //   return notifications;
  // }

  double _calculateDynamicHeight(List<Promotion> notices) {
    double maxHeight = 0.0;

    for (var notice in notices) {
      final double titleHeight = _estimateTextHeight(notice.title!, 18.0);
      final double descriptionHeight =
          _estimateTextHeight(notice.description!, 14.0);

      final double itemHeight = titleHeight + descriptionHeight;
      if (itemHeight > maxHeight) {
        maxHeight = itemHeight + MediaQuery.sizeOf(context).width * 0.05;
      }
    }
    return maxHeight + 50;
  }

  double _estimateTextHeight(String text, double fontSize) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final int numLines = (text.length / (screenWidth / fontSize)).ceil();
    return numLines * fontSize * 1.2 + 6;
  }

  double _posterCarouselHeight(List<Promotion> posters) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double posterImageHeight = (screenWidth - 32) * 4 / 3;
    final bool anyPosterHasLink = posters.any((p) => p.link != null);
    final double buttonBlockHeight = anyPosterHasLink ? 50.0 : 0.0;
    return posterImageHeight + buttonBlockHeight;
  }

  CarouselController controller = CarouselController();
  String? startDate;
  String? endDate;

  @override
  Widget build(BuildContext context) {
    NavigationService navigationService = NavigationService();
    return Consumer(
      builder: (context, ref, child) {
        final asyncHomeData = ref.watch(homeDataProvider);
        return RefreshIndicator(
          backgroundColor: kCardBackgroundColor,
          color: kPrimaryColor,
          onRefresh: () async {
            ref.invalidate(homeDataProvider);
          },
          child: AdvancedDrawer(
            backdropColor: kBackgroundColor,
            controller: _advancedDrawerController,
            rtlOpening: true,
            drawer: CustomAdvancedDrawerMenu(
              user: widget.user,
              parentContext: context,
            ),
            child: GestureDetector(
              onHorizontalDragStart: (_) {},
              child: asyncHomeData.when(
                data: (homeData) {
                  if (homeData == null) {
                    return const Center(child: Text('No home data available'));
                  }
                  if (!_hasAnimated) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (!mounted || _hasAnimated) return;
                      _startupController.reset();
                      _startupController.forward();
                      _hasAnimated = true;
                    });
                  }
                  final banners = homeData.banners;
                  final notices = homeData.notices;
                  final posters = homeData.posters;
                  final videos = homeData.videos;
                  final event = homeData.event;
                  final news = homeData.news;
                  final campaign = homeData.campaign;
                  final filteredVideos = videos
                      .where((video) =>
                          video.link != null && video.link!.startsWith('http'))
                      .toList();
                  return SafeArea(
                    child: Scaffold(
                      backgroundColor: kBackgroundColor,
                      body: Container(
                        decoration:
                            const BoxDecoration(color: kBackgroundColor),
                        child: Stack(
                          children: [
                            SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(left: 16),
                                    height: 45.0,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                            onTap: () {},
                                            child: SizedBox(
                                              width: 80,
                                              height: 80,
                                              child: SvgPicture.asset(
                                                  'assets/svg/ipaconnect_logo.svg'),
                                            )),
                                        Row(
                                          children: [
                                            Consumer(
                                              builder: (context, ref, _) {
                                                final asyncNotification = ref.watch(
                                                    fetchNotificationsProvider);
                                                return asyncNotification.when(
                                                  data: (notifications) {
                                                    final notificationCount =
                                                        notifications.length;
                                                    return Stack(
                                                      children: [
                                                        CustomRoundButton(
                                                          onTap: () async {
                                                            navigationService.pushNamed(
                                                                'NotificationPage',
                                                                arguments:
                                                                    notifications);
                                                            ref.invalidate(
                                                                fetchNotificationsProvider);
                                                          },
                                                          iconPath:
                                                              'assets/svg/icons/notification_icon.svg',
                                                        ),
                                                        if (notificationCount >
                                                            0)
                                                          Positioned(
                                                            right: 0,
                                                            top: 0,
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: kRed,
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              constraints:
                                                                  const BoxConstraints(
                                                                minWidth: 10,
                                                                minHeight: 10,
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  notificationCount
                                                                      .toString(),
                                                                  style: kSmallTitleB
                                                                      .copyWith(
                                                                    color:
                                                                        kWhite,
                                                                    fontSize:
                                                                        10,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                      ],
                                                    );
                                                  },
                                                  loading: () => Stack(
                                                    children: [
                                                      CustomRoundButton(
                                                        onTap: () async {
                                                          navigationService
                                                              .pushNamed(
                                                                  'NotificationPage',
                                                                  arguments: []);
                                                        },
                                                        iconPath:
                                                            'assets/svg/icons/notification_icon.svg',
                                                      ),
                                                    ],
                                                  ),
                                                  error: (error, stackTrace) =>
                                                      CustomRoundButton(
                                                    onTap: () async {
                                                      navigationService
                                                          .pushNamed(
                                                              'NotificationPage',
                                                              arguments: []);
                                                    },
                                                    iconPath:
                                                        'assets/svg/icons/notification_icon.svg',
                                                  ),
                                                );
                                              },
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            CustomRoundButton(
                                                onTap: () {
                                                  _advancedDrawerController
                                                      .showDrawer();
                                                },
                                                iconPath:
                                                    'assets/svg/icons/menu_icon.svg'),
                                            SizedBox(
                                              width: 10,
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  _animateFromLeft(
                                    order: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16, top: 10, right: 16),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Welcome, ${widget.user.name} ',
                                              style: kLargeTitleB.copyWith(
                                                  color: kTextColor)),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      DigitalCardPage(
                                                          user: widget.user),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              width: 38,
                                              height: 38,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                gradient: const RadialGradient(
                                                  center: Alignment.topLeft,
                                                  radius: 1.2,
                                                  colors: [
                                                    Color(0x802EA7FF),
                                                    Color(0x331C1B33),
                                                  ],
                                                  stops: [0.0, .7],
                                                ),
                                                border: Border.all(
                                                  color: Color(0x1A17B9FF),
                                                  width: 1.2,
                                                ),
                                              ),
                                              child: Icon(
                                                Icons.qr_code,
                                                color: kWhite,
                                                size: 25,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  _animateFromLeft(
                                    order: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16,
                                          right: 16,
                                          top: 10,
                                          bottom: 20),
                                      child: Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              style: kSmallerTitleR.copyWith(
                                                  color: kTextColor),
                                              'Here\'s to growing your family story, one branch at a time.',
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (banners.isNotEmpty)
                                    _animatedSection(
                                      order: 4,
                                      child: Column(
                                        children: [
                                          CarouselSlider(
                                            items: banners.map((banner) {
                                              return _buildBanners(
                                                  context: context,
                                                  banner: banner);
                                            }).toList(),
                                            options: CarouselOptions(
                                              height: 200,
                                              scrollPhysics: banners.length > 1
                                                  ? null
                                                  : const NeverScrollableScrollPhysics(),
                                              autoPlay: banners.length > 1
                                                  ? true
                                                  : false,
                                              viewportFraction: 1,
                                              autoPlayInterval:
                                                  const Duration(seconds: 5),
                                              onPageChanged: (index, reason) {
                                                setState(() {
                                                  _currentBannerIndex = index;
                                                });
                                              },
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                        ],
                                      ),
                                    ),
                                  if (banners.length > 1)
                                    _buildDotIndicator(
                                        _currentBannerIndex,
                                        banners.length,
                                        // videos.length,
                                        kWhite),

                                  _animateFromBottom(
                                    order: 2,
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 16, top: 10),
                                          child: Text('Quick Actions',
                                              style: kBodyTitleB.copyWith(
                                                  color: kTextColor)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  _animateFromBottom(
                                    order: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16, right: 16, top: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                                           CustomIconContainer(
                                              onTap: () {
                                                ref
                                                    .read(selectedIndexProvider
                                                        .notifier)
                                                    .updateIndex(1);
                                              },
                                              label: 'Business',
                                              icon: SvgPicture.asset(
                                                  color: kWhite,
                                                  'assets/svg/icons/bussiness_icon.svg')), 
                                          CustomIconContainer(
                                              onTap: () {
                                                Navigator.pushNamed(
                                                    context, 'EventsPage');
                                              },
                                              label: 'Events',
                                              icon: SvgPicture.asset(
                                                  color: kWhite,
                                                  'assets/svg/icons/event_icon1.svg')),
                                          if (widget.user.phone !=
                                              '+919645398555')
                                          CustomIconContainer(
                                              label: 'Store',
                                              onTap: () {
                                                Navigator.pushNamed(
                                                    arguments:
                                                        widget.user.countryCode,
                                                    context,
                                                    'StorePage');
                                              },
                                              icon: SvgPicture.asset(
                                                  color: kWhite,
                                                  'assets/svg/icons/store_icon1.svg')),
                       
                                                   CustomIconContainer(
                                              onTap: () {
                                                Navigator.pushNamed(
                                                    arguments:
                                                        widget.user.countryCode,
                                                    context,
                                                    'CampaignsMainScreen');
                                              },
                                              label: 'CSR',
                                              icon: SvgPicture.asset(
                                                  color: kWhite,
                                                  'assets/svg/icons/csr_icon1.svg')),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),

                                  if (event != null)
                                    _animatedSection(
                                      order: 5,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text('Event',
                                                    style: kBodyTitleB),
                                                const Spacer(),
                                                GestureDetector(
                                                  onTap: () {
                                                    navigationService.pushNamed(
                                                        'EventsPage');
                                                  },
                                                  child: Text('View All',
                                                      style:
                                                          kSmallTitleL.copyWith(
                                                              color:
                                                                  kPrimaryColor)),
                                                ),
                                              ],
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                navigationService.pushNamed(
                                                    'EventDetails',
                                                    arguments: event);
                                              },
                                              child: eventWidget(
                                                context: context,
                                                event: event,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                  if (posters.isNotEmpty)
                                    _animatedSection(
                                      order: 7,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 20),
                                        child: Column(
                                          children: [
                                            CarouselSlider(
                                              items: posters
                                                  .asMap()
                                                  .entries
                                                  .map((entry) {
                                                int index = entry.key;
                                                Promotion poster = entry.value;

                                                return KeyedSubtree(
                                                  key: ValueKey(index),
                                                  child: customPoster(
                                                      context: context,
                                                      poster: poster),
                                                );
                                              }).toList(),
                                              options: CarouselOptions(
                                                height: _posterCarouselHeight(
                                                    posters),
                                                scrollPhysics: posters.length >
                                                        1
                                                    ? null
                                                    : const NeverScrollableScrollPhysics(),
                                                autoPlay: posters.length > 1,
                                                viewportFraction: 1,
                                                autoPlayInterval:
                                                    const Duration(seconds: 5),
                                                onPageChanged: (index, reason) {
                                                  setState(() {
                                                    _currentPosterIndex = index;
                                                  });
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),

                                  if (posters.length > 1)
                                    _buildDotIndicator(
                                        _currentPosterIndex,
                                        posters.length,
                                        // videos.length,
                                        kWhite),

                                  if (news.isNotEmpty)
                                    _animatedSection(
                                      order: 8,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15, top: 24, right: 15),
                                            child: Row(
                                              children: [
                                                Text('Latest News',
                                                    style: kBodyTitleB),
                                                const Spacer(),
                                                GestureDetector(
                                                  onTap: () => ref
                                                      .read(
                                                          selectedIndexProvider
                                                              .notifier)
                                                      .updateIndex(3),
                                                  child: Text('see all',
                                                      style: kSmallTitleL),
                                                )
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          SizedBox(
                                            height: 180,
                                            child: ListView.builder(
                                              controller: ScrollController(),
                                              scrollDirection: Axis.horizontal,
                                              itemCount: news.length,
                                              itemBuilder: (context, index) {
                                                final individualNewsModel =
                                                    news[index];
                                                return Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8.0),
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.45,
                                                    child: newsCard(
                                                      onTap: () {
                                                        ref
                                                            .read(
                                                                currentNewsIndexProvider
                                                                    .notifier)
                                                            .state = index;

                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                NewsDetailView(
                                                                    news: news),
                                                          ),
                                                        );
                                                      },
                                                      imageUrl:
                                                          individualNewsModel
                                                                  .media ??
                                                              '',
                                                      title: individualNewsModel
                                                              .title ??
                                                          '',
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                  const SizedBox(height: 16),
                                  if (notices.isNotEmpty)
                                    _animatedSection(
                                      order: 6,
                                      child: Column(
                                        children: [
                                          CarouselSlider(
                                            items: notices.map((notice) {
                                              return customNotice(
                                                  context: context,
                                                  notice: notice);
                                            }).toList(),
                                            options: CarouselOptions(
                                              scrollPhysics: notices.length > 1
                                                  ? null
                                                  : const NeverScrollableScrollPhysics(),
                                              autoPlay: notices.length > 1
                                                  ? true
                                                  : false,
                                              viewportFraction: 1,
                                              height: _calculateDynamicHeight(
                                                  notices),
                                              autoPlayInterval:
                                                  const Duration(seconds: 3),
                                              onPageChanged: (index, reason) {
                                                setState(() {
                                                  _currentNoticeIndex = index;
                                                });
                                              },
                                            ),
                                          ),
                                          if (notices.isNotEmpty)
                                            const SizedBox(height: 10),
                                          // if (notices.length > 1)
                                          //   _buildDotIndicator(
                                          //       _currentNoticeIndex,
                                          //       notices.length,
                                          //       const Color.fromARGB(
                                          //           255, 39, 38, 38)),
                                        ],
                                      ),
                                    ),

                                  if (notices.length > 1)
                                    _buildDotIndicator(_currentNoticeIndex,
                                        notices.length, kWhite),

                                  if (campaign != null)
                                    _animatedSection(
                                      order: 9,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15, top: 10),
                                                child: Text('Campaign',
                                                    style: kBodyTitleB),
                                              ),
                                              const Spacer(),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 15, top: 10),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    navigationService.pushNamed(
                                                        'CampaignsMainScreen');
                                                  },
                                                  child: Text('View All ',
                                                      style:
                                                          kSmallTitleL.copyWith(
                                                              color:
                                                                  kPrimaryColor)),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0, vertical: 8.0),
                                            child: CampaignCard(
                                              campaign: campaign,
                                              onLearnMore: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        CampaignDetailPage(
                                                            campaign: campaign),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  // Container(
                                  //     width: double.infinity,
                                  //     height: 400,
                                  //     child: BoardOfDirectorsCarousel()),
                                  // SizedBox(
                                  //   height: 20,
                                  // ),
                                  // Videos Carousel
                                  if (filteredVideos.isNotEmpty)
                                    _animatedSection(
                                      order: 10,
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16),
                                            child: CarouselSlider(
                                              items:
                                                  filteredVideos.map((video) {
                                                return customVideo(
                                                    context: context,
                                                    videoUrl: video.link ?? '');
                                              }).toList(),
                                              options: CarouselOptions(
                                                height: 225,
                                                scrollPhysics: videos.length > 1
                                                    ? null
                                                    : const NeverScrollableScrollPhysics(),
                                                viewportFraction: 1,
                                                onPageChanged: (index, reason) {
                                                  setState(() {
                                                    _currentVideoIndex = index;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                          if (videos.length > 1)
                                            _buildDotIndicator(
                                                _currentVideoIndex,
                                                filteredVideos.length,
                                                // videos.length,
                                                kWhite),
                                        ],
                                      ),
                                    ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                loading: () => SafeArea(
                  child: Scaffold(
                    backgroundColor: kBackgroundColor,
                    body: Container(
                      decoration: const BoxDecoration(color: kBackgroundColor),
                      child: const Center(
                        child: LoadingAnimation(),
                      ),
                    ),
                  ),
                ),
                error: (error, stackTrace) {
                  log(error.toString(), name: 'HOME FETCH ERROR');
                  return SafeArea(
                    child: Scaffold(
                      backgroundColor: kBackgroundColor,
                      body: Container(
                        decoration:
                            const BoxDecoration(color: kBackgroundColor),
                        child: const Center(child: Text('NO HOME DATA YET')),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  // Unused legacy widget retained for potential future analytics integration
  Widget _buildStatCard(String title, String value) {
    return GestureDetector(
      onTap: () {
        String? initialTab;
        String? requestType; // reserved for future use

        switch (title) {
          case 'BUSINESS GIVEN':
            initialTab = 'sent';
            requestType = 'Business';
            break;
          case 'BUSINESS RECEIVED':
            initialTab = 'received';
            requestType = 'Business';
            break;
          case 'REFERRALS GIVEN':
            initialTab = 'sent';
            requestType = 'Referral';
            break;
          case 'REFERRALS RECEIVED':
            initialTab = 'received';
            requestType = 'Referral';
            break;
          case 'ONE V ONE MEETINGS':
            initialTab = 'sent';
            requestType = 'One v One Meeting';
            break;
        }

        if (initialTab != null) {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => AnalyticsPage(
          //       initialTab: initialTab,
          //       requestType: requestType,
          //       startDate: startDate?.toString().split(' ')[0],
          //       endDate: endDate?.toString().split(' ')[0],
          //     ),
          //   ),
          // );
        }
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 0,
              blurRadius: 5,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.only(top: 20, bottom: 10, left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: kSmallerTitleR.copyWith(color: kBlack54, fontSize: 11),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: kDisplayTitleB.copyWith(
                  color: const Color(0xFF512DB4), fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  // Method to build a dot indicator for carousels
  Widget _buildDotIndicator(int currentIndex, int itemCount, Color color) {
    return Center(
      child: SmoothPageIndicator(
        controller: PageController(initialPage: currentIndex),
        count: itemCount,
        effect: ExpandingDotsEffect(
          expansionFactor: 3,
          spacing: 8,
          radius: 8,
          dotWidth: 8,
          dotHeight: 8,
          dotColor: Colors.grey,
          activeDotColor: color,
        ),
        // WormEffect(
        //   dotHeight: 10,
        //   dotWidth: 10,
        //   activeDotColor: color,
        //   dotColor: Colors.grey,
        // ),
      ),
    );
  }
}

Widget _buildBanners({
  required BuildContext context,
  required Promotion banner,
}) {
  return SizedBox(
    width: MediaQuery.of(context).size.width * 0.90,
    child: AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Image.network(
          banner.media ?? '',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Shimmer.fromColors(
              baseColor: kCardBackgroundColor,
              highlightColor: kStrokeColor,
              child: Container(color: const Color.fromARGB(255, 24, 34, 13)),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Shimmer.fromColors(
              baseColor: kCardBackgroundColor,
              highlightColor: kStrokeColor,
              child: Container(color: kBackgroundColor),
            );
          },
        ),
      ),
    ),
  );
}

Widget customPoster({
  required BuildContext context,
  required Promotion poster,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: AspectRatio(
            aspectRatio: 3 / 4,
            child: Image.network(
              poster.media ?? '',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                    ),
                  ),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child; // Image loaded successfully
                }

                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      TextButton(
          onPressed: () {
            if (poster.link != null && poster.link!.isNotEmpty) {
              launchURL(poster.link!);
            }
          },
          child: Text('Know More >'))
    ],
  );
}

Widget customNotice({
  required BuildContext context,
  required Promotion notice,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Container(
      width: MediaQuery.of(context).size.width - 32,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCardBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: kBlack.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 5),
          ),
        ],
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: kStrokeColor,
          width: 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Notice',
                    style: kSubHeadingB,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  notice.description?.trim() ?? '',
                  style: const TextStyle(color: kSecondaryTextColor),
                ),
                TextButton(
                    onPressed: () {
                      if (notice.link != null && notice.link!.isNotEmpty) {
                        launchURL(notice.link!);
                      }
                    },
                    child: Text('Know More >'))
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
