import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/models/events_model.dart';
import 'package:ipaconnect/src/data/services/navigation_service.dart';
import 'package:ipaconnect/src/data/utils/globals.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_button.dart';
import 'package:ipaconnect/src/interfaces/components/animations/staggered_entrance.dart';
import 'package:ipaconnect/src/interfaces/components/dropdown/event_card_options_dropdown.dart';

Widget eventWidget({
  required BuildContext context,
  required EventsModel event,
  VoidCallback? onEdit,
  VoidCallback? onDelete,
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

  return StartupStagger(
    child: Stack(
      children: [
        Container(
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
              StaggerItem(
                order: 0,
                from: SlideFrom.bottom,
                child: CachedNetworkImage(
                  imageUrl: event.image ?? '',
                  width: double.infinity,
                  //event card height increased to 16:9 ration
                  height: MediaQuery.of(context).size.width * 9 / 16,
                  fit: BoxFit.fill,
                  placeholder: (context, url) => Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.width * 9 / 16,
                    color: Colors.grey[300],
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.width * 9 / 16,
                    color: Colors.grey[300],
                  ),
                ),
              ),
              StaggerItem(
                order: 1,
                from: SlideFrom.bottom,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Text(
                    '${event.eventName}',
                    style: kSubHeadingB,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              StaggerItem(
                order: 2,
                from: SlideFrom.bottom,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Text(
                    '${event.eventName}',
                    style: kSmallerTitleR,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              StaggerItem(
                order: 3,
                from: SlideFrom.bottom,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
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
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: customButton(
                              label: event.status?.toLowerCase() == 'completed'
                                  ? 'COMPLETED'
                                  : registered
                                      ? 'REGISTERED'
                                      : 'Register Now',
                              onPressed: () {
                                NavigationService navigationService =
                                    NavigationService();
                                navigationService.pushNamed('EventDetails',
                                    arguments: event);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (event.createdBy == id && (onEdit != null || onDelete != null))
          Positioned(
            top: 4,
            right: 8,
            child: EventCardOptionsDropdown(
              onEdit: onEdit,
              onDelete: onDelete,
            ),
          ),
      ],
    ),
  );
}
