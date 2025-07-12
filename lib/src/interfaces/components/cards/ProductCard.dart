import 'package:flutter/material.dart';
import 'package:ipaconnect/src/data/models/product_model.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/utils/globals.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_button.dart';
import 'package:ipaconnect/src/interfaces/components/dialogs/block_report_dialogue.dart';
import 'package:ipaconnect/src/interfaces/components/dropdown/block_report_dropdown.dart';
import 'package:ipaconnect/src/interfaces/main_pages/business/ProductDetailsPage.dart';
import 'package:ipaconnect/src/interfaces/components/custom_widgets/star_rating.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final String category;
  final String companyUserId;
  const ProductCard({
    Key? key,
    required this.product,
    required this.category,
    required this.companyUserId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        product.images.isNotEmpty ? product.images.first.url : null;
    return Container(
      decoration: BoxDecoration(
        color: kCardBackgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: imageUrl != null
                    ? Image.network(
                        imageUrl,
                        height: 140,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 140,
                          color: kCardBackgroundColor,
                          child: Icon(Icons.broken_image,
                              color: kSecondaryTextColor, size: 40),
                        ),
                      )
                    : Container(
                        height: 140,
                        color: kCardBackgroundColor,
                        child: Icon(Icons.image,
                            color: kSecondaryTextColor, size: 40),
                      ),
              ),
              if (companyUserId != id)
                Positioned(
                  right: 0,
                  child: PopupMenuButton<String>(
                    color: kCardBackgroundColor,
                    icon: const Icon(
                      Icons.more_vert,
                      color: kStrokeColor,
                    ),
                    onSelected: (value) {
                      showReportPersonDialog(
                        context: context,
                        onReportStatusChanged: () {},
                        reportType: 'Product',
                        reportedItemId: product.id,
                      );
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'report',
                        child: Row(
                          children: [
                            Icon(
                              Icons.report,
                              color: kPrimaryColor,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Report',
                              style: kSmallTitleB,
                            ),
                          ],
                        ),
                      ),
                    ],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    offset: const Offset(0, 40),
                  ),
                ),
            ],
          ),
          // Product Details
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: kSmallTitleB.copyWith(color: kWhite),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    StarRating(
                      rating: product.rating ?? 0,
                      size: 14,
                      showNumber: true,
                      color: Colors.amber,
                      numberStyle: kSmallTitleR.copyWith(
                          color: Colors.white, fontSize: 10),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Seller: ${product.user.name}',
                  style: kSmallerTitleR.copyWith(
                      color: kSecondaryTextColor, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '₹${product.actualPrice.toStringAsFixed(0)}',
                      style: kBodyTitleR.copyWith(
                        color: kPrimaryColor,
                        fontSize: 16,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: kPrimaryColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '₹${product.discountPrice.toStringAsFixed(0)}',
                      style: kBodyTitleB.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                customButton(
                  label: 'View Details',
                  icon:
                      Icon(Icons.remove_red_eye, color: Colors.white, size: 18),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      'ProductDetails',
                      arguments: {
                        'product': product,
                        'category': category,
                      },
                    );
                  },
                  buttonHeight: 38,
                  fontSize: 15,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
