import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/utils/currency_converted.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_button.dart';
import 'package:ipaconnect/src/data/notifiers/store_notifier.dart';
import 'package:ipaconnect/src/data/notifiers/cart_notifier.dart';
import 'package:ipaconnect/src/data/models/store_model.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_round_button.dart';
import 'package:ipaconnect/src/interfaces/components/loading/loading_indicator.dart';
// Removed unused my_orders_page import
import 'package:ipaconnect/src/interfaces/components/animations/staggered_entrance.dart';
import 'package:ipaconnect/src/data/services/api_routes/store_api/store_api_service.dart';

class StorePage extends ConsumerStatefulWidget {
  final String userCurrency;
  const StorePage({super.key, required this.userCurrency});

  @override
  ConsumerState<StorePage> createState() => _StorePageState();
}

class _StorePageState extends ConsumerState<StorePage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ref.read(storeNotifierProvider.notifier).refreshProducts();
    ref.read(cartNotifierProvider.notifier).fetchCart();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(storeNotifierProvider);
    final notifier = ref.read(storeNotifierProvider.notifier);
    final cart = ref.watch(cartNotifierProvider);
    final cartNotifier = ref.read(cartNotifierProvider.notifier);
    final storeApi = ref.read(storeApiServiceProvider);
    final isLoading = notifier.isLoading;
    // final hasMore = notifier.hasMore; // reserved for pagination UI
    final cartItemCount = (cart?.products?.length ?? storeApi.lastCartCount);

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: CustomRoundButton(
              offset: Offset(4, 0),
              iconPath: 'assets/svg/icons/arrow_back_ios.svg',
            ),
          ),
        ),
        backgroundColor: kBackgroundColor,
        elevation: 0,
        title: Text('IPA Store',
            style: kBodyTitleR.copyWith(color: kSecondaryTextColor)),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined, color: kWhite),
                onPressed: () {
                  Navigator.pushNamed(context, 'CartPage',
                      arguments: widget.userCurrency);
                },
              ),
              if (cartItemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: kRed,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$cartItemCount',
                      style: kSmallerTitleR.copyWith(fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            // Container(
            //   decoration: BoxDecoration(
            //     color: kCardBackgroundColor,
            //     borderRadius: BorderRadius.circular(8),
            //   ),
            //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            //   child: Row(
            //     children: [
            //       const Icon(Icons.search, color: kGrey),
            //       const SizedBox(width: 8),
            //       Expanded(
            //         child: TextField(
            //           controller: _searchController,
            //           style: kBodyTitleR,
            //           decoration: const InputDecoration(
            //             hintText: 'Search products',
            //             border: InputBorder.none,
            //             hintStyle: TextStyle(color: kGrey),
            //           ),
            //           onChanged: (value) {
            //             // TODO: Implement search functionality
            //             // ref.read(storeNotifierProvider.notifier).searchProducts(value);
            //           },
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            const SizedBox(height: 24),
            Expanded(
              child: isLoading
                  ? const Center(child: LoadingAnimation())
                  : products.isEmpty
                      ? const Center(
                          child: Text(
                            'No Products',
                            style: TextStyle(
                              fontSize: 16,
                              color: kSecondaryTextColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : GridView.builder(
                          controller: _scrollController,
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 220,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio:
                                MediaQuery.of(context).size.width /
                                    (MediaQuery.of(context).size.height / 1.3),
                          ),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return StartupStagger(
                              child: StaggerItem(
                                order: 0,
                                from: SlideFrom.bottom,
                                child: _ProductCard(
                                  userCurrency: widget.userCurrency,
                                  product: product,
                                  onAddToCart: () async {
                                    if (product.id != null) {
                                      final success = await cartNotifier
                                          .addToCart(product.id!, 1);
                                      if (success) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text('Added to cart'),
                                            backgroundColor: kGreen,
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content:
                                                Text('Item already in cart'),
                                            backgroundColor: kRed,
                                          ),
                                        );
                                      }
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                        ),
            )
          ],
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final StoreModel product;
  final VoidCallback onAddToCart;
  final String userCurrency;
  const _ProductCard({
    required this.product,
    required this.onAddToCart,
    required this.userCurrency,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kCardBackgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          Container(
            height: 115,
            width: double.infinity,
            decoration: BoxDecoration(
              color: kGreyLight,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              image: product.image != null
                  ? DecorationImage(
                      image: NetworkImage(product.image!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: product.image == null
                ? const Icon(Icons.image, size: 60, color: kGreyDark)
                : null,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name ?? 'Product Name',
                  style: kBodyTitleSB,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  product.description ?? 'No description available',
                  style: kSmallerTitleR,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    FutureBuilder<double?>(
                      future: convertCurrency(
                        from: product.currency ?? '',
                        to: userCurrency,
                        amount: product.price ?? 0,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text('Loading...', style: kBodyTitleB);
                        } else if (snapshot.hasError || snapshot.data == null) {
                          return Text('Error', style: kBodyTitleB);
                        } else {
                          return Text(snapshot.data!.toStringAsFixed(2),
                              style: kBodyTitleB);
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    Text(
                      userCurrency,
                      style: kSmallerTitleR.copyWith(color: kGrey),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                customButton(
                  label: 'Add to Cart',
                  onPressed: product.id != null ? onAddToCart : null,
                  fontSize: 12,
                  buttonHeight: 32,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
