import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CertificateWidget extends StatelessWidget {
  final String userName;
  final String memberId;
  final String dateofjoining;

  const CertificateWidget({
    required this.userName,
    required this.memberId,
    required this.dateofjoining,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Format date from YYYY-MM-DD to DD-MM-YYYY
    String formatDate(String dateString) {
      try {
        final dateTime = DateTime.parse(dateString);
        return DateFormat('dd-MM-yyyy').format(dateTime);
      } catch (e) {
        return dateString; // Return original if parsing fails
      }
    }

    final formattedDate = formatDate(dateofjoining);

    return AspectRatio(
      aspectRatio: 1.4,
      child: LayoutBuilder(builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final double height = constraints.maxHeight;
        return Stack(
          children: [
            // Background Certificate Template
            Positioned.fill(
              child: Image.asset(
                'assets/pngs/certificate.png',
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            Positioned(
              top: height * 0.44,
              left: width * 0.35,
              child: Text(
                userName,
                style: GoogleFonts.frankRuhlLibre(
                  textStyle: TextStyle(
                    fontSize: width * 0.045,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF081058),
                  ),
                ),
              ),
            ),

            // Overlay Membership ID
            Positioned(
              top: height * 0.730,
              left: width * 0.52,
              child: Text(
                memberId,
                style: GoogleFonts.frankRuhlLibre(
                  textStyle: TextStyle(
                    fontSize: width * 0.017,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF081058),
                  ),
                ),
              ),
            ),

            //joined date
            Positioned(
              top: height * 0.730,
              left: width * 0.71,
              child: Text(
                formattedDate,
                style: GoogleFonts.frankRuhlLibre(
                  textStyle: TextStyle(
                    fontSize: width * 0.017,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF081058),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
