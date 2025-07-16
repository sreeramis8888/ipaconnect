import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/models/chat_model.dart';
import 'package:ipaconnect/src/data/models/feed_model.dart';
import 'package:ipaconnect/src/data/models/product_model.dart';
import 'package:ipaconnect/src/data/notifiers/feed_notifier.dart';
import 'package:ipaconnect/src/interfaces/components/dialogs/block_report_dialog.dart';

class BlockReportDropdown extends ConsumerWidget {
  final FeedModel? feed;
  final ProductModel? product;
  final MessageModel? msg;
  final String? userId;
  final VoidCallback? onBlockStatusChanged;
  final bool? isBlocked;

  const BlockReportDropdown({
    this.onBlockStatusChanged,
    this.userId,
    this.msg,
    super.key,
    this.feed,
    this.isBlocked,
    this.product,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: const Icon(
          Icons.more_vert,
          color: kWhite,
        ),
        items: [
          const DropdownMenuItem(
            value: 'report',
            child: const Text(
              'Report',
              style: TextStyle(color: Colors.red),
            ),
          ),
          DropdownMenuItem(
            value: 'block',
            child: isBlocked != null && isBlocked == false
                ? Text(
                    'Block',
                    style: TextStyle(color: Colors.red),
                  )
                : Text(
                    'Unblock',
                    style: TextStyle(color: Colors.red),
                  ),
          ),
        ],
        onChanged: (value) async {
          if (value == 'report') {
            String reportType = '';
            if (feed != null) {
              reportType = 'Requirements';
              showReportPersonDialog(
                  reportedItemId: feed?.id ?? '',
                  context: context,
                  onReportStatusChanged: () {},
                  reportType: reportType);
            } else if (userId != null) {
              log(userId.toString());
              reportType = 'Users';
              showReportPersonDialog(
                  reportedItemId: userId ?? '',
                  context: context,
                  userId: userId ?? '',
                  onReportStatusChanged: () {},
                  reportType: reportType);
            } else if (product != null) {
              log(product.toString());
              reportType = 'Product';
              showReportPersonDialog(
                  reportedItemId: product?.id ?? '',
                  context: context,
                  userId: userId ?? '',
                  onReportStatusChanged: () {},
                  reportType: reportType);
            } else {
              reportType = 'Message';
              showReportPersonDialog(
                  reportedItemId: msg?.id ?? '',
                  context: context,
                  onReportStatusChanged: () {},
                  reportType: reportType);
            }
          } else if (value == 'block') {
            if (feed != null) {
              showBlockPersonDialog(
                  context: context,
                  userId: feed?.user?.id ?? '',
                  onBlockStatusChanged: () {
                    ref.invalidate(feedNotifierProvider);
                  });
            } else if (userId != null) {
              showBlockPersonDialog(
                  context: context,
                  userId: userId ?? '',
                  onBlockStatusChanged: () {
                    onBlockStatusChanged;
                  });
            }
          }
        },
        buttonStyleData: ButtonStyleData(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          width: 180,
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: kStrokeColor,
          ),
          offset: const Offset(0, 0),
        ),
      ),
    );
  }
}
