import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/models/order_model.dart';
import 'package:ipaconnect/src/data/services/api_routes/store_api/store_api_service.dart';
import 'package:ipaconnect/src/interfaces/components/loading/loading_indicator.dart';

class MyOrdersPage extends ConsumerWidget {
  const MyOrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(_ordersProvider);
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kWhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('My Orders', style: kHeadTitleSB),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: kWhite),
            onPressed: () {},
          ),
        ],
      ),
      body: ordersAsync.when(
        loading: () => const Center(child: LoadingAnimation()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (orders) => orders.isEmpty
            ? Center(
                child: Text('No orders found.', style: kLargeTitleSB),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  final productName =
                      (order as dynamic).store_name ?? 'Product';
                  final productImage = (order as dynamic).store_image;
                  final price = order.amount ?? 0;
                  final quantity = order.quantity ?? 0;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: kCardBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                          child: productImage != null && productImage.isNotEmpty
                              ? Image.network(
                                  productImage,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  width: 80,
                                  height: 80,
                                  color: kGrey,
                                  child: const Icon(Icons.image,
                                      color: kWhite, size: 40),
                                ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(productName, style: kBodyTitleSB),
                                const SizedBox(height: 8),
                                Text('₹${price.toStringAsFixed(0)}',
                                    style: kLargeTitleSB),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child:
                              Text('Quantity: $quantity', style: kBodyTitleR),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}

final _ordersProvider = FutureProvider<List<OrderModel>>((ref) async {
  final service = ref.read(storeApiServiceProvider);
  return await service.getOrders();
});
