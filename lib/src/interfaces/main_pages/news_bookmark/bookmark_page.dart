import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/models/news_model.dart';
import 'package:shimmer/shimmer.dart';
import 'news_page.dart';
import 'news_list_page.dart';

class BookmarkPage extends ConsumerWidget {
  const BookmarkPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarkedIds = ref.watch(bookmarkedNewsModelProvider);
    List<NewsModel> getMockNewsModel() {
      return [
        NewsModel(
          id: '1',
          title: 'Rahim Electronics Crosses 500 Orders!',
          content:
              'The annual family reunion was a great success with over 100 members attending...',
          category: 'Electronics',
          media: 'https://picsum.photos/id/10/800/450',
          updatedAt: DateTime.now().subtract(Duration(hours: 11)),
        ),
        NewsModel(
          id: '2',
          title: 'Homemade Pickles By Fatima Now Available!',
          content: 'Welcome to our newest family member, born on May 15th...',
          category: 'Food',
          media: 'https://picsum.photos/id/20/800/450',
          updatedAt: DateTime.now().subtract(Duration(hours: 11)),
        ),
        NewsModel(
          id: '3',
          title: 'Rahim Electronics Crosses 500 Orders!',
          content: 'Our family history project has reached a new milestone...',
          category: 'Electronics',
          media: 'https://picsum.photos/id/30/800/450',
          updatedAt: DateTime.now().subtract(Duration(hours: 11)),
        ),
        NewsModel(
          id: '4',
          title: 'Rahim Electronics Crosses 500 Orders!',
          content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
          category: 'Electronics',
          media: 'https://picsum.photos/id/40/800/450',
          updatedAt: DateTime.now().subtract(Duration(hours: 11)),
        ),
        NewsModel(
          id: '5',
          title: 'Rahim Electronics Crosses 500 Orders!',
          content:
              'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
          category: 'Electronics',
          media: 'https://picsum.photos/id/50/800/450',
          updatedAt: DateTime.now().subtract(Duration(hours: 11)),
        ),
        NewsModel(
          id: '6',
          title: 'Rahim Electronics Crosses 500 Orders!',
          content:
              'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.',
          category: 'Electronics',
          media: 'https://picsum.photos/id/60/800/450',
          updatedAt: DateTime.now().subtract(Duration(hours: 11)),
        ),
      ];
    }

    final mockNewsModel = getMockNewsModel();

    final bookmarkedNewsModel =
        mockNewsModel.where((news) => bookmarkedIds.contains(news.id)).toList();

    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Bookmarks",
          style: TextStyle(fontSize: 17),
        ),
        backgroundColor: kWhite,
        scrolledUnderElevation: 0,
      ),
      body: bookmarkedNewsModel.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bookmark_border,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No bookmarked news yet',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: bookmarkedNewsModel.length,
              itemBuilder: (context, index) {
                final newsItem = bookmarkedNewsModel[index];
                return GestureDetector(
                  onTap: () {
                    final initialIndex = mockNewsModel.indexOf(newsItem);
                    if (initialIndex != -1) {
                      ref.read(currentNewsIndexProvider.notifier).state =
                          initialIndex;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              NewsModelDetailView(news: mockNewsModel),
                        ),
                      );
                    }
                  },
                  child: BookmarkNewsCard(
                    news: newsItem,
                    onBookmarkRemoved: () {
                      ref
                          .read(bookmarkedNewsModelProvider.notifier)
                          .toggleBookmark(newsItem.id!);
                    },
                  ),
                );
              },
            ),
    );
  }
}

class BookmarkNewsCard extends StatelessWidget {
  final NewsModel news;
  final VoidCallback onBookmarkRemoved;

  const BookmarkNewsCard({
    Key? key,
    required this.news,
    required this.onBookmarkRemoved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat('MMM dd, yyyy, hh:mm a').format(news.updatedAt!.toLocal());

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    news.media ?? '',
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return ShimmerLoadingEffect(
                        child: Container(
                          width: double.infinity,
                          color: Colors.grey[300],
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return ShimmerLoadingEffect(
                        child: Container(
                          width: double.infinity,
                          color: Colors.grey[300],
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: IconButton(
                  icon: Icon(
                    Icons.bookmark,
                    color: kPrimaryColor,
                    size: 28,
                  ),
                  onPressed: onBookmarkRemoved,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color.fromARGB(255, 192, 252, 194),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 10,
                    ),
                    child: Text(
                      news.category ?? '',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  news.title ?? '',
                  style: kHeadTitleB,
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      formattedDate,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    Spacer(),
                    Text(
                      calculateReadingTimeAndWordCount(news.content ?? ''),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String calculateReadingTimeAndWordCount(String text) {
  List<String> words = text.trim().split(RegExp(r'\s+'));
  int wordCount = words.length;
  const int averageWPM = 250;
  double readingTimeMinutes = wordCount / averageWPM;
  int minutes = readingTimeMinutes.floor();
  int seconds = ((readingTimeMinutes - minutes) * 60).round();
  String formattedTime;
  if (minutes > 0) {
    formattedTime = '$minutes min ${seconds > 0 ? '$seconds sec' : ''}';
  } else {
    formattedTime = '$seconds sec';
  }
  return '$formattedTime read';
}

class ShimmerLoadingEffect extends StatelessWidget {
  final Widget child;

  const ShimmerLoadingEffect({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: child,
    );
  }
}
