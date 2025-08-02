import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/models/user_model.dart';
import 'package:ipaconnect/src/data/services/api_routes/user_api/user_data/user_data_api.dart';
import 'package:ipaconnect/src/data/services/navigation_service.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/utils/secure_storage.dart';
import 'package:ipaconnect/src/interfaces/components/custom_widgets/confirmation_dialog.dart';

class CustomAdvancedDrawerMenu extends StatelessWidget {
  final UserModel user;
  final BuildContext parentContext;

  const CustomAdvancedDrawerMenu({
    Key? key,
    required this.user,
    required this.parentContext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navigationService = NavigationService();
    return SafeArea(
      child: Drawer(
        backgroundColor: kBackgroundColor,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(user.image ?? ''),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name ?? '',
                        style: kSmallTitleB,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        user.phone ?? '',
                        style: const TextStyle(
                            fontSize: 12, color: kSecondaryTextColor),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _menuItem(
              icon: SvgPicture.asset(
                'assets/svg/icons/menu_icons/analytics.svg',
                color: kWhite,
                height: 24,
              ),
              label: 'Analytics',
              onTap: () => navigationService.pushNamed('Analytics'),
            ),
            // _menuItem(
            //   icon: SvgPicture.asset(
            //     'assets/svg/icons/menu_icons/comment.svg',
            //     color: kWhite,
            //     height: 24,
            //   ),
            //   label: 'Enquiries',
            //   onTap: () => navigationService.pushNamed('EnquiriesPage'),
            // ),
            // _menuItem(
            //   icon: SvgPicture.asset(
            //     'assets/svg/icons/menu_icons/request_nfc.svg',
            //     height: 24,
            //   ),
            //   label: 'Request NFC',
            //   onTap: () => navigationService.pushNamed('RequestNFC'),
            // ),

            _menuItem(
              icon: SvgPicture.asset(
                'assets/svg/icons/menu_icons/levels.svg',
                height: 24,
              ),
              label: 'Hierarchy',
              onTap: () => navigationService.pushNamed('Hierarchies',arguments: user),
            ),
            _menuItem(
              icon: SvgPicture.asset(
                'assets/svg/icons/menu_icons/my_submissions.svg',
                height: 24,
              ),
              label: 'My Submissions',
              onTap: () => navigationService.pushNamed('EnquiriesPage'),
            ),  if (user.phone !=
                                            '+919645398555')
            _menuItem(
              icon: SvgPicture.asset(
                'assets/svg/icons/menu_icons/my_orders.svg',
                height: 24,
              ),
              label: 'My Orders',
              onTap: () => navigationService.pushNamed('MyOrdersPage'),
            ),
            _menuItem(
              icon: SvgPicture.asset(
                'assets/svg/icons/menu_icons/my_reviews.svg',
                height: 24,
              ),
              label: 'My Reviews',
              onTap: () => navigationService.pushNamed('MyReviews'),
            ),
            // _menuItem(
            //   icon: SvgPicture.asset(
            //     'assets/svg/icons/menu_icons/my_transactions.svg',
            //     height: 24,
            //   ),
            //   label: 'My Transactions',
            //   onTap: () => navigationService.pushNamed('MyReviews'),
            // ),
            // _menuItem(
            //   icon: SvgPicture.asset(
            //     'assets/svg/icons/menu_icons/my_certificates.svg',
            //     height: 24,
            //   ),
            //   label: 'My Certificates',
            //   onTap: () => navigationService.pushNamed('MyReviews'),
            // ),
            _menuItem(
              icon: SvgPicture.asset(
                'assets/svg/icons/menu_icons/my_requirements.svg',
                height: 24,
              ),
              label: 'My Posts',
              onTap: () => navigationService.pushNamed('MyRequirements',
                  arguments: user),
            ),
            _menuItem(
              icon: SvgPicture.asset(
                'assets/svg/icons/menu_icons/my_events.svg',
                height: 24,
              ),
              label: 'My Events',
              onTap: () => navigationService.pushNamed('MyEvents'),
            ),
            _menuItem(
              icon: SvgPicture.asset(
                'assets/svg/icons/menu_icons/about_us.svg',
                height: 24,
              ),
              label: 'About Us',
              onTap: () => navigationService.pushNamed('AboutPage'),
            ),
            _menuItem(
              icon: SvgPicture.asset(
                'assets/svg/icons/menu_icons/terms.svg',
                height: 24,
              ),
              label: 'Terms & Conditions',
              onTap: () =>
                  navigationService.pushNamed('TermsAndConditionsPage'),
            ),
            _menuItem(
              icon: SvgPicture.asset(
                'assets/svg/icons/menu_icons/privacy.svg',
                height: 24,
              ),
              label: 'Privacy Policy',
              onTap: () => navigationService.pushNamed('PrivacyPolicyPage'),
            ),
            _menuItem(
              icon: SvgPicture.asset(
                'assets/svg/icons/menu_icons/logout.svg',
                height: 24,
              ),
              label: 'Logout',
              onTap: () async {
                await SecureStorage.delete('token');
                await SecureStorage.delete('id');

                navigationService.pushNamedAndRemoveUntil('PhoneNumber');
              },
            ),
            Consumer(
              builder: (context, ref, child) {
                return _menuItem(
                  icon: SvgPicture.asset(
                    'assets/svg/icons/menu_icons/delete.svg',
                    height: 24,
                  ),
                  label: 'Delete Account',
                  onTap: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => ConfirmationDialog(
                        title: 'Delete Account',
                        content:
                            'Are you sure you want to delete this account and associated data?',
                        confirmText: 'Delete',
                        cancelText: 'Cancel',
                        icon: const Icon(Icons.delete_outline,
                            color: Colors.red, size: 24),
                      ),
                    );
                    if (confirmed ?? false) {
                      final userDataApiService =
                          ref.watch(userDataApiServiceProvider);
                      final response =
                          await userDataApiService.deleteUser(user.id ?? '');
                      if (response.success) {
                                  await SecureStorage.delete('token');
                await SecureStorage.delete('id');

                        navigationService
                            .pushNamedAndRemoveUntil('PhoneNumber');
                      }
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(
      {required Widget icon,
      required String label,
      required VoidCallback onTap}) {
    return ListTile(
      leading: icon,
      title: Text(
        label,
        style: TextStyle(color: kWhite, fontWeight: FontWeight.w400),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      minLeadingWidth: 0,
      dense: true,
    );
  }
}
