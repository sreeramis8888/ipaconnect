import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ipaconnect/src/data/models/user_model.dart';
import 'package:ipaconnect/src/data/services/navigation_service.dart';
import 'package:ipaconnect/src/interfaces/components/animations/glowing_animated_avatar.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_round_button.dart';
import 'package:ipaconnect/src/interfaces/components/loading/loading_indicator.dart';
import 'package:ipaconnect/src/interfaces/main_pages/business/company_details_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/models/company_model.dart';
import 'package:ipaconnect/src/data/services/api_routes/company_api/company_api_service.dart';
import 'package:ipaconnect/src/interfaces/components/cards/company_card.dart';
import 'package:ipaconnect/src/interfaces/main_pages/business/add_company_page.dart';
import 'package:ipaconnect/src/interfaces/components/custom_widgets/confirmation_dialog.dart';
import 'package:ipaconnect/src/data/services/api_routes/user_api/user_data/user_data_api.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // To update FAB visibility
    });
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
    final asyncUser = ref.watch(getUserDetailsByIdProvider(userId: widget.userId));
    return asyncUser.when(
      data: (user) {
        if (user == null) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(child: Text('User not found', style: kBodyTitleR)),
          );
        }
        return Stack(
          children: [
            Container(
              height: 320,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color.fromARGB(255, 17, 53, 97), Color(0xFF030920)],
                ),
              ),
            ),
            Positioned.fill(
              top: 320,
              child: Container(
                color: Color(0xFF030920),
              ),
            ),
            // Main content
            Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                scrolledUnderElevation: 0,
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                title:
                    Text('Profile', style: TextStyle(fontSize: 16, color: kWhite)),
              ),
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
                    SizedBox(
                      height: MediaQuery.of(context).size.height *
                          0.8, // Adjust as needed
                      child: TabBarView(
                        controller: _tabController,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          _OverviewTab(user: user),
                          _BusinessTab(userId: user.id ?? ''),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              floatingActionButton: _tabController.index == 1
                  ? FloatingActionButton(
                      onPressed: () => _onAddCompany(context),
                      backgroundColor: kPrimaryColor,
                      child: Icon(Icons.add, color: Colors.white),
                      tooltip: 'Add Company',
                    )
                  : null,
            ),
          ],
        );
      },
      loading: () => const Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(child: LoadingAnimation()),
      ),
      error: (e, st) {
        log(e.toString());
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(child: Text('Failed to load user', style: kBodyTitleR)),
        );
      },
    );
  }
}

// ... rest of the code (copy all helper widgets/classes from preview.dart) ...

class _ProfileHeader extends StatelessWidget {
  final UserModel user;
  const _ProfileHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    NavigationService navigationService = NavigationService();
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          GlowingAnimatedAvatar(
            imageUrl: user.image,
            defaultAvatarAsset: 'assets/svg/icons/dummy_person_large.svg',
            size: 90,
            glowColor: kWhite,
            borderColor: kWhite,
            borderWidth: 3.0,
          ),
          const SizedBox(height: 12),
          Text(user.name ?? '', style: kHeadTitleB.copyWith(color: kWhite)),
          if (user.location != null && user.location!.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on,
                    color: kSecondaryTextColor, size: 18),
                const SizedBox(width: 4),
                Text(user.location!,
                    style: kSmallTitleR.copyWith(color: kSecondaryTextColor)),
              ],
            ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: kCardBackgroundColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    // SvgPicture.asset('assets/svg/icons/levels.svg', width: 18, color: kPrimaryColor),
                    const SizedBox(width: 6),
                    Text('Premium Member',
                        style: kSmallTitleB.copyWith(color: kPrimaryColor)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.phone, color: kWhite, size: 18),
              const SizedBox(width: 6),
              Text(user.phone ?? '', style: kSmallTitleR),
              const SizedBox(width: 18),
              Icon(Icons.email, color: kWhite, size: 18),
              const SizedBox(width: 6),
              Text(user.email ?? '', style: kSmallTitleR),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _HeaderButton(
                icon: Icons.edit,
                label: 'Edit Profile',
                onTap: () {
                  navigationService.pushNamed('EditUser');
                },
              ),
              const SizedBox(width: 16),
              _HeaderButton(
                icon: Icons.share,
                label: 'Share',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _HeaderButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 48,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: kStrokeColor,
          foregroundColor: kWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        onPressed: onTap,
        icon: Icon(icon, color: kSecondaryTextColor, size: 20),
        label:
            Text(label, style: kSmallTitleR, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  final UserModel user;
  const _OverviewTab({required this.user});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (user.bio != null) const SizedBox(height: 8),
          if (user.bio != null)
            Text('About', style: kBodyTitleB.copyWith(color: kWhite)),
          if (user.bio != null)
            if (user.bio != null) const SizedBox(height: 8),
          Text(
            user.bio ?? '',
            style: kSmallTitleR.copyWith(color: kSecondaryTextColor),
          ),
          if (user.bio != null) const SizedBox(height: 24),
          Text('Contact', style: kBodyTitleB.copyWith(color: kWhite)),
          const SizedBox(height: 8),
          if (user.phone != null && user.phone!.isNotEmpty)
            Row(
              children: [
                Icon(Icons.phone, color: kSecondaryTextColor, size: 18),
                const SizedBox(width: 8),
                Text(user.phone!,
                    style: kSmallTitleR.copyWith(color: kSecondaryTextColor)),
              ],
            ),
          if (user.email != null && user.email!.isNotEmpty)
            Row(
              children: [
                Icon(Icons.email, color: kSecondaryTextColor, size: 18),
                const SizedBox(width: 8),
                Text(user.email!,
                    style: kSmallTitleR.copyWith(color: kSecondaryTextColor)),
              ],
            ),
          if (user.location != null && user.location!.isNotEmpty)
            Row(
              children: [
                Icon(Icons.location_on, color: kSecondaryTextColor, size: 18),
                const SizedBox(width: 8),
                Text(user.location!,
                    style: kSmallTitleR.copyWith(color: kSecondaryTextColor)),
              ],
            ),
          if (user.socialMedia != null)
            if (user.socialMedia!.isNotEmpty) const SizedBox(height: 24),
          if (user.socialMedia != null)
            if (user.socialMedia!.isNotEmpty)
              Text('Social Profile & Portfolio',
                  style: kBodyTitleB.copyWith(color: kWhite)),
          if (user.socialMedia != null)
            if (user.socialMedia!.isNotEmpty) const SizedBox(height: 12),
          if (user.socialMedia != null && user.socialMedia!.isNotEmpty)
            ...user.socialMedia!.map((sm) => _SocialCard(sm: sm)),
        ],
      ),
    );
  }
}

