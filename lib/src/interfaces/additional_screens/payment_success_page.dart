import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:share_plus/share_plus.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_button.dart';

class PaymentSuccessPage extends StatefulWidget {
  final String transactionId;
  final String transactionDate;
  final String amount;
  final String fees;
  final String total;
  final String currency;

  const PaymentSuccessPage({
    Key? key,
    required this.transactionId,
    required this.transactionDate,
    required this.amount,
    required this.fees,
    required this.total,
    required this.currency,
  }) : super(key: key);

  @override
  State<PaymentSuccessPage> createState() => _PaymentSuccessPageState();
}

class _PaymentSuccessPageState extends State<PaymentSuccessPage> {
  final GlobalKey _boundaryKey = GlobalKey();
  bool _saving = false;

  // Helper to build the payment success content, with or without share/download buttons and with optional logo
  Widget buildPaymentSuccessContent({required bool forScreenshot}) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            color: const Color(0xFF00031A),
            child: Image.asset(
              'assets/pngs/subcription_bg.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        Column(
          children: [
            const SizedBox(height: 40),
            if (forScreenshot)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: SvgPicture.asset('assets/svg/icons/ipa_logo.svg',
                    height: 32),
              ),
            Center(child: Image.asset('assets/pngs/payment_success.png')),
            const SizedBox(height: 32),
            Text(
              'Payment Successful',
              style: TextStyle(
                color: kWhite,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Your transaction is complete- thank you for your purchase',
              style: TextStyle(
                color: kSecondaryTextColor,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            // Transaction Details Container with stars
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: kWhite.withOpacity(0.05),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: kStrokeColor),
              ),
              child: Stack(
                children: [
                  // Star decorations (copied from subscription_page.dart)
                  Positioned(
                    top: 8,
                    left: 12,
                    child: SvgPicture.asset(
                      'assets/svg/icons/subscription_star.svg',
                      width: 18,
                      height: 18,
                    ),
                  ),
                  Positioned(
                    top: 40,
                    right: 24,
                    child: SvgPicture.asset(
                      'assets/svg/icons/subscription_star.svg',
                      width: 14,
                      height: 14,
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 40,
                    child: SvgPicture.asset(
                      'assets/svg/icons/subscription_star.svg',
                      width: 12,
                      height: 12,
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: SvgPicture.asset(
                      'assets/svg/icons/subscription_star.svg',
                      width: 16,
                      height: 16,
                    ),
                  ),
                  Positioned(
                    top: 20,
                    left: 80,
                    child: SvgPicture.asset(
                      'assets/svg/icons/subscription_star.svg',
                      width: 10,
                      height: 10,
                    ),
                  ),
                  Positioned(
                    top: 70,
                    right: 60,
                    child: SvgPicture.asset(
                      'assets/svg/icons/subscription_star.svg',
                      width: 13,
                      height: 13,
                    ),
                  ),
                  Positioned(
                    bottom: 40,
                    left: 20,
                    child: SvgPicture.asset(
                      'assets/svg/icons/subscription_star.svg',
                      width: 11,
                      height: 11,
                    ),
                  ),
                  Positioned(
                    bottom: 30,
                    right: 40,
                    child: SvgPicture.asset(
                      'assets/svg/icons/subscription_star.svg',
                      width: 15,
                      height: 15,
                    ),
                  ),
                  Positioned(
                    top: 100,
                    left: 30,
                    child: SvgPicture.asset(
                      'assets/svg/icons/subscription_star.svg',
                      width: 9,
                      height: 9,
                    ),
                  ),
                  Positioned(
                    bottom: 60,
                    right: 20,
                    child: SvgPicture.asset(
                      'assets/svg/icons/subscription_star.svg',
                      width: 12,
                      height: 12,
                    ),
                  ),
                  // More small stars for a denser effect
                  Positioned(
                    top: 12,
                    left: 120,
                    child: SvgPicture.asset(
                      'assets/svg/icons/subscription_star.svg',
                      width: 7,
                      height: 7,
                    ),
                  ),
                  Positioned(
                    top: 55,
                    left: 60,
                    child: SvgPicture.asset(
                      'assets/svg/icons/subscription_star.svg',
                      width: 8,
                      height: 8,
                    ),
                  ),
                  Positioned(
                    top: 90,
                    right: 30,
                    child: SvgPicture.asset(
                      'assets/svg/icons/subscription_star.svg',
                      width: 6,
                      height: 6,
                    ),
                  ),
                  Positioned(
                    bottom: 22,
                    right: 70,
                    child: SvgPicture.asset(
                      'assets/svg/icons/subscription_star.svg',
                      width: 7,
                      height: 7,
                    ),
                  ),
                  Positioned(
                    bottom: 55,
                    left: 90,
                    child: SvgPicture.asset(
                      'assets/svg/icons/subscription_star.svg',
                      width: 8,
                      height: 8,
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 110,
                    child: SvgPicture.asset(
                      'assets/svg/icons/subscription_star.svg',
                      width: 6,
                      height: 6,
                    ),
                  ),
                  Positioned(
                    top: 110,
                    right: 50,
                    child: SvgPicture.asset(
                      'assets/svg/icons/subscription_star.svg',
                      width: 7,
                      height: 7,
                    ),
                  ),
                  Positioned(
                    top: 130,
                    left: 60,
                    child: SvgPicture.asset(
                      'assets/svg/icons/subscription_star.svg',
                      width: 9,
                      height: 9,
                    ),
                  ),
                  // Actual content
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!forScreenshot) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: customButton(
                                label: 'Share',
                                onPressed: _shareScreenshot,
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF213394).withOpacity(.12),
                                    Color(0x1FFFFFFF).withOpacity(.12),
                                  ],
                                  stops: [0.0, 1.0],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                icon: const Icon(
                                  Icons.share,
                                  color: kWhite,
                                  size: 15,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: customButton(
                                label: 'Download',
                                onPressed: _saving ? null : _saveToGallery,
                                isLoading: _saving,
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF213394).withOpacity(.12),
                                    Color(0x1FFFFFFF).withOpacity(.12),
                                  ],
                                  stops: [0.0, 1.0],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                icon: const Icon(
                                  Icons.download,
                                  color: kWhite,
                                  size: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                      const Text('Transaction Details',
                          style: TextStyle(
                              color: kWhite,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                      const SizedBox(height: 10),
                      _detailRow('Transaction date', widget.transactionDate),
                      _detailRow(
                          'Amount', '${widget.amount} ${widget.currency}'),
                      _detailRow('Transaction ID', '#${widget.transactionId}'),
                      _detailRow('Fees', '${widget.fees} ${widget.currency}'),
                      _detailRow('Total', '${widget.total} ${widget.currency}',
                          isBold: true),
                      // Only show share/download buttons if not for screenshot
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _captureAndShareOrDownload({required bool download}) async {
    final boundaryKey = GlobalKey();
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (_) => Material(
        color: Colors.transparent,
        child: Center(
          child: RepaintBoundary(
            key: boundaryKey,
            child: buildPaymentSuccessContent(forScreenshot: true),
          ),
        ),
      ),
    );
    overlay.insert(overlayEntry);
    await Future.delayed(const Duration(milliseconds: 500));
    final boundary = boundaryKey.currentContext?.findRenderObject()
        as RenderRepaintBoundary?;
    if (boundary == null) {
      overlayEntry.remove();
      return;
    }
    final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    overlayEntry.remove();
    if (byteData == null) return;
    final Uint8List pngBytes = byteData.buffer.asUint8List();
    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/payment_success.png')
        .writeAsBytes(pngBytes);
    if (download) {
      final result = await ImageGallerySaverPlus.saveFile(file.path);
      ScaffoldMessenger.of(context).showSnackBar(result['isSuccess'] == true
          ? const SnackBar(content: Text('Saved to gallery!'))
          : const SnackBar(content: Text('Failed to save image.')));
    } else {
      await Share.shareXFiles([XFile(file.path)], text: 'Payment Success');
    }
  }

  Future<void> _shareScreenshot() async {
    await _captureAndShareOrDownload(download: false);
  }

  Future<void> _saveToGallery() async {
    setState(() => _saving = true);
    await _captureAndShareOrDownload(download: true);
    setState(() => _saving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1446),
      body: Stack(
        children: [
          // Background always fills the screen
          Positioned.fill(
            child: Container(
              color: const Color(0xFF00031A),
              child: Image.asset(
                'assets/pngs/subcription_bg.png',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.center,
              ),
            ),
          ),
          // Main content and bottom button
          Column(
            children: [
              // Expanded scrollable content
              Expanded(
                child: SingleChildScrollView(
                  child: RepaintBoundary(
                    key: _boundaryKey,
                    child: buildPaymentSuccessContent(forScreenshot: false),
                  ),
                ),
              ),
              // Bottom button (always visible)
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF00063F).withOpacity(0.86),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: customButton(
                    label: 'Skip To Home',
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        'MainPage',
                        (route) => route.isFirst,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  color: Colors.white70,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value,
              style: TextStyle(
                  color: kWhite,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
