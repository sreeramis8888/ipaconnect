import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/models/board_member_model.dart';
import 'package:ipaconnect/src/data/services/api_routes/leadership_api/leadership_api_service.dart';
import 'package:ipaconnect/src/interfaces/components/loading/loading_indicator.dart';

class LeadershipPage extends ConsumerStatefulWidget {
  const LeadershipPage({super.key});

  @override
  ConsumerState<LeadershipPage> createState() => _LeadershipPageState();
}

class _LeadershipPageState extends ConsumerState<LeadershipPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: kCardBackgroundColor,
              border: Border.all(color: kStrokeColor, width: 1),
            ),
            child:
                const Icon(Icons.arrow_back_ios_new, size: 16, color: kWhite),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Leadership', style: kHeadTitleB),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 80),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _tabController.animateTo(0);
                      setState(() {});
                    },
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        color: _tabController.index == 0
                            ? kPrimaryColor
                            : kCardBackgroundColor,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: _tabController.index == 0
                              ? kPrimaryColor
                              : kStrokeColor,
                          width: 1,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Founders',
                        style: kSmallTitleB.copyWith(
                          color: _tabController.index == 0
                              ? kWhite
                              : kSecondaryTextColor,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _tabController.animateTo(1);
                      setState(() {});
                    },
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        color: _tabController.index == 1
                            ? kPrimaryColor
                            : kCardBackgroundColor,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: _tabController.index == 1
                              ? kPrimaryColor
                              : kStrokeColor,
                          width: 1,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Board Members',
                        style: kSmallTitleB.copyWith(
                          color: _tabController.index == 1
                              ? kWhite
                              : kSecondaryTextColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _LeadershipList(type: 'Founders'),
                _LeadershipList(type: 'BOD'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LeadershipList extends ConsumerWidget {
  final String type;

  const _LeadershipList({required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leadershipData = ref.watch(leadershipDataProvider(type));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            type == 'Founders' ? 'Founders' : 'Board Members',
            style: kSmallTitleB.copyWith(color: kWhite),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: leadershipData.when(
            data: (members) {
              if (members.isEmpty) {
                return const Center(child: Text('No members found'));
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: members.length,
                itemBuilder: (context, index) {
                  return _MemberCard(member: members[index]);
                },
              );
            },
            loading: () => const Center(child: LoadingAnimation()),
            error: (err, stack) => Center(child: Text('Error: $err')),
          ),
        ),
      ],
    );
  }
}

class _MemberCard extends StatelessWidget {
  final BoardMember member;

  const _MemberCard({required this.member});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCardBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kStrokeColor, width: 1),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundImage: member.image != null && member.image!.isNotEmpty
                ? NetworkImage(member.image!)
                : null,
            child: member.image == null || member.image!.isEmpty
                ? const Icon(Icons.person, size: 30)
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        member.name ?? '',
                        style: kSmallTitleB.copyWith(color: kWhite),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.check_circle,
                        color: kPrimaryColor, size: 14),
                  ],
                ),
                Text(
                  member.company ?? '',
                  style: kSmallerTitleR.copyWith(color: kSecondaryTextColor),
                ),
                Text(
                  member.role ?? '',
                  style: kSmallerTitleR.copyWith(color: kSecondaryTextColor),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              if (member.id != null) {
                Navigator.pushNamed(context, 'ProfilePreviewById',
                    arguments: member.id);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: kPrimaryColor.withOpacity(0.5)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View profile',
                    style: kSmallerTitleR.copyWith(color: kPrimaryColor),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward_ios,
                      size: 10, color: kPrimaryColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
