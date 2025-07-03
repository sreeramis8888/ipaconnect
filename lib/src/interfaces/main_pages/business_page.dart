import 'package:flutter/material.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';

class BusinessCategoriesPage extends StatelessWidget {
  const BusinessCategoriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: const Color(0xFF1A1B2E),
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
                  children: [
                    BusinessCategoryTab(),
                    Text(''),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

class BusinessCategoryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2D47),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.search,
                  color: Colors.white54,
                  size: 20,
                ),
                SizedBox(width: 12),
                Text(
                  'Search Categories',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Categories Grid
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.0,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return CategoryCard(
                  title: category['title']!,
                  iconUrl: category['iconUrl']!,
                  backgroundColor:
                      Color(int.parse(category['backgroundColor']!)),
                  count: category['count']!,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class JobSearchTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2D47),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.search,
                  color: Colors.white54,
                  size: 20,
                ),
                SizedBox(width: 12),
                Text(
                  'Search Jobs',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Job Search Content
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.work_outline,
                  size: 80,
                  color: Colors.white54,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Job Search',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Find your dream job here',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Widget _buildBottomNavItem(IconData icon, String label, bool isActive) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        icon,
        color: isActive ? const Color(0xFF4A90E2) : Colors.white54,
        size: 24,
      ),
      const SizedBox(height: 4),
      Text(
        label,
        style: TextStyle(
          color: isActive ? const Color(0xFF4A90E2) : Colors.white54,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}

class CategoryCard extends StatelessWidget {
  final String title;
  final String iconUrl;
  final Color backgroundColor;
  final String count;

  const CategoryCard({
    Key? key,
    required this.title,
    required this.iconUrl,
    required this.backgroundColor,
    required this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2A2D47),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF3A3D57),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          // Count badge
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                count,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon container
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Image.network(
                      iconUrl,
                      width: 32,
                      height: 32,
                      color: Colors.white,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.business,
                          color: Colors.white,
                          size: 32,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Sample data for categories
final List<Map<String, String>> categories = [
  {
    'title': 'Accounting and\nAuditing',
    'iconUrl': 'https://cdn-icons-png.flaticon.com/512/2642/2642487.png',
    'backgroundColor': '0xFF4A90E2',
    'count': '5',
  },
  {
    'title': 'Advertising',
    'iconUrl': 'https://cdn-icons-png.flaticon.com/512/3039/3039393.png',
    'backgroundColor': '0xFF2ECC71',
    'count': '5',
  },
  {
    'title': 'Business Setup\nServices',
    'iconUrl': 'https://cdn-icons-png.flaticon.com/512/2920/2920277.png',
    'backgroundColor': '0xFF9B59B6',
    'count': '5',
  },
  {
    'title': 'Car Seller',
    'iconUrl': 'https://cdn-icons-png.flaticon.com/512/3774/3774299.png',
    'backgroundColor': '0xFFE74C3C',
    'count': '5',
  },
  {
    'title': 'Cargo and\nCourier',
    'iconUrl': 'https://cdn-icons-png.flaticon.com/512/411/411763.png',
    'backgroundColor': '0xFF3498DB',
    'count': '5',
  },
  {
    'title': 'Cleaning\nServices',
    'iconUrl': 'https://cdn-icons-png.flaticon.com/512/2553/2553642.png',
    'backgroundColor': '0xFF27AE60',
    'count': '5',
  },
  {
    'title': 'Construction',
    'iconUrl': 'https://cdn-icons-png.flaticon.com/512/2626/2626788.png',
    'backgroundColor': '0xFF8E44AD',
    'count': '5',
  },
  {
    'title': 'Content Writing',
    'iconUrl': 'https://cdn-icons-png.flaticon.com/512/2541/2541988.png',
    'backgroundColor': '0xFFE67E22',
    'count': '5',
  },
];
