import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_button.dart';
import 'package:ipaconnect/src/data/notifiers/cart_notifier.dart';
import 'package:ipaconnect/src/data/models/cart_model.dart';
import 'package:ipaconnect/src/data/notifiers/store_notifier.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_round_button.dart';
import 'package:ipaconnect/src/interfaces/components/loading/loading_indicator.dart';
import 'package:ipaconnect/src/interfaces/components/painter/dot_line_painter.dart';
import 'package:ipaconnect/src/interfaces/main_pages/store/checkout_page.dart';
import 'package:ipaconnect/src/data/utils/currency_converted.dart';

class CartPage extends ConsumerStatefulWidget {
  final String userCurrency;
  const CartPage({super.key, required this.userCurrency});

  @override
  ConsumerState<CartPage> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  @override
  void initState() {
    super.initState();
    ref.read(cartNotifierProvider.notifier).fetchCart();
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartNotifierProvider);
    final cartNotifier = ref.read(cartNotifierProvider.notifier);
    final cartItems = cart?.products ?? [];
    final total = cartNotifier.getCartTotal();
    final storeNotifier = ref.watch(storeNotifierProvider.notifier);
    final isLoading = cartNotifier.isLoading;
    final isFirstLoad = cartNotifier.isFirstLoad;

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
        title: Text('Cart',
            style: kBodyTitleR.copyWith(color: kSecondaryTextColor)),
      ),
      body: isLoading && isFirstLoad
          ? const Center(child: LoadingAnimation())
          : Column(
              children: [
                Expanded(
                  child: cartItems.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.shopping_cart_outlined,
                                  size: 80, color: kGrey),
                              const SizedBox(height: 16),
                              Text('Your cart is empty', style: kLargeTitleSB),
                              const SizedBox(height: 8),
                              Text('Add some products to get started',
                                  style: kBodyTitleR),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            final item = cartItems[index];
                            final cartId = cart?.id ?? '';

                            final storeId = item.store?.id ?? '';
                            final storeName = item.store?.name ?? 'Unknown';
                            final quantity = item.quantity ?? 0;

                            if (storeId == '') return const SizedBox.shrink();

                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: kCardBackgroundColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    // Product image
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Icon(
                                            Icons.image,
                                            color: Colors.white,
                                            size: 32,
                                          );
                                        },
                                        item.store?.image ?? '',
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    // Name and Price
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            storeName,
                                            style: kBodyTitleSB,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              FutureBuilder<double?>(
                                                future: convertCurrency(
                                                  from: item.store?.currency ??
                                                      '',
                                                  to: widget.userCurrency,
                                                  amount:
                                                      item.store?.price ?? 0,
                                                ),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return Text('Loading...',
                                                        style: kBodyTitleB);
                                                  } else if (snapshot
                                                          .hasError ||
                                                      snapshot.data == null) {
                                                    return Text('Error',
                                                        style: kBodyTitleB);
                                                  } else {
                                                    return Row(
                                                      children: [
                                                        Text(
                                                            snapshot.data!
                                                                .toStringAsFixed(
                                                                    2),
                                                            style: kBodyTitleB),
                                                        const SizedBox(
                                                            width: 4),
                                                        Text(
                                                            widget.userCurrency,
                                                            style: kSmallerTitleR
                                                                .copyWith(
                                                                    color:
                                                                        kGrey)),
                                                      ],
                                                    );
                                                  }
                                                },
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: kStrokeColor,
                                                  borderRadius:
                                                      BorderRadius.circular(2),
                                                ),
                                                child: Row(
                                                  children: [
                                                    InkWell(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 5,
                                                                right: 5),
                                                        child: Icon(
                                                          size: 16,
                                                          Icons.remove,
                                                          color: kWhite,
                                                        ),
                                                      ),
                                                      onTap: cartId.isNotEmpty
                                                          ? () async {
                                                              await cartNotifier
                                                                  .decrementQuantity(
                                                                      cartId,
                                                                      storeId);
                                                            }
                                                          : null,
                                                    ),
                                                    Text('$quantity',
                                                        style: kSmallTitleR),
                                                    InkWell(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 5,
                                                                right: 5),
                                                        child: Icon(
                                                          size: 16,
                                                          Icons.add,
                                                          color: kWhite,
                                                        ),
                                                      ),
                                                      onTap: cartId.isNotEmpty
                                                          ? () async {
                                                              await cartNotifier
                                                                  .incrementQuantity(
                                                                      cartId,
                                                                      storeId);
                                                            }
                                                          : null,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Quantity control
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
                if (cartItems.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Column(
                          children: cartItems
                              .map((item) => Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(item.store?.name ?? '',
                                          style: kSmallTitleR),
                                      FutureBuilder<double?>(
                                        future: convertCurrency(
                                          from: item.store?.currency != null
                                              ? item.store?.currency
                                                      .toString() ??
                                                  ''
                                              : '',
                                          to: widget.userCurrency,
                                          amount: item.store?.price ?? 0.0,
                                        ),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text('Loading...',
                                                    style: kSmallTitleR),
                                              ],
                                            );
                                          } else if (snapshot.hasError ||
                                              snapshot.data == null) {
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(''),
                                                Text('Error',
                                                    style: kLargeTitleSB),
                                              ],
                                            );
                                          } else {
                                            final convertedTotalAmount =
                                                snapshot.data!;
                                            return Row(
                                              children: [
                                                Text(
                                                    convertedTotalAmount
                                                        .toStringAsFixed(2),
                                                    style: kSmallTitleR),
                                                SizedBox(
                                                  width: 4,
                                                ),
                                                Text(widget.userCurrency,
                                                    style:
                                                        kSmallerTitleR.copyWith(
                                                            color: kGrey)),
                                              ],
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ))
                              .toList(),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          height: 1,
                          child: CustomPaint(
                            size: const Size(double.infinity, 1),
                            painter: DottedLinePainter(),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total', style: kSmallTitleR),
                          ],
                        ),
                        FutureBuilder<double?>(
                          future: convertCurrency(
                            from: cartItems.isNotEmpty
                                ? cartItems.first.store?.currency ?? ''
                                : '',
                            to: widget.userCurrency,
                            amount: total,
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(''),
                                      Text('Loading...', style: kSmallTitleR),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  customButton(
                                    label: 'Proceed to Checkout',
                                    onPressed: null, // Disabled while loading
                                  ),
                                ],
                              );
                            } else if (snapshot.hasError ||
                                snapshot.data == null) {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(''),
                                      Text('Error', style: kLargeTitleSB),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  customButton(
                                    label: 'Proceed to Checkout',
                                    onPressed: null, // Disabled on error
                                  ),
                                ],
                              );
                            } else {
                              final convertedTotalAmount = snapshot.data!;
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(''),
                                      Row(
                                        children: [
                                          Text(
                                              convertedTotalAmount
                                                  .toStringAsFixed(2),
                                              style: kSmallTitleR),
                                          const SizedBox(width: 4),
                                          Text(widget.userCurrency,
                                              style: kSmallerTitleR.copyWith(
                                                  color: kGrey)),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  customButton(
                                    label: 'Proceed to Checkout',
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CheckoutPage(
                                            userCurrency: widget.userCurrency,
                                            totalAmount: convertedTotalAmount,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }
}
