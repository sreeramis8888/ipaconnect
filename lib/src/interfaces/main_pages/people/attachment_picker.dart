import 'package:flutter/material.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';

class AttachmentPicker extends StatelessWidget {
  final VoidCallback onGallery;
  final VoidCallback onDocument;
  final VoidCallback onCamera;
  // final VoidCallback onContact;
  // final VoidCallback onLocation;

  const AttachmentPicker({
    Key? key,
    required this.onGallery,
    required this.onDocument,
    required this.onCamera,
    // required this.onContact,
    // required this.onLocation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kCardBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 24,
        runSpacing: 24,
        children: [
          _buildOption(
              context, Icons.image, 'Gallery', onGallery, Colors.purple),
          _buildOption(context, Icons.insert_drive_file, 'Document', onDocument,
              Colors.blue),
          _buildOption(
              context, Icons.camera_alt, 'Camera', onCamera, Colors.green),
          // _buildOption(context, Icons.contacts, 'Contact', onContact, Colors.orange),
          // _buildOption(context, Icons.location_on, 'Location', onLocation, Colors.red),
        ],
      ),
    );
  }

  Widget _buildOption(BuildContext context, IconData icon, String label,
      VoidCallback onTap, Color color) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: color,
            radius: 28,
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: kSmallTitleR),
        ],
      ),
    );
  }
}
