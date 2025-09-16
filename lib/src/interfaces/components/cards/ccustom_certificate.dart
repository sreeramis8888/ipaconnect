import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CertificateWidget extends StatelessWidget {
  final String userName;
  final String memberId;
  

  const CertificateWidget({
    required this.userName,
    required this.memberId,
    
    
    super.key, 
  });

  @override
  Widget build(BuildContext context) {
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
              left: width * 0.57,
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
          ],
        );
      }),
    );
  }
}
