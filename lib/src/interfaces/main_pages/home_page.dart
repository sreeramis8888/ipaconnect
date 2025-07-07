import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/models/user_model.dart';
import 'package:ipaconnect/src/data/router/nav_router.dart';
import 'package:ipaconnect/src/data/services/api_routes/events_api/events_api_service.dart';
import 'package:ipaconnect/src/data/services/api_routes/news_api/news_api_service.dart';
import 'package:ipaconnect/src/data/services/api_routes/promotions_api/promotions_api_service.dart';
import 'package:ipaconnect/src/data/services/navigation_service.dart';
import 'package:ipaconnect/src/data/services/webview_service.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_round_button.dart';
import 'package:ipaconnect/src/interfaces/components/cards/news_card.dart';
import 'package:ipaconnect/src/interfaces/components/custom_widgets/board_of_director_widget.dart';
import 'package:ipaconnect/src/interfaces/components/custom_widgets/custom_event_widget.dart';
import 'package:ipaconnect/src/interfaces/components/custom_widgets/custom_icon_container.dart';
import 'package:ipaconnect/src/interfaces/components/loading/loading_indicator.dart';
import 'package:ipaconnect/src/interfaces/components/shimmers/promotion_shimmers.dart';
import 'package:ipaconnect/src/interfaces/main_pages/campaign/campaign_card.dart';
import 'package:shimmer/shimmer.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../data/models/promotions_model.dart';
import 'package:ipaconnect/src/interfaces/components/sidebar/custom_sidebar.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

import '../components/custom_widgets/custom_video.dart';

class HomePage extends ConsumerStatefulWidget {
  final UserModel user;
  const HomePage({
    required this.user,
    super.key,
  });

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _advancedDrawerController = AdvancedDrawerController();
  int _currentBannerIndex = 0;
  int _currentNoticeIndex = 0;
  int _currentPosterIndex = 0;
  int _currentEventIndex = 0;
  int _currentVideoIndex = 0;

  double _calculateDynamicHeight(List<Promotion> notices) {
    double maxHeight = 0.0;

    for (var notice in notices) {
      // Estimate height based on the length of title and description
      final double titleHeight =
          _estimateTextHeight(notice.title!, 18.0); // Font size 18 for title
      final double descriptionHeight = _estimateTextHeight(
          notice.description!, 14.0); // Font size 14 for description

      final double itemHeight =
          titleHeight + descriptionHeight; // Adding padding
      if (itemHeight > maxHeight) {
        maxHeight = itemHeight + MediaQuery.sizeOf(context).width * 0.05;
      }
    }
    return maxHeight;
  }

