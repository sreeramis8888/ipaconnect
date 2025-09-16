import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/models/user_model.dart';
import 'package:ipaconnect/src/data/utils/sharePdf_certificate.dart';
import 'package:ipaconnect/src/data/utils/share_certificate.dart';
import 'package:ipaconnect/src/data/utils/share_qr.dart';
import 'package:ipaconnect/src/interfaces/components/animations/staggered_entrance.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_button.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_round_button.dart';
import 'package:ipaconnect/src/interfaces/components/cards/ccustom_certificate.dart';
import 'package:ipaconnect/src/interfaces/components/cards/certificate_card.dart';
import 'package:pdf/widgets.dart' as pw;

class MyCertificatePage extends ConsumerStatefulWidget {
   final UserModel user;
  const MyCertificatePage({super.key,required this.user});

  @override
  ConsumerState<MyCertificatePage> createState() => _MyCertificatePageState();
}

class _MyCertificatePageState extends ConsumerState<MyCertificatePage> {


  
// Function to create PDF bytes
Future<Uint8List> generateCertificatePdf(String userName, String memberId) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) => pw.Center(
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Text("Membership Certificate", style: pw.TextStyle(fontSize: 28)),
            pw.SizedBox(height: 20),
            pw.Text("This is to certify that:", style: pw.TextStyle(fontSize: 18)),
            pw.SizedBox(height: 10),
            pw.Text(userName, style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Text("Member ID: $memberId", style: pw.TextStyle(fontSize: 16)),
          ],
        ),
      ),
    ),
  );

  return pdf.save();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: CustomRoundButton(
              offset: const Offset(4, 0),
              iconPath: 'assets/svg/icons/arrow_back_ios.svg',
            ),
          ),
        ),
        scrolledUnderElevation: 0,
        title: Text(
          'My Certificate',
          style: kBodyTitleB.copyWith(color: kSecondaryTextColor),
        ),
        backgroundColor: kBackgroundColor,
        iconTheme: const IconThemeData(color: kSecondaryTextColor),
      ),
      body: StartupStagger(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
          
              /// Title
              StaggerItem(
                order: 0,
                child: Center(
                  child: Text(
                    'Your Membership Certificate Is Ready!',
                    style: kHeadTitleB.copyWith(color: kTextColor),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 24),
          
              
              StaggerItem(
                order: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CertificateWidget(userName: widget.user.name ?? '', memberId: widget.user.memberId ?? "",)
                ),
              ),
          
              const SizedBox(height: 32),
          
              
              StaggerItem(
                order: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      customButton(
                        label: 'Download PNG', 
                        icon: const Icon(Icons.image, color: kWhite),
                        onPressed: () => captureAndShareCertificate(
                        context,
                        userName: widget.user.name ?? '',
                        memberId: widget.user.memberId ?? '',
                        download: true, 
                      ),
                        ),
                      const SizedBox(height: 12),
                      customButton(
                        label: 'Download PDF', 
                        icon: const Icon(Icons.picture_as_pdf, color: kWhite),
                        onPressed:() async {
                        final pdfBytes = await generateCertificatePdf(
                          widget.user.name ?? '',
                          widget.user.memberId ?? '',
                        );

                        await savePdf(pdfBytes, "certificate_${widget.user.name}",);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("PDF saved to Downloads")),
                        );
                      },
                        ),
                      const SizedBox(height: 12),
                      customButton(
                        label: 'Share', 
                        icon: const Icon(Icons.share, color: kWhite),
                        onPressed: () => captureAndShareCertificate(
                                                context,
                                                 userName: widget.user.name ?? '',
                                                 memberId: widget.user.memberId ?? '',
                                              ),),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
