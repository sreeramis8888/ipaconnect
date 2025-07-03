import 'package:flutter/material.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_backButton.dart';
import 'package:ipaconnect/src/interfaces/components/cards/company_card.dart';

class Categorypage extends StatelessWidget {
  const Categorypage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: PrimaryBackButton(),
        ),
        title: Text(
          'Category Name',
          style: TextStyle(
            color: kSecondaryTextColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    cursorColor: kWhite,
                    style: kBodyTitleR.copyWith(
                      fontSize: 14,
                      color: kSecondaryTextColor,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                      filled: true,
                      fillColor: kCardBackgroundColor,
                      prefixIcon: const Icon(
                        Icons.search,
                        size: 20,
                        color: kSecondaryTextColor,
                      ),
                      hintText: 'Search Members',
                      hintStyle: kBodyTitleR.copyWith(
                        fontSize: 14,
                        color: kSecondaryTextColor,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          // Company List
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                CompanyCard(
                  companyName: 'GrowthEdge Media Pvt. Ltd.',
                  rating: 4.9,
                  position: 'Founder & CEO',
                  industry: 'Digital Marketing & Advertising',
                  location: 'Mumbai, India',
                  isActive: true,
                  imageUrl:
                      'assets/company_image.jpg', // You can replace with actual image
                ),
                SizedBox(height: 16),
                CompanyCard(
                  companyName: 'GrowthEdge Media Pvt. Ltd.',
                  rating: 4.9,
                  position: 'Founder & CEO',
                  industry: 'Digital Marketing & Advertising',
                  location: 'Mumbai, India',
                  isActive: true,
                  imageUrl: 'assets/company_image.jpg',
                ),
                SizedBox(height: 16),
                // Add more company cards as needed
              ],
            ),
          ),
        ],
      ),
    );
  }
}