  double _estimateTextHeight(String text, double fontSize) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final int numLines = (text.length / (screenWidth / fontSize)).ceil();
    return numLines * fontSize * 1.2 + 40;
  }

  CarouselController controller = CarouselController();
  String? startDate;
  String? endDate;

  @override
  Widget build(BuildContext context) {
    NavigationService navigationService = NavigationService();
    return Consumer(
      builder: (context, ref, child) {
        final asyncPromotions = ref.watch(promotionsProvider);
        final asyncNewsModel = ref.watch(newsProvider);
        final asyncEvents = ref.watch(eventsProvider);

        return RefreshIndicator(
          color: kPrimaryColor,
          onRefresh: () async {
            ref.invalidate(promotionsApiServiceProvider);
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
              child: asyncPromotions.when(
                data: (promotions) {
                  final banners = promotions
                      .where((promo) => promo.type == 'banner')
                      .toList();
                  final notices = promotions
                      .where((promo) => promo.type == 'notice')
                      .toList();
                  final posters = promotions
                      .where((promo) => promo.type == 'poster')
                      .toList();
                  final videos = promotions
                      .where((promo) => promo.type == 'video')
                      .toList();
                  final filteredVideos = videos
                      .where((video) => video.link!.startsWith('http'))
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
                                    padding: EdgeInsets.only(left: 20),
                                    height: 45.0,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const WebViewScreen(
                                                    backgroundColor:
                                                        kPrimaryColor,
                                                    url:
                                                        'https://www.indotransworld.org/',
                                                    title: 'familytree Connect',
                                                  ),
                                                ),
                                              );
                                            },
                                            child: SizedBox(
                                              width: 40,
                                              height: 40,
                                              child: SvgPicture.asset(
                                                  'assets/svg/icons/ipa_logo.svg'),
                                            )),
                                        Row(
                                          children: [
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
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, top: 10),
                                    child: Text('Welcome, SREERAM ',
                                        style: kLargeTitleB.copyWith(
                                            color: kTextColor)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15,
                                        right: 15,
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
                                  if (banners.isNotEmpty)
                                    Column(
                                      children: [
                                        CarouselSlider(
                                          items: banners.map((banner) {
                                            return _buildBanners(
                                                context: context,
                                                banner: banner);
                                          }).toList(),
                                          options: CarouselOptions(
                                            height: 175,
                                            scrollPhysics: banners.length > 1
                                                ? null
                                                : const NeverScrollableScrollPhysics(),
                                            autoPlay: banners.length > 1
                                                ? true
                                                : false,
                                            viewportFraction: 1,
                                            autoPlayInterval:
                                                const Duration(seconds: 3),
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
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, top: 10),
                                        child: Text('Quick Actions',
                                            style: kBodyTitleB.copyWith(
                                                color: kTextColor)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 15, top: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        CustomIconContainer(
                                            label: 'CSR',
                                            icon: SvgPicture.asset(
                                                color: kWhite,
                                                'assets/svg/icons/csr_icon.svg')),
                                        CustomIconContainer(
                                            label: 'Events',
                                            icon: SvgPicture.asset(
                                                color: kWhite,
                                                'assets/svg/icons/event_icon.svg')),
                                        CustomIconContainer(
                                            label: 'Card',
                                            icon: SvgPicture.asset(
                                                color: kWhite,
                                                'assets/svg/icons/card_icon.svg')),
                                        CustomIconContainer(
                                            label: 'Offers',
                                            icon: SvgPicture.asset(
                                                color: kWhite,
                                                'assets/svg/icons/offer_icon.svg')),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  asyncEvents.when(
                                      data: (events) {
                                        return events.isNotEmpty
                                            ? Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 15,
                                                                top: 10),
                                                        child: Text('Events',
                                                            style: kBodyTitleB),
                                                      ),
                                                    ],
                                                  ),
                                                  CarouselSlider(
                                                    items: events.map((event) {
                                                      return Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.92,
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            navigationService
                                                                .pushNamed(
                                                                    'EventDetails',
                                                                    arguments:
                                                                        event);
                                                          },
                                                          child: eventWidget(
                                                            context: context,
                                                            event: event,
                                                          ),
                                                        ),
                                                      );
                                                    }).toList(),
                                                    options: CarouselOptions(
                                                      enableInfiniteScroll:
                                                          false,
                                                      height: 340,
                                                      scrollPhysics: events
                                                                  .length >
                                                              1
                                                          ? null
                                                          : const NeverScrollableScrollPhysics(),
                                                      autoPlay:
                                                          events.length > 1
                                                              ? true
                                                              : false,
                                                      viewportFraction: 1,
                                                      autoPlayInterval:
                                                          const Duration(
                                                              seconds: 3),
                                                      onPageChanged:
                                                          (index, reason) {
                                                        setState(() {
                                                          _currentEventIndex =
                                                              index;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : const SizedBox();
                                      },
                                      loading: () => const Center(
                                          child: LoadingAnimation()),
                                      error: (error, stackTrace) {
                                        print(error);
                                        print(stackTrace);
                                        return const SizedBox();
                                      }),
                                  const SizedBox(height: 16),
                                  if (notices.isNotEmpty)
                                    Column(
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
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        if (notices.length > 1)
                                          _buildDotIndicator(
                                              _currentNoticeIndex,
                                              notices.length,
                                              const Color.fromARGB(
                                                  255, 39, 38, 38)),
                                      ],
                                    ),
                                  if (posters.isNotEmpty)
                                    Padding(
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
                                              height: 420,
                                              scrollPhysics: posters.length > 1
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
                                  const SizedBox(height: 16),
                                  asyncNewsModel.when(
                                    data: (news) {
                                      return news.isNotEmpty
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 15,
                                                          top: 10,
                                                          right: 15),
                                                  child: Row(
                                                    children: [
                                                      Text('Latest News',
                                                          style: kBodyTitleB),
                                                      const Spacer(),
                                                      InkWell(
                                                        onTap: () => ref
                                                            .read(
                                                                selectedIndexProvider
                                                                    .notifier)
                                                            .updateIndex(3),
                                                        child: Text('see all',
                                                            style:
                                                                kSmallTitleR),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                SizedBox(
                                                  height: 180,
                                                  child: ListView.builder(
                                                    controller:
                                                        ScrollController(),
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount: news.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      final individualNewsModel =
                                                          news[index];
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    8.0),
                                                        child: SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.45,
                                                          child: newsCard(
                                                            onTap: () {
                                                              ref
                                                                  .read(selectedIndexProvider
                                                                      .notifier)
                                                                  .updateIndex(
                                                                      3);
                                                            },
                                                            imageUrl:
                                                                individualNewsModel
                                                                        .media ??
                                                                    '',
                                                            title:
                                                                individualNewsModel
                                                                        .title ??
                                                                    '',
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            )
                                          : const SizedBox();
                                    },
                                    loading: () =>
                                        const Center(child: LoadingAnimation()),
                                    error: (error, stackTrace) =>
                                        const SizedBox(),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
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
                                                child: CampaignCard(
                                                  tag: 'CSR',
                                                  onDonate: () {},
                                                ));
                                          }).toList(),
                                          options: CarouselOptions(
                                            height: 420,
                                            scrollPhysics: posters.length > 1
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
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                      width: double.infinity,
                                      height: 400,
                                      child: BoardOfDirectorsCarousel()),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  // Videos Carousel
                                  if (filteredVideos.isNotEmpty)
                                    Column(
                                      children: [
                                        CarouselSlider(
                                          items: filteredVideos.map((video) {
                                            return customVideo(
                                                context: context, video: video);
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
                                        if (videos.length > 1)
                                          _buildDotIndicator(
                                              _currentVideoIndex,
                                              filteredVideos.length,
                                              Colors.black),
                                      ],
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
                      child: SingleChildScrollView(
                        child: buildShimmerPromotionsColumn(context: context),
                      ),
                    ),
                  ),
                ),
                error: (error, stackTrace) {
                  log(error.toString(), name: 'PROMOTION FETCH ERROR');
                  return SafeArea(
                    child: Scaffold(
                      backgroundColor: kBackgroundColor,
                      body: Container(
                        decoration: const BoxDecoration(color: kBackgroundColor),
                        child: const Center(child: Text('NO PROMOTIONS YET')),
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

  Widget _buildStatCard(String title, String value) {
    return InkWell(
      onTap: () {
        String? initialTab;
        String? requestType;

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
            initialTab = 'sent'; // or 'received' based on your preference
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
          color: Colors.white,
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
        effect: WormEffect(
          dotHeight: 10,
          dotWidth: 10,
          activeDotColor: color,
          dotColor: Colors.grey,
        ),
      ),
    );
  }
}

Widget _buildBanners(
    {required BuildContext context, required Promotion banner}) {
  return Container(
    width: MediaQuery.sizeOf(context).width / 1.15,
    child: AspectRatio(
      aspectRatio: 2 / 1,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Image.network(
                banner.media ?? '',
                fit: BoxFit.fill,
                errorBuilder: (context, error, stackTrace) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                      ),
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }

                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget customPoster({
  required BuildContext context,
  required Promotion poster,
}) {
  return GestureDetector(
    onTap: () {
      if (poster.link != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WebViewScreen(
              backgroundColor: Colors.blue,
              url: poster.link ?? "",
              title: poster.title ?? '',
            ),
          ),
        );
      }
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10), // Apply the border radius here
        child: AspectRatio(
          aspectRatio: 19 / 20,
          child: Image.network(
            poster.media ?? '',
            fit: BoxFit.cover,
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
              // While the image is loading, show shimmer effect
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
  );
}

Widget customNotice({
  required BuildContext context,
  required Promotion notice,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(
        horizontal: 16), // Adjust spacing between posters
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
            offset: const Offset(
                0, 5), // Horizontal (0), Vertical (5) for bottom shadow
          ),
        ],
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: kPrimaryColor,
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
                    style: kSubHeadingB.copyWith(color: kPrimaryColor),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Container(
                      width: 70, // Width of the line
                      height: 1, // Thickness of the line
                      color: kPrimaryColor // Line color
                      ),
                ),
                const SizedBox(height: 4),
                Center(
                  child: Text(
                    notice.title!,
                    style: kSmallTitleB.copyWith(color: kBlack),
                  ),
                ),
                const SizedBox(height: 4),
                Center(
                  child: Container(
                      width: 70, // Width of the line
                      height: 1, // Thickness of the line
                      color: kPrimaryColor // Line color
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  notice.description?.trim() ?? '',
                  style: const TextStyle(color: kGreyDark // Set the font color
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
