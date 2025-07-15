import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/models/events_model.dart';
import 'package:ipaconnect/src/data/services/navigation_service.dart';
import 'package:ipaconnect/src/data/utils/globals.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_button.dart';

Widget eventWidget({
  required BuildContext context,
  required EventsModel event,
}) {
  String formattedDate = 'TBA';
  bool registered = event.rsvp?.contains(id) ?? false;
  if (event.eventStartDate != null && event.eventEndDate != null) {
    try {
      DateTime start = event.eventStartDate!.toLocal();
      DateTime end = event.eventEndDate!.toLocal();

      if (DateFormat('MMM dd').format(start) ==
          DateFormat('MMM dd').format(end)) {
        formattedDate = DateFormat('MMM dd').format(start); // Same day event
      } else {
        formattedDate =
            '${DateFormat('MMM dd').format(start)} - ${DateFormat('MMM dd').format(end)}';
      }
    } catch (_) {
      formattedDate = 'Invalid Date';
    }
  }

  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10),
    decoration: BoxDecoration(
      border: Border.all(color: kStrokeColor),
      borderRadius: BorderRadius.circular(12),
      color: kCardBackgroundColor,
    ),
    clipBehavior: Clip.antiAlias,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Background Image
        CachedNetworkImage(
          imageUrl: event.image ?? '',
          width: double.infinity,
          height: 140,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            width: double.infinity,
            height: 140,
            color: Colors.grey[300],
          ),
          errorWidget: (context, url, error) => Container(
            width: double.infinity,
            height: 140,
            color: Colors.grey[300],
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Text(
            '${event.eventName}',
            style: kSubHeadingB,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Text(
            '${event.eventName}',
            style: kSmallerTitleR,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: kWhite,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      formattedDate,
                      style: const TextStyle(
                          fontSize: 14,
                          color: kCardBackgroundColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  // const SizedBox(width: 8),
                  // Text(
                  //   timeRange,
                  //   style: const TextStyle(color: kWhite),
                  // ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: customButton(
                      label: registered ? 'REGISTERED' : 'Register Now',
                      onPressed: () {
                        NavigationService navigationService =
                            NavigationService();
                        navigationService.pushNamed('EventDetails',
                            arguments: event);
                      },
                    ),
                  ),
                  // const SizedBox(width: 10),
                  // Container(
                  //   decoration: BoxDecoration(
                  //     color: kStrokeColor,
                  //     borderRadius: BorderRadius.circular(8),
                  //   ),
                  //   padding:
                  //       const EdgeInsets.symmetric(horizontal: 8, vertical: 13),
                  //   child: const Icon(Icons.bookmark_border, color: kWhite),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
