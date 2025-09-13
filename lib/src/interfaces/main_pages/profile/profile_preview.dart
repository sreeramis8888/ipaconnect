import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:intl/intl.dart';
import 'package:ipaconnect/src/data/models/user_model.dart';
import 'package:ipaconnect/src/data/services/navigation_service.dart';
import 'package:ipaconnect/src/data/utils/globals.dart';
import 'package:ipaconnect/src/data/utils/share_qr.dart';
import 'package:ipaconnect/src/interfaces/components/animations/glowing_animated_avatar.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_button.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_round_button.dart';
import 'package:ipaconnect/src/interfaces/components/cards/award_card.dart';
import 'package:ipaconnect/src/interfaces/components/cards/certificate_card.dart';
import 'package:ipaconnect/src/interfaces/components/cards/document_card.dart';
// import 'package:ipaconnect/src/interfaces/components/custom_widgets/custom_icon_container.dart';
import 'package:ipaconnect/src/interfaces/components/custom_widgets/custom_video.dart';
import 'package:ipaconnect/src/interfaces/components/loading/loading_indicator.dart';
// import 'package:ipaconnect/src/interfaces/components/shimmers/preview_shimmer.dart';
import 'package:ipaconnect/src/interfaces/components/textFormFields/custom_text_form_field.dart';
import 'package:ipaconnect/src/interfaces/main_pages/business/company_details_page.dart';
import 'package:ipaconnect/src/interfaces/main_pages/profile/digital_card.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:ipaconnect/src/interfaces/components/animations/staggered_entrance.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
// import 'package:ipaconnect/src/data/models/company_model.dart';
import 'package:ipaconnect/src/data/services/api_routes/company_api/company_api_service.dart';
import 'package:ipaconnect/src/interfaces/components/cards/company_card.dart';
import 'package:ipaconnect/src/interfaces/main_pages/business/add_company_page.dart';
import 'package:ipaconnect/src/interfaces/components/custom_widgets/confirmation_dialog.dart';
import 'package:ipaconnect/src/data/services/api_routes/user_api/user_data/user_data_api.dart';
// import 'package:qr_flutter/qr_flutter.dart';
import 'package:ipaconnect/src/data/services/api_routes/enquiry_api/enquiry_api_service.dart';

class ReviewsState extends StateNotifier<int> {
  ReviewsState() : super(1);

  void showMoreReviews(int totalReviews) {
    state = (state + 2).clamp(0, totalReviews);
  }
}

final reviewsProvider = StateNotifierProvider<ReviewsState, int>((ref) {
  return ReviewsState();
});

class ProfilePreviewById extends ConsumerStatefulWidget {
  final String userId;
  const ProfilePreviewById({Key? key, required this.userId}) : super(key: key);

  @override
  ConsumerState<ProfilePreviewById> createState() => _ProfilePreviewByIdState();
}

