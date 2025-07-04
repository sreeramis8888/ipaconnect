import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:intl/intl.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/services/api_routes/news_api/news_api_service.dart';
import 'package:ipaconnect/src/data/utils/get_time_ago.dart';
import 'package:ipaconnect/src/interfaces/components/loading/loading_indicator.dart';
import '../../../data/models/news_model.dart';
import 'news_page.dart';
import 'bookmark_page.dart';

class NewsListPage extends ConsumerWidget {
  const NewsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncNewsModel = ref.watch(newsProvider);

    return Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          backgroundColor: kBackgroundColor,
          scrolledUnderElevation: 0,
          titleSpacing: 0,
          title: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Row(
              children: [
                Icon(Icons.feed_outlined, color: kPrimaryColor, size: 22),
                SizedBox(width: 8),
                Text(
                  "NewsModel",
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, color: kWhite),
                ),
              ],
            ),
          ),
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.bookmark, color: kPrimaryColor, size: 22),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BookmarkPage()),
                    );
                  },
                ),
                Positioned(
                  right: 5,
                  top: 5,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 14,
                      minHeight: 14,
                    ),
                    child: Text(
                      '3', // Placeholder for bookmark count
                      style: TextStyle(
                        color: kWhite,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(width: 16),
          ],
        ),
        body: asyncNewsModel.when(
          data: (news) {
            if (news.isNotEmpty) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
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
                              hintText: 'Search Products',
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
                  Expanded(
                    child: ListView.builder(
                      itemCount: news.length,
                      itemBuilder: (context, index) {
                        return NewsCard(news: news[index], allNewsModel: news);
                      },
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                child: Text(
                  'No News',
                  style: kBodyTitleB,
                ),
              );
            }
          },
          loading: () => const Center(child: LoadingAnimation()),
          error: (error, stackTrace) => Text(
            'No News',
            style: kBodyTitleB,
          ),
        ));
  }
}

class NewsCard extends ConsumerWidget {
  final NewsModel news;
  final List<NewsModel> allNewsModel;

  const NewsCard({Key? key, required this.news, required this.allNewsModel})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final time = timeAgo(news.updatedAt!);

    return GestureDetector(
      onTap: () {
        final initialIndex = allNewsModel.indexOf(news);
        if (initialIndex != -1) {
          ref.read(currentNewsIndexProvider.notifier).state = initialIndex;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewsModelDetailView(news: allNewsModel),
            ),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
            color: kCardBackgroundColor,
            border: Border.all(color: kStrokeColor),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: Image.network(
                news.media ?? '',
                width: 90,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(9),
                      bottomLeft: Radius.circular(9),
                    ),
                  ),
                  child: Icon(Icons.broken_image, color: Colors.grey[600]),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      news.title ?? '',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      time,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                icon: Icon(Icons.more_vert, color: Colors.grey),
                onPressed: () {
                  // More options action
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
