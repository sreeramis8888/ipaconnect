import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ipaconnect/src/data/models/product_model.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_round_button.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_button.dart';
import 'package:ipaconnect/src/interfaces/components/shimmers/custom_shimmer.dart';

class ProductDetailsPage extends StatefulWidget {
  final String category;
  final ProductModel product;
  const ProductDetailsPage(
      {super.key, required this.product, required this.category});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int _currentIndex = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final images = product.images;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: CustomRoundButton(
            offset: Offset(4, 0),
            iconPath: 'assets/svg/icons/arrow_back_ios.svg',
          ),
        ),
        title: Text('View Product',
            style:
                kBodyTitleR.copyWith(fontSize: 16, color: kSecondaryTextColor)),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Images - Scrollable
            Container(
              width: double.infinity,
              height: 200,
              color: kCardBackgroundColor,
              child: images.isNotEmpty
                  ? PageView.builder(
                      controller: _pageController,
                      itemCount: images.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        final imageUrl = images[index].url;
                        return AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;

                              return ShimmerContainer(
                                width: double.infinity,
                                height: double.infinity,
                                borderRadius: BorderRadius.zero,
                              );
                            },
                            errorBuilder: (_, __, ___) => Center(
                              child: Icon(Icons.broken_image,
                                  color: kSecondaryTextColor, size: 60),
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Icon(Icons.image,
                          color: kSecondaryTextColor, size: 60),
                    ),
            ),
            // Dots indicator (animated)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(images.isNotEmpty ? images.length : 1,
                    (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: index == _currentIndex ? 20 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: index == _currentIndex
                          ? Colors.white
                          : Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
              ),
            ),
            // Product Info
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Product Information',
                      style: kBodyTitleB.copyWith(fontSize: 16)),
                  SizedBox(height: 6),
                  if (product.specifications.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: product.specifications
                          .map((spec) => Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('• ',
                                      style: TextStyle(
                                          color: kSecondaryTextColor)),
                                  Expanded(
                                      child: Text(spec,
                                          style: TextStyle(
                                              color: kSecondaryTextColor,
                                              fontWeight: FontWeight.w200))),
                                ],
                              ))
                          .toList(),
                    )
                  else
                    Text('-',
                        style: TextStyle(
                            color: kSecondaryTextColor,
                            fontWeight: FontWeight.w200)),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(FontAwesomeIcons.userTie,
                          color: kSecondaryTextColor, size: 14),
                      SizedBox(width: 6),
                      Text(
                        product.user.name,
                        style: kBodyTitleR.copyWith(
                            color: kSecondaryTextColor, fontSize: 13),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(0xFF1A233A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.category ?? '',
                      style: kBodyTitleR.copyWith(
                          color: Colors.white, fontSize: 11),
                    ),
                  ),
                  SizedBox(height: 16),
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
                      SizedBox(width: 8),
                      Text(
                        '₹${product.discountPrice.toStringAsFixed(0)}',
                        style: kBodyTitleB.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text('Ratings', style: kBodyTitleB.copyWith(fontSize: 15)),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 20),
                      Icon(Icons.star, color: Colors.amber, size: 20),
                      Icon(Icons.star, color: Colors.amber, size: 20),
                      Icon(Icons.star, color: Colors.amber, size: 20),
                      Icon(Icons.star_half, color: Colors.amber, size: 20),
                      SizedBox(width: 8),
                      Text('4.0', style: kBodyTitleR.copyWith(fontSize: 14)),
                    ],
                  ),
                  SizedBox(height: 4),
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        Text('View Reviews',
                            style: kBodyTitleR.copyWith(
                                color: kSecondaryTextColor, fontSize: 13)),
                        Icon(Icons.keyboard_arrow_down,
                            color: kSecondaryTextColor, size: 18),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  customButton(
                    label: 'Enquire Now',
                    onPressed: () {},
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
