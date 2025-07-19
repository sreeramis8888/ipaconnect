import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_round_button.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
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
          // Group photo
          Container(
            width: double.infinity,
            height: 180,
            child: Image.asset(
              'assets/pngs/eventlocation.png',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: kBackgroundColor,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // About Us text
                Text('About Us',
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  'Getting educated is a Right and not a privilege. We at Skepick are committed for making education possible for the deprived. Our platform provides transparency by ensuring a bona fide utilization of funds. Our goal is to use education as the most powerful weapon to secure a sustainable future for the world. We believe education is the only solution to ensuring social equality, poverty eradication, a better labor & order situation, etc. Our sponsors empower students to achieve their aspirations and grow up to be self-dependent & resourceful citizens through their valuable donation. We are the World’s Only Transparent Sponsorship platform opening the education doors for millions of students. We value the continued support from our institution partners to make our vision possible.',
                  style: GoogleFonts.inter(
                      fontSize: 15, color: Colors.white.withOpacity(0.85)),
                ),
                const SizedBox(height: 24),
                // Stats
                Text('Fueling Impact Through Numbers That Matter',
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _statCard('8', 'Years experience'),
                    _statCard('2K', 'Members'),
                    _statCard('6', 'Total Clusters'),
                    _statCard('100+', 'Total Businesses'),
                  ],
                ),
                const SizedBox(height: 32),
                // Timeline
                Text('Growth Over Time',
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 16),
                _timelineItem(
                    '2018',
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi facilisis, justo ac tincidunt tincidunt, sapien nisi efficitur erat, vitae cursus nunc risus vel lacus.',
                    'assets/pngs/icon1.png'),
                const SizedBox(height: 16),
                _timelineItem(
                    '2016',
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi facilisis, justo ac tincidunt tincidunt, sapien nisi efficitur erat, vitae cursus nunc risus vel lacus.',
                    'assets/pngs/icon2.png'),
                const SizedBox(height: 32),
                // Vision
                Text('Vision',
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  'Being most popular and sought after platform for Keralite business entrepreneurs where they will be connected and flourished as a dynamic business community in GCC.',
                  style: GoogleFonts.inter(
                      fontSize: 15, color: Colors.white.withOpacity(0.85)),
                ),
                const SizedBox(height: 32),
                // Mission
                Text('Mission',
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  'To empower the clients who are entrepreneurs in UAE developing a network to explore potential business opportunities, identify potential clients, customers and partners, boost business relationships, formulate marketing strategies, share requirements, find potential investors and JV partners. To provide long term training to entrepreneurs focusing on advanced marketing skills and updating information on current business scenarios.',
                  style: GoogleFonts.inter(
                      fontSize: 15, color: Colors.white.withOpacity(0.85)),
                ),
                const SizedBox(height: 32),
                // Board Members
                Text('Board Members',
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 16),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.8,
                  children: List.generate(6, (index) => _boardMemberCard()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String value, String label) {
    return Container(
      width: 70,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: kCardBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value,
              style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 4),
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 12, color: Colors.white.withOpacity(0.8)),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _timelineItem(String year, String description, String imageAsset) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(year,
                    style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            Container(
              width: 2,
              height: 60,
              color: kPrimaryColor.withOpacity(0.2),
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: kCardBackgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(imageAsset,
                      height: 50, width: 50, fit: BoxFit.cover),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(description,
                      style: GoogleFonts.inter(
                          fontSize: 13, color: Colors.white.withOpacity(0.85))),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _boardMemberCard() {
    return Container(
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
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 32,
            backgroundImage: AssetImage('assets/pngs/icon.png'),
          ),
          const SizedBox(height: 10),
          Text('Mr. Mitchell Hoeger',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: 15),
              textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text('Product Designer',
              style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.7), fontSize: 13),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
