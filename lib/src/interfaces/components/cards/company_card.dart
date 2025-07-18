import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/utils/globals.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_button.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ipaconnect/src/interfaces/components/dropdown/company_card_options_dropdown.dart';
import 'package:ipaconnect/src/interfaces/components/custom_widgets/star_rating.dart';

class CompanyCard extends StatelessWidget {
  final String companyName;
  final double rating;
  final String userName;
  final String companyUserId;
  final String industry;
  final String location;
  final bool isActive;
  final String? imageUrl;
  final VoidCallback? onViewDetails;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CompanyCard({
    Key? key,
    required this.companyName,
    required this.rating,
    required this.industry,
    required this.location,
    required this.isActive,
    this.imageUrl,
    this.onViewDetails,
    this.onEdit,
    this.onDelete,
    required this.companyUserId,
    required this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: kCardBackgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Company Image
              Container(
                height: 120,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFF3A3D4E),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Image.network(
                    imageUrl ?? '',
                    fit: BoxFit.cover,
                    height: 120,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Shimmer.fromColors(
                        baseColor: kCardBackgroundColor,
                        highlightColor: kStrokeColor,
                        child: Container(
                          height: 120,
                          color: kCardBackgroundColor,
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Shimmer.fromColors(
                        baseColor: kCardBackgroundColor,
                        highlightColor: kStrokeColor,
                        child: Container(
                          height: 120,
                          color: kCardBackgroundColor,
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(companyName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: kSubHeadingB),
                        ),
                        // if (isActive)
                        //   Container(
                        //     padding: const EdgeInsets.symmetric(
                        //         horizontal: 8, vertical: 4),
                        //     decoration: BoxDecoration(
                        //       border: Border.all(
                        //         color: Color(0xFF05C168).withOpacity(.3),
                        //       ),
                        //       color: Color(0xFF05C168).withOpacity(.2),
                        //       borderRadius: BorderRadius.circular(5),
                        //     ),
                        //     child: Row(
                        //       mainAxisSize: MainAxisSize.min,
                        //       children: [
                        //         Container(
                        //           width: 6,
                        //           height: 6,
                        //           decoration: const BoxDecoration(
                        //             color: Colors.green,
                        //             shape: BoxShape.circle,
                        //           ),
                        //         ),
                        //         const SizedBox(width: 4),
                        //         Text('Active',
                        //             style: kSmallerTitleR.copyWith(
                        //                 fontSize: 10,
                        //                 color: Color(0xFF14CA74))),
                        //       ],
                        //     ),
                        //   ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Rating
                    Row(
                      children: [
                        StarRating(
                          rating: rating,
                          size: 12,
                          showNumber: true,
                          color: Colors.amber,
                          numberStyle: kSmallTitleR.copyWith(
                              color: kSecondaryTextColor, fontSize: 10),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Position
                    Row(
                      children: [
                        const Icon(FontAwesomeIcons.userTie,
                            color: kSecondaryTextColor, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            userName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: kSecondaryTextColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Industry
                    Row(
                      children: [
                        const Icon(Icons.business_center_sharp,
                            color: kSecondaryTextColor, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            industry,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: kSecondaryTextColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Location
                    Row(
                      children: [
                        const Icon(Icons.location_on_rounded,
                            color: kSecondaryTextColor, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: kSecondaryTextColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // View Details Button
                    SizedBox(
                        width: double.infinity,
                        child: customButton(
                          icon: Icon(
                            Icons.remove_red_eye,
                            color: kWhite,
                          ),
                          label: 'View Details',
                          onPressed: onViewDetails,
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (companyUserId == id)
          Positioned(
            top: 4,
            right: 8,
            child: CompanyCardOptionsDropdown(
              onEdit: onEdit,
              onDelete: onDelete,
            ),
          ),
      ],
    );
  }
}
