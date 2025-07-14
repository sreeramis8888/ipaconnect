import 'package:flutter/material.dart';
import 'package:ipaconnect/src/data/models/feed_model.dart';
import 'package:ipaconnect/src/data/models/user_model.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';

Future<void> showFeedEnquiryModal({
  required BuildContext context,
  required FeedModel feed,
  required UserModel author,
  required VoidCallback onSend,
}) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: kCardBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
    ),
    builder: (context) {
      return SingleChildScrollView(
        child: Container(
          color: kCardBackgroundColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (feed.media != null && feed.media!.isNotEmpty)
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20.0)),
                  child: Image.network(
                    feed.media!,
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          author.image != null && author.image!.isNotEmpty
                              ? NetworkImage(author.image!)
                              : null,
                      radius: 20,
                      backgroundColor: kStrokeColor,
                      child: (author.image == null || author.image!.isEmpty)
                          ? const Icon(Icons.person, color: kWhite)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(author.name ?? 'Unknown',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, color: kWhite)),
                          if (author.memberId != null)
                            Text(author.memberId!,
                                style: const TextStyle(
                                    color: kSecondaryTextColor, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(feed.content ?? '',
                    style: const TextStyle(fontSize: 15, color: kWhite)),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    foregroundColor: kWhite,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    onSend();
                  },
                  child: const Text('Send Enquiry',
                      style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      );
    },
  );
}
