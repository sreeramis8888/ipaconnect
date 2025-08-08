import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/models/user_model.dart';
import 'package:ipaconnect/src/data/services/api_routes/hierarchy/hierarchy_api_service.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_round_button.dart';
import 'package:ipaconnect/src/interfaces/components/loading/loading_indicator.dart';
import 'package:ipaconnect/src/interfaces/main_pages/levels/create_notification_page.dart';
import 'package:ipaconnect/src/interfaces/main_pages/levels/level_members.dart';

class HierarchiesPage extends ConsumerWidget {
  final UserModel user;
  const HierarchiesPage({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncHierarchies = ref.watch(getHierarchyProvider);
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: CustomRoundButton(
              offset: const Offset(4, 0),
              iconPath: 'assets/svg/icons/arrow_back_ios.svg',
            ),
          ),
        ),
        title: Text(
          "Hierarchies",
          style: kBodyTitleR,
        ),
        centerTitle: true,
        backgroundColor: kBackgroundColor,
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: asyncHierarchies.when(
        data: (hierarchies) {
          if (hierarchies.isEmpty) {
            return Center(
                child: Text(
              'No hierarchies found',
              style: kSmallTitleL,
            ));
          }
          return ListView.builder(
            itemCount: hierarchies.length,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemBuilder: (context, index) {
              final hierarchy = hierarchies[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: kCardBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: kStrokeColor,
                        spreadRadius: .1,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: kStrokeColor,
                      child: Icon(Icons.account_tree, color: kPrimaryColor),
                    ),
                    title: Text(hierarchy.name ?? '-', style: kBodyTitleR),
                    subtitle: hierarchy.description != null &&
                            hierarchy.description!.isNotEmpty
                        ? Text(
                            hierarchy.description!,
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey[700]),
                          )
                        : null,
                    trailing: user.hierarchy?.id == hierarchy.id
                        ? const Icon(Icons.arrow_forward_ios,
                            size: 16, color: kSecondaryTextColor)
                        : null,
                    onTap: () {
                      if (user.hierarchy?.id == hierarchy.id) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HierarchyMembers(
                              hierarchyName: hierarchy.name ?? '',
                              hierarchyId: hierarchy.id ?? '',
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: LoadingAnimation()),
        error: (error, stackTrace) {
          return const Center(
            child: Text('Error loading hierarchies'),
          );
        },
      ),
    );
  }
}
