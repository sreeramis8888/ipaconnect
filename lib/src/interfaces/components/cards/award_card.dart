import 'package:flutter/material.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/models/user_model.dart';
import 'package:ipaconnect/src/interfaces/components/dialogs/image_details_dialog.dart';
import 'package:ipaconnect/src/interfaces/components/dropdown/remove_edit_dropdown.dart';

class AwardCard extends StatelessWidget {
  final VoidCallback? onRemove;
  final VoidCallback? onEdit;

  final Award award;

  const AwardCard(
      {required this.onRemove,
      required this.award,
      super.key,
      required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showImageDetails(
          context: context,
          imageUrl: award.image ?? '',
          title: award.name ?? '',
          subtitle: award.authority,
        );
      },
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 12, top: 0),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: kStrokeColor,
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          height: 150.0,
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 90.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(award.image ?? ''),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                    ),
                  ),
                  if (onRemove != null)
                    Positioned(
                      top: 4.0,
                      right: 10.0,
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: kStrokeColor),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: RemoveEditDropdown(
                              onRemove: onRemove!,
                              onEdit: onEdit!,
                            ),
                          )),
                    ),
                ],
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                      ),
                      color: kCardBackgroundColor),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Flexible(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                award.name ?? '',
                                style: kSmallTitleR,
                              ),
                            ),
                          ),
                          Text(
                            award.authority ?? '',
                            style: kSmallTitleR,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
