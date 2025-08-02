import 'package:flutter/material.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_round_button.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> members = [
      {
        "designation": "Kiltons Group",
        "name": "Riyas Kilton",
        "photo": "assets/pngs/IPA_Chaiman.JPG",
      },
      {
        "designation": "NRay Designs LLC",
        "name": "Muhammed Nausheer",
        "photo": "assets/pngs/BOD_Member_3.png",
      },
      {
        "designation": "Exe Direction, Malabar Gold",
        "name": "Faisal AK",
        "photo": "assets/pngs/Founder_Faisal_2.jpeg",
      },
      {
        "designation": "Nazeem Ahmed General Trading llc",
        "name": "Ayub Kallada",
        "photo": "assets/pngs/Vice_Chairman_2.jpeg",
      },
      {
        "designation": "Bhima Jewellers LLC",
        "name": "Nagaraj Rau",
        "photo": "assets/pngs/BOD Member_2.jpg",
      },
    ];

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
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
        title: Text('About Us',
            style: kBodyTitleM.copyWith(color: kSecondaryTextColor)),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            width: double.infinity,
            height: 180,
            child: Image.asset(
              'assets/pngs/aboutus_groupphoto.png',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: kBackgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // About Us text
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('About Us',
                          style: kSubHeadingB.copyWith(color: Colors.white)),
                      const SizedBox(height: 8),
                      Text(
                          'Getting educated is a Right and not a privilege. We at Skepick are committed for making education possible for the deprived. Our platform provides transparency by ensuring a bona fide utilization of funds. Our goal is to use education as the most powerful weapon to secure a sustainable future for the world. We believe education is the only solution to ensuring social equality, poverty eradication, a better labor & order situation, etc. Our sponsors empower students to achieve their aspirations and grow up to be self-dependent & resourceful citizens through their valuable donation. We are the World\'s Only Transparent Sponsorship platform opening the education doors for millions of students. We value the continued support from our institution partners to make our vision possible.',
                          style: TextStyle(color: kSecondaryTextColor)),
                    ],
                  ),
                ),

                Container(
                  decoration: BoxDecoration(color: kCardBackgroundColor),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Text('Fueling Impact\nThrough Numbers\nThat Matter',
                            style: kLargeTitleB.copyWith(
                                color: Colors.white, fontSize: 32)),
                        const SizedBox(height: 16),
                        Container(
                          height: 1,
                          color: kBackgroundColor,
                        ),
                        const SizedBox(height: 10),
                        // Statistics Grid
                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 0,
                          crossAxisSpacing: 16,
                          children: [
                            _statCard('8', 'Years experience',
                                'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'),
                            _statCard('2K', 'Members',
                                'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'),
                            _statCard('6', 'Total Clusters',
                                'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'),
                            _statCard('100+', 'Total Businesses',
                                'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'),
                          ],
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Timeline
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Growth Over Time',
                          style: kSubHeadingB.copyWith(
                              color: Colors.white, fontSize: 32)),
                      const SizedBox(height: 8),
                      Text(
                        'Explore the key moments that shaped IPA Into a thriving business community. From its founding vision to present-day milestones, our journey reflects growth, collaboration, and a commitment to empowering entrepreneurs across the globe.',
                        style: TextStyle(color: kSecondaryTextColor),
                      ),
                      const SizedBox(height: 24),
                      _timelineItemNew(
                          '2018',
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi facilisis, justo ac tincidunt tincidunt, sapien nisl efficitur erat, vitae cursus nunc risus vel lacus.',
                          'assets/pngs/icon1.png'),
                      const SizedBox(height: 24),
                      _timelineItemNew(
                          '2018',
                          'Lorem Ipsum dolor sit amet, consectetur adipiscing elit. Morbi facilisis, justo ac tincidunt tincidunt, sapien nisi efficitur erat, vitae cursus nunc risus vel lacus.',
                          'assets/pngs/icon2.png'),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Vision
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Vision', style: kSubHeadingB),
                      const SizedBox(height: 8),
                      Text(
                          'Being most popular and sought after platform for Keralite business entrepreneurs where they will be connected and flourished as a dynamic business community in GCC.',
                          style: TextStyle(color: kSecondaryTextColor)),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Mission
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Mission', style: kSubHeadingB),
                      const SizedBox(height: 8),
                      Text(
                          'To empower the clients who are entrepreneurs in UAE developing a network to explore potential business opportunities, identify potential clients, customers and partners, boost business relationships, formulate marketing strategies, share requirements, find potential investors and JV partners. To provide long term training to entrepreneurs focusing on advanced marketing skills and updating information on current business scenarios.',
                          style: TextStyle(color: kSecondaryTextColor)),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Board Members
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Board Members',
                          style: kSubHeadingB.copyWith(color: Colors.white)),
                      const SizedBox(height: 16),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: members.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          mainAxisExtent: 240,
                        ),
                        itemBuilder: (context, index) {
                          return _boardMemberCard(
                            designation: members[index]['designation'] ?? '',
                            name: members[index]['name'] ?? '',
                            photo: members[index]['photo'] ?? '',
                          );
                        },
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String value, String label, String description) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: kLargeTitleB.copyWith(color: Colors.white, fontSize: 36),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: kSmallTitleSB.copyWith(color: Colors.white.withOpacity(0.8)),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: kSmallerTitleR.copyWith(color: Colors.grey.withOpacity(0.6)),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _timelineItemNew(String year, String description, String imageAsset) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Year marker with blue bullet
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: kPrimaryColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(year, style: kSmallTitleR.copyWith(color: Colors.white)),
          ],
        ),
        const SizedBox(height: 12),

        Padding(
          padding: const EdgeInsets.only(left: 16), // dot + spacing
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                description,
                style: TextStyle(color: kSecondaryTextColor),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imageAsset,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _boardMemberCard({
    required String photo,
    required String name,
    required String designation,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 160, // Increased height
          width: 140, // Optional: control width too
          decoration: BoxDecoration(
            color: kCardBackgroundColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          clipBehavior: Clip.hardEdge, 
          child: Image.asset(
            photo,
            fit: BoxFit.cover, 
          ),
        ),
        const SizedBox(height: 10),
        Text(
          name,
          style: kBodyTitleSB.copyWith(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          designation,
          style: kSmallerTitleR.copyWith(color: Colors.white.withOpacity(0.7)),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
