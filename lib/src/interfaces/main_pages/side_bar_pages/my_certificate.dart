import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/models/user_model.dart';
import 'package:ipaconnect/src/interfaces/components/animations/staggered_entrance.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_round_button.dart';
import 'package:ipaconnect/src/interfaces/components/cards/certificate_card.dart';

class MyCertificatePage extends ConsumerStatefulWidget {
  const MyCertificatePage({super.key});

  @override
  ConsumerState<MyCertificatePage> createState() => _MyCertificatePageState();
}

class _MyCertificatePageState extends ConsumerState<MyCertificatePage> {
  // Example certificate data for logged user
  final SubData certificate = SubData(
    name: "Membership Certificate",
    link:
        "https://your-server.com/certificate.png", // Replace with actual user certificate image link
  );

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
        child: Column(
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

            /// Use CertificateCard
            StaggerItem(
              order: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CertificateCard(
                  certificate: certificate,
                  onRemove: null, // no remove button here
                  onEdit: null,   // no edit button here
                ),
              ),
            ),

            const SizedBox(height: 32),

            /// Action Buttons
            StaggerItem(
              order: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        // TODO: implement PDF download
                      },
                      icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                      label: const Text("Download PDF"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[900],
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        // TODO: implement PNG download
                      },
                      icon: const Icon(Icons.image, color: Colors.white),
                      label: const Text("Download PNG"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        // TODO: implement share
                      },
                      icon: const Icon(Icons.share, color: Colors.white),
                      label: const Text("Share"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[500],
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