class _ProfilePreviewByIdState extends ConsumerState<ProfilePreviewById>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
    _selectedTabIndex = _tabController.index;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onAddCompany(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => AddCompanyPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final asyncUser =
        ref.watch(getUserDetailsByIdProvider(userId: widget.userId));
    return asyncUser.when(
      data: (user) {
        if (user == null) {
          return Scaffold(
            backgroundColor: kBackgroundColor,
            body: Center(child: Text('User not found', style: kBodyTitleR)),
          );
        }
        return Scaffold(
          backgroundColor: kBackgroundColor,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // New header
                _ProfileHeader(user: user),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    color: Colors.transparent,
                    child: TabBar(
                      controller: _tabController,
                      indicatorColor: kPrimaryColor,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorWeight: 3,
                      labelColor: kPrimaryColor,
                      dividerColor: Colors.transparent,
                      unselectedLabelColor: kSecondaryTextColor,
                      labelStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      tabs: const [
                        Tab(text: 'Overview'),
                        Tab(text: 'Business'),
                      ],
                    ),
                  ),
                ),
                if (_selectedTabIndex == 0)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: StartupStagger(
                      child: StaggerItem(
                        order: 0,
                        from: SlideFrom.bottom,
                        child: _OverviewTab(user: user),
                      ),
                    ),
                  )
                else
                  StartupStagger(
                    child: StaggerItem(
                      order: 0,
                      from: SlideFrom.bottom,
                      child: _BusinessTab(userId: user.id ?? ''),
                    ),
                  ),
                if (user.id != id) _ContactFormSection(),
              ],
            ),
          ),
          floatingActionButton: _selectedTabIndex == 1 && user.id == id
              ? FloatingActionButton(
                  onPressed: () => _onAddCompany(context),
                  backgroundColor: kPrimaryColor,
                  child: Icon(Icons.add, color: Colors.white),
                  tooltip: 'Add Company',
                )
              : null,
        );
      },
      loading: () => const Scaffold(
        backgroundColor: kBackgroundColor,
        body: Center(child: LoadingAnimation()),
      ),
      error: (e, st) {
        log(e.toString());
        return Scaffold(
          backgroundColor: kBackgroundColor,
          body: Center(child: Text('Failed to load user', style: kBodyTitleR)),
        );
      },
    );
  }
}

class ProfilePreviewFromModel extends ConsumerStatefulWidget {
  final UserModel user;
  const ProfilePreviewFromModel({Key? key, required this.user})
      : super(key: key);

  @override
  ConsumerState<ProfilePreviewFromModel> createState() =>
      _ProfilePreviewFromModelState();
}

class _ProfilePreviewFromModelState
    extends ConsumerState<ProfilePreviewFromModel>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
    _selectedTabIndex = _tabController.index;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onAddCompany(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => AddCompanyPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ProfileHeader(user: user),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  color: Colors.transparent,
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: kPrimaryColor,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorWeight: 3,
                    labelColor: kPrimaryColor,
                    dividerColor: Colors.transparent,
                    unselectedLabelColor: kSecondaryTextColor,
                    labelStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    tabs: const [
                      Tab(text: 'Overview'),
                      Tab(text: 'Business'),
                    ],
                  ),
                ),
              ),
              if (_selectedTabIndex == 0)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: StartupStagger(
                    child: StaggerItem(
                      order: 0,
                      from: SlideFrom.bottom,
                      child: _OverviewTab(user: user),
                    ),
                  ),
                )
              else
                StartupStagger(
                  child: StaggerItem(
                    order: 0,
                    from: SlideFrom.bottom,
                    child: _BusinessTab(userId: user.id ?? ''),
                  ),
                ),
              if (user.id != id) _ContactFormSection(),
            ],
          ),
        ),
        floatingActionButton: _selectedTabIndex == 1 && user.id == id
            ? FloatingActionButton(
                onPressed: () => _onAddCompany(context),
                backgroundColor: kPrimaryColor,
                child: Icon(Icons.add, color: Colors.white),
                tooltip: 'Add Company',
              )
            : null,
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final UserModel user;
  const _ProfileHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 420,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            children: [
              Container(
                height: 185,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/pngs/profile_bg.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                height: 120,
                width: double.infinity,
                color: kBackgroundColor,
              ),
            ],
          ),
          Positioned(
            top: 120,
            left: 0,
            right: 0,
            child: Center(
              child: GlowingAnimatedAvatar(
                imageUrl: user.image,
                defaultAvatarAsset: 'assets/svg/icons/dummy_person_large.svg',
                size: 100,
                glowColor: kPrimaryColor,
                borderColor: kWhite,
                borderWidth: 2.0,
              ),
            ),
          ),
          Positioned(
            top: 210,
            right: 10,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DigitalCardPage(user: user),
                  ),
                );
              },
              child: Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
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
          ),
          if (user.id == id)
            SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: Consumer(
                  builder: (context, ref, child) {
                    return PopupMenuButton<String>(
                      color: kCardBackgroundColor,
                      icon: Icon(Icons.more_vert, color: kWhite),
                      onSelected: (value) {
                        if (value == 'edit') {
                          NavigationService().pushNamed('EditUser');
                        } else if (value == 'share') {
                          captureAndShareOrDownloadWidgetScreenshot(context,
                              user: user);
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Text(
                                'Edit',
                                style: kSmallTitleL,
                              )
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'share',
                          child: Row(
                            children: [Text('Share', style: kSmallTitleL)],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          if (user.id != id)
            Positioned(
              top: 30,
              left: 0,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: CustomRoundButton(
                    offset: Offset(4, 0),
                    iconPath: 'assets/svg/icons/arrow_back_ios.svg',
                  ),
                ),
              ),
            ),
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    'Profile Preview',
                    style: kBodyTitleR,
                  )),
            ),
          ),
          Positioned(
            top: 240,
            left: 0,
            right: 0,
            child: Column(
              children: [
                const SizedBox(height: 16),
                Text(user.name ?? '',
                    style: kHeadTitleB.copyWith(color: kWhite)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        user.profession ?? '',
                        style: kSmallTitleL,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                  ],
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final textPainter = TextPainter(
                      text:
                          TextSpan(text: user.email ?? '', style: kSmallTitleL),
                      maxLines: 1,
                      textDirection: TextDirection.ltr,
                    )..layout(
                        maxWidth: constraints.maxWidth -
                            100); // subtract icons/padding width

                    final fitsInOneLine =
                        textPainter.didExceedMaxLines == false;

                    if (fitsInOneLine) {
                      // Single row
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.phone, color: kWhite, size: 18),
                            const SizedBox(width: 6),
                            Text(user.phone ?? '', style: kSmallTitleL),
                            const SizedBox(width: 18),
                            Icon(Icons.email, color: kWhite, size: 18),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(user.email ?? '', style: kSmallTitleL),
                            ),
                          ],
                        ),
                      );
                    } else {
                      // Column fallback
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.phone, color: kWhite, size: 18),
                              const SizedBox(width: 6),
                              Text(user.phone ?? '', style: kSmallTitleL),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.email, color: kWhite, size: 18),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  user.email ?? '',
                                  style: kSmallTitleL,
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                if (user.location != null && user.location!.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.location_on,
                          color: kSecondaryTextColor, size: 18),
                      const SizedBox(width: 4),
                      Text(user.location!,
                          style: kSmallTitleL.copyWith(
                              color: kSecondaryTextColor)),
                    ],
                  ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Color(0xFF1E62B3).withOpacity(.5),
                          kStrokeColor.withOpacity(.5)
                        ]),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                              height: 20,
                              width: 20,
                              child:
                                  Image.network(user.hierarchy?.image ?? '')),
                          const SizedBox(width: 6),
                          Text(user.memberId ?? '',
                              style: kSmallTitleB.copyWith(color: kWhite)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Removed unused _HeaderButton widget

class _OverviewTab extends StatefulWidget {
  final UserModel user;
  const _OverviewTab({required this.user});

  @override
  State<_OverviewTab> createState() => _OverviewTabState();
}

class _OverviewTabState extends State<_OverviewTab> {
  final ValueNotifier<int> _currentVideo = ValueNotifier<int>(0);
  @override
  Widget build(BuildContext context) {
    PageController _videoCountController = PageController();

    _videoCountController.addListener(() {
      _currentVideo.value = _videoCountController.page!.round();
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.user.bio != null) const SizedBox(height: 8),
        if (widget.user.bio != null)
          Text('About', style: kBodyTitleB.copyWith(color: kWhite)),
        if (widget.user.bio != null)
          if (widget.user.bio != null) const SizedBox(height: 8),
        Text(
          widget.user.bio ?? '',
          style: kSmallTitleL.copyWith(color: kSecondaryTextColor),
        ),
        if (widget.user.bio != null) const SizedBox(height: 24),
        Text('Contact', style: kBodyTitleB.copyWith(color: kWhite)),
        const SizedBox(height: 8),
        if (widget.user.phone != null && widget.user.phone!.isNotEmpty)
          Row(
            children: [
              Icon(Icons.phone, color: kSecondaryTextColor, size: 18),
              const SizedBox(width: 8),
              Text(widget.user.phone!,
                  style: kSmallTitleL.copyWith(color: kSecondaryTextColor)),
            ],
          ),
        const SizedBox(height: 8),
        if (widget.user.email != null && widget.user.email!.isNotEmpty)
          Row(
            children: [
              Icon(Icons.email, color: kSecondaryTextColor, size: 18),
              const SizedBox(width: 8),
              Text(widget.user.email!,
                  style: kSmallTitleL.copyWith(color: kSecondaryTextColor)),
            ],
          ),
        const SizedBox(height: 8),
        if (widget.user.location != null && widget.user.location!.isNotEmpty)
          Row(
            children: [
              Icon(Icons.location_on, color: kSecondaryTextColor, size: 18),
              const SizedBox(width: 8),
              Text(widget.user.location!,
                  style: kSmallTitleL.copyWith(color: kSecondaryTextColor)),
            ],
          ),
        const SizedBox(height: 8),
        if (widget.user.socialMedia != null)
          if (widget.user.socialMedia!.isNotEmpty) const SizedBox(height: 24),
        if (widget.user.socialMedia != null)
          if (widget.user.socialMedia!.isNotEmpty)
            Text('Social Profile & Portfolio',
                style: kBodyTitleB.copyWith(color: kWhite)),
        if (widget.user.socialMedia != null)
          if (widget.user.socialMedia!.isNotEmpty) const SizedBox(height: 12),
        if (widget.user.socialMedia != null &&
            widget.user.socialMedia!.isNotEmpty)
          ...widget.user.socialMedia!.map((sm) => _SocialCard(sm: sm)),
        if (widget.user.websites?.isNotEmpty == true)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Text('Websites & Links', style: kBodyTitleB),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                if (widget.user.websites?.isNotEmpty == true)
                  for (int index = 0;
                      index < widget.user.websites!.length;
                      index++)
                    _SocialCard(
                        sm: SubData(
                            link: widget.user.websites![index].link,
                            name: widget.user.websites![index].name)),
              ],
            ),
          ),
        if (widget.user.videos?.isNotEmpty == true)
          Row(
            children: [
              Text('videos', style: kBodyTitleB),
            ],
          ),
        if (widget.user.videos?.isNotEmpty == true)
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 220,
                child: PageView.builder(
                  controller: _videoCountController,
                  itemCount: widget.user.videos!.length,
                  physics: const PageScrollPhysics(),
                  itemBuilder: (context, index) {
                    return customVideo(
                        context: context,
                        videoUrl: widget.user.videos![index].link ?? '');
                  },
                ),
              ),
              ValueListenableBuilder<int>(
                valueListenable: _currentVideo,
                builder: (context, value, child) {
                  return SmoothPageIndicator(
                    controller: _videoCountController,
                    count: widget.user.videos!.length,
                    effect: const ExpandingDotsEffect(
                        dotHeight: 8,
                        dotWidth: 6,
                        activeDotColor: kPrimaryColor,
                        dotColor: kStrokeColor),
                  );
                },
              ),
            ],
          ),
        if (widget.user.videos?.isNotEmpty == true)
          SizedBox(
            height: 15,
          ),
        if (widget.user.awards?.isNotEmpty == true)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  'Awards',
                  style: kBodyTitleB,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 0.9,
                ),
                itemCount: widget.user.awards!.length,
                itemBuilder: (context, index) {
                  return AwardCard(
                    onEdit: null,
                    award: widget.user.awards![index],
                    onRemove: null,
                  );
                },
              ),
            ],
          ),
        SizedBox(
          height: 10,
        ),
        if (widget.user.certificates?.isNotEmpty == true)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text('Certificates', style: kBodyTitleB),
              ),
              SizedBox(
                height: 10,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: widget.user.certificates!.length,
                itemBuilder: (context, index) {
                  return CertificateCard(
                    onEdit: null,
                    certificate: widget.user.certificates![index],
                    onRemove: null,
                  );
                },
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        if (widget.user.documents != null && widget.user.documents!.isNotEmpty)
          Row(
            children: [
              Text('Documents', style: kBodyTitleR),
            ],
          ),
        if (widget.user.documents != null && widget.user.documents!.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.user.documents!.length,
            itemBuilder: (context, index) {
              return DocumentCard(
                brochure: widget.user.documents![index],
                // onRemove: () => _removeCertificateCard(index),
              );
            },
          ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

class _SocialCard extends StatelessWidget {
  final dynamic sm;
  const _SocialCard({required this.sm});

  @override
  Widget build(BuildContext context) {
    final String? socialUrl =
        sm is UserSocialMedia ? sm.url : (sm is SubData ? sm.link : null);

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: kCardBackgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: kStrokeColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child:
                Icon(_getSocialIcon(sm.name), color: kPrimaryColor, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sm.name ?? '',
                  style: kSmallTitleB.copyWith(color: kWhite),
                ),
                const SizedBox(height: 4),
                Text(
                  socialUrl ?? '',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: kSmallTitleL.copyWith(color: kSecondaryTextColor),
                ),
              ],
            ),
          ),
          if (socialUrl != null)
            GestureDetector(
              onTap: () => _launchURL(context, socialUrl),
              child:
                  Icon(Icons.open_in_new, color: kSecondaryTextColor, size: 20),
            ),
        ],
      ),
    );
  }
}

IconData _getSocialIcon(String? name) {
  if (name == null) return FontAwesomeIcons.globe;
  final lower = name.toLowerCase();
  if (lower.contains('instagram')) {
    return FontAwesomeIcons.instagram;
  } else if (lower.contains('linkedin')) {
    return FontAwesomeIcons.linkedinIn;
  } else if (lower.contains('twitter')) {
    return FontAwesomeIcons.xTwitter;
  } else if (lower.contains('facebook')) {
    return FontAwesomeIcons.facebookF;
  } else if (lower.contains('website')) {
    return FontAwesomeIcons.globe;
  } else if (lower.contains('portfolio')) {
    return Icons.work;
  }
  return Icons.link;
}

void _launchURL(BuildContext context, String? url) async {
  if (url == null || url.isEmpty) return;
  final uri = Uri.tryParse(url.startsWith('http') ? url : 'https://$url');
  if (uri == null) return;
  try {
    await launchUrl(uri);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Could not launch URL')),
    );
  }
}

class _BusinessTab extends ConsumerWidget {
  final String userId;
  const _BusinessTab({required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncCompanies =
        ref.watch(getCompaniesByUserIdProvider(userId: userId));
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 16, right: 16, left: 16, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('My Companies', style: kBodyTitleB.copyWith(color: kWhite)),
            ],
          ),
        ),
        SizedBox(
          height: 8,
        ),
        asyncCompanies.when(
          data: (companies) {
            if (companies.isEmpty) {
              return Center(
                child: Text('No companies found.',
                    style: kBodyTitleR.copyWith(color: kWhite)),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: companies.length,
              itemBuilder: (context, index) {
                final company = companies[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: CompanyCard(
                    userName: company.user?.name ?? '',
                    companyUserId: company.user?.id ?? '',
                    companyName: company.name ?? '',
                    rating: company.rating ?? 0,
                    industry: company.category ?? '',
                    location: company.contactInfo?.address ?? '',
                    isActive: company.status == 'active',
                    imageUrl: company.image,
                    onViewDetails: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CompanyDetailsPage(company: company),
                        ),
                      );
                    },
                    onEdit: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AddCompanyPage(companyToEdit: company),
                        ),
                      );
                      if (result == true) {
                        ref.invalidate(
                            getCompaniesByUserIdProvider(userId: userId));
                      }
                    },
                    onDelete: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => ConfirmationDialog(
                          title: 'Delete Company',
                          content:
                              'Are you sure you want to delete this company?',
                          confirmText: 'Delete',
                          cancelText: 'Cancel',
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.red, size: 24),
                        ),
                      );
                      if (confirmed == true) {
                        final container = ProviderScope.containerOf(context);
                        final companyApi =
                            container.read(companyApiServiceProvider);
                        final deleted =
                            await companyApi.deleteCompany(company.id!);
                        if (deleted) {
                          ref.invalidate(
                              getCompaniesByUserIdProvider(userId: userId));
                        }
                      }
                    },
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: LoadingAnimation()),
          error: (e, st) {
            log(e.toString());
            return Center(child: Text('No companies', style: kBodyTitleR));
          },
        ),
      ],
    );
  }
}