class _SocialCard extends StatelessWidget {
  final dynamic sm;
  const _SocialCard({required this.sm});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: kCardBackgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: _getSocialIcon(sm.name),
        title: Text(sm.name ?? '', style: kSmallTitleB.copyWith(color: kWhite)),
        subtitle: Text(sm.url ?? '',
            style: kSmallTitleR.copyWith(color: kSecondaryTextColor)),
        trailing: Icon(Icons.open_in_new, color: kSecondaryTextColor),
        onTap: () => _launchURL(context, sm.url),
      ),
    );
  }
}

Widget _getSocialIcon(String? name) {
  if (name == null) return const Icon(Icons.link, color: kSecondaryTextColor);
  final lower = name.toLowerCase();
  if (lower.contains('instagram')) {
    return SvgPicture.asset('assets/svg/icons/instagram.svg',
        width: 28, height: 28);
  } else if (lower.contains('linkedin')) {
    return SvgPicture.asset('assets/svg/icons/linkedin.svg',
        width: 28, height: 28);
  } else if (lower.contains('twitter')) {
    return SvgPicture.asset('assets/svg/icons/twitter.svg',
        width: 28, height: 28);
  } else if (lower.contains('facebook')) {
    return SvgPicture.asset('assets/svg/icons/icons8-facebook.svg',
        width: 28, height: 28);
  } else if (lower.contains('portfolio')) {
    return Icon(Icons.work, color: kGreen, size: 28);
  }
  return const Icon(Icons.link, color: kSecondaryTextColor);
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
              // Removed IconButton for add
            ],
          ),
        ),
        Expanded(
          child: asyncCompanies.when(
            data: (companies) {
              if (companies.isEmpty) {
                return Center(
                  child: Text('No companies found.',
                      style: kBodyTitleR.copyWith(color: kWhite)),
                );
              }
              return ListView.builder(
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
                          // Refresh companies after edit
                          ref.refresh(
                              getCompaniesByUserIdProvider(userId: userId));
                        }
                      },
                      onDelete: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => ConfirmationDialog(
                            title: 'Delete Company',
                            content: 'Are you sure you want to delete this company?',
                            confirmText: 'Delete',
                            cancelText: 'Cancel',
                            icon: const Icon(Icons.delete_outline, color: Colors.red, size: 24),
                          ),
                        );
                        if (confirmed == true) {
                          final container = ProviderScope.containerOf(context);
                          final companyApi =
                              container.read(companyApiServiceProvider);
                          final deleted =
                              await companyApi.deleteCompany(company.id!);
                          if (deleted) {
                            ref.refresh(
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
        ),
      ],
    );
  }
} 