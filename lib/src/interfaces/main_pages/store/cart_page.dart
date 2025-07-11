import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_button.dart';
import 'package:ipaconnect/src/data/notifiers/cart_notifier.dart';
import 'package:ipaconnect/src/data/models/cart_model.dart';
import 'package:ipaconnect/src/data/notifiers/store_notifier.dart';
import 'package:ipaconnect/src/interfaces/main_pages/store/checkout_page.dart';

class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});

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
    final isLoading = storeNotifier.isLoading;
    final isFirstLoad = storeNotifier.isFirstLoad;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        title: Text('Cart', style: kHeadTitleSB),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kWhite),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading && isFirstLoad
          ? const Center(child: CircularProgressIndicator())
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
                                    // Product image placeholder (since we don't have store details in cart)
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: kGreyLight,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(Icons.image,
                                          size: 40, color: kGreyDark),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Product: $storeName',
                                            style: kBodyTitleSB,
                                          ),
                                          const SizedBox(height: 4),
                                          Text('Quantity: $quantity',
                                              style: kBodyTitleB),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.remove,
                                                    color: kWhite, size: 20),
                                                onPressed: cartId.isNotEmpty
                                                    ? () async {
                                                        await cartNotifier
                                                            .decrementQuantity(
                                                                cartId,
                                                                storeId);
                                                      }
                                                    : null,
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: kPrimaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: Text('$quantity',
                                                    style: kBodyTitleSB),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.add,
                                                    color: kWhite, size: 20),
                                                onPressed: cartId.isNotEmpty
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
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline,
                                          color: kRed),
                                      onPressed: () async {
                                        await cartNotifier
                                            .removeFromCart(storeId);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
                if (cartItems.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: kCardBackgroundColor,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total', style: kLargeTitleSB),
                            Text('₹${total.toStringAsFixed(2)}',
                                style: kLargeTitleSB),
                          ],
                        ),
                        const SizedBox(height: 16),
                        customButton(
                          label: 'Proceed to Checkout',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CheckoutPage(),
                              ),
                            );
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
