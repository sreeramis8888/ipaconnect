import 'package:flutter/material.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/models/board_member_model.dart';

class BoardMemberSection extends StatelessWidget {
  final List<BoardMember> boardMembers;
  final VoidCallback? onViewAll;

  const BoardMemberSection({
    super.key,
    required this.boardMembers,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    if (boardMembers.isEmpty) return const SizedBox.shrink();

    final mainMember = boardMembers.first;
    final otherMembers = boardMembers.skip(1).toList();
    final displayedOthers = otherMembers.take(4).toList();
    final remainingCount = otherMembers.length - displayedOthers.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Leadership', style: kBodyTitleB),
                  Text(
                    'Founders & Board Members',
                    style: kSmallTitleL.copyWith(color: kSecondaryTextColor),
                  ),
                ],
              ),
              GestureDetector(
                onTap: onViewAll,
                child: Text(
                  'View All',
                  style: kSmallTitleL.copyWith(color: kBlue),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: kCardBackgroundColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: kBlue.withOpacity(0.3), width: 1),
            boxShadow: [
              BoxShadow(
                color: kBlack.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: kBlue, width: 2),
                          image: mainMember.image != null &&
                                  mainMember.image!.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(mainMember.image!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: mainMember.image == null ||
                                mainMember.image!.isEmpty
                            ? const Icon(Icons.person, size: 50, color: kWhite)
                            : null,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        mainMember.name ?? '',
                        style: kSmallTitleB.copyWith(color: kWhite),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        mainMember.role ?? '',
                        style:
                            kSmallerTitleR.copyWith(color: kSecondaryTextColor),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          'Board Members',
                          style:
                              kSmallTitleR.copyWith(color: kSecondaryTextColor),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: -12, // Overlapping effect as per design
                          children: [
                            ...displayedOthers
                                .map((m) => _buildCircleAvatar(m.image)),
                            if (remainingCount > 0)
                              _buildCountIndicator(remainingCount),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Divider(color: kBlue.withOpacity(0.1), height: 1),
              const SizedBox(height: 20),
              Text(
                'Meet the leaders shaping our growing business community',
                style: kSmallTitleR.copyWith(color: kWhite.withOpacity(0.9)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCircleAvatar(String? imageUrl) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: kCardBackgroundColor, width: 2),
        image: imageUrl != null && imageUrl.isNotEmpty
            ? DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: imageUrl == null || imageUrl.isEmpty
          ? const Icon(Icons.person, size: 24, color: kWhite)
          : null,
    );
  }

  Widget _buildCountIndicator(int count) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: kCardBackgroundColor,
        shape: BoxShape.circle,
        border: Border.all(color: kCardBackgroundColor, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        '+$count',
        style: kSmallTitleB.copyWith(color: kWhite),
      ),
    );
  }
}
