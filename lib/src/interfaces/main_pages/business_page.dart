import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/notifiers/business_category_notifier.dart';
import 'package:ipaconnect/src/interfaces/components/cards/business_category_card.dart';
import 'package:ipaconnect/src/interfaces/components/loading/loading_indicator.dart';
import 'package:ipaconnect/src/interfaces/main_pages/business/business_tab.dart';
import 'package:ipaconnect/src/interfaces/main_pages/business/job_search_tab.dart';

class BusinessCategoriesPage extends StatelessWidget {
  const BusinessCategoriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: kBackgroundColor,
          body: Column(
            children: [
              SafeArea(
                child: Container(
                  decoration: const BoxDecoration(
                    color: kBackgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 4),
                        blurRadius: 6,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: const TabBar(
                    indicatorColor: kPrimaryColor,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorWeight: 3,
                    labelColor: kPrimaryColor,
                    dividerColor: kBackgroundColor,
                    unselectedLabelColor: kSecondaryTextColor,
                    labelStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    unselectedLabelStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    tabs: [
                      Tab(text: "Business Category"),
                      Tab(text: "Job Search"),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [BusinessCategoryTab(), JobSearchTab()],
                ),
              ),
            ],
          ),
        ));
  }
}