class _ContactFormSection extends ConsumerStatefulWidget {
  const _ContactFormSection({Key? key}) : super(key: key);

  @override
  ConsumerState<_ContactFormSection> createState() =>
      _ContactFormSectionState();
}

class _ContactFormSectionState extends ConsumerState<_ContactFormSection> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _onPost() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final enquiryApi = ref.watch(enquiryApiServiceProvider);
    final success = await enquiryApi.postEnquiry(
      name: _nameController.text,
      phone: _phoneController.text,
      email: _emailController.text,
      message: _messageController.text,
    );
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
              Text(success ? 'Enquiry Submitted!' : 'Failed to send enquiry')),
    );
    if (success) {
      _formKey.currentState!.reset();
      _nameController.clear();
      _phoneController.clear();
      _emailController.clear();
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Let\'s Talk', style: kSubHeadingB.copyWith(color: kWhite)),
            const SizedBox(height: 18),
            Text('Name',
                style: kSmallTitleL.copyWith(color: kSecondaryTextColor)),
            CustomTextFormField(
              labelText: 'Title',
              textController: _nameController,
              backgroundColor: kStrokeColor,
              validator: (v) =>
                  v == null || v.isEmpty ? 'Enter your name' : null,
            ),
            const SizedBox(height: 18),
            Text('Phone Number',
                style: kSmallTitleL.copyWith(color: kSecondaryTextColor)),
            CustomTextFormField(
              labelText: 'Name',
              textController: _phoneController,
              backgroundColor: kStrokeColor,
              textInputType: TextInputType.phone,
              validator: (v) =>
                  v == null || v.isEmpty ? 'Enter your phone number' : null,
            ),
            const SizedBox(height: 18),
            Text('Email',
                style: kSmallTitleL.copyWith(color: kSecondaryTextColor)),
            CustomTextFormField(
              labelText: 'Email',
              textController: _emailController,
              backgroundColor: kStrokeColor,
              textInputType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Enter your email';
                final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                if (!emailRegex.hasMatch(v))
                  return 'Enter a valid email address';
                return null;
              },
            ),
            const SizedBox(height: 18),
            Text('Message',
                style: kSmallTitleL.copyWith(color: kSecondaryTextColor)),
            CustomTextFormField(
              labelText: 'Review',
              textController: _messageController,
              backgroundColor: kStrokeColor,
              maxLines: 3,
              validator: (v) =>
                  v == null || v.isEmpty ? 'Enter your message' : null,
            ),
            const SizedBox(height: 32),
            customButton(
              label: 'Post',
              onPressed: _isLoading ? null : _onPost,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
