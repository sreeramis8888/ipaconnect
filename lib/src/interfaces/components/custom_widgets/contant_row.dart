
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/interfaces/components/custom_widgets/contact_icon.dart';

class ContactRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const ContactRow({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ContactIcon(
          icon: icon,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(color: kBlack, fontSize: 13),
          ),
        )
      ],
    );
  }
}