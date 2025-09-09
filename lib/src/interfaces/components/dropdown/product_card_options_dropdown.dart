import 'package:flutter/material.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';

class ProductCardOptionsDropdown extends StatelessWidget {
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ProductCardOptionsDropdown({
    Key? key,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      icon: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xFFF7F7F7).withOpacity(0.5),
        ),
        child: const Icon(Icons.more_vert, color: kBlack),
      ),
      color: const Color(0xFF03162B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      onSelected: (value) {
        if (value == 0 && onEdit != null) {
          onEdit!();
        } else if (value == 1 && onDelete != null) {
          onDelete!();
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 0,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
            child: Text('Edit', style: TextStyle(color: kWhite)),
          ),
        ),
        PopupMenuItem(
          enabled: false,
          height: 1,
          child: Container(height: .5, color: kStrokeColor),
        ),
        const PopupMenuItem(
          value: 1,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
            child: Text('Delete', style: TextStyle(color: Color(0xFFFF4B4B))),
          ),
        ),
      ],
    );
  }
}










