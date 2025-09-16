import 'dart:typed_data';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/interfaces/components/animations/staggered_entrance.dart';
import 'package:ipaconnect/src/interfaces/components/cards/ccustom_certificate.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';

Future<void> captureAndShareCertificate(
  BuildContext context, {
  required String userName,
  required String memberId,
  bool download = false,
}) async {
  final boundaryKey = GlobalKey();

  
  final widgetToCapture = RepaintBoundary(
    key: boundaryKey,
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: kBackgroundColor,
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
          
              
              StaggerItem(
                order: 0,
                child: Center(
                  child: Text(
                    '',
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
                  child: CertificateWidget(userName: userName ?? '', memberId: memberId?? "",)
                ),
              ),
          
              const SizedBox(height: 32),
          
              
            ],
          ),
      ),
    ),
  );

  
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (_) => Material(
      color: Colors.transparent,
      child: Center(child: widgetToCapture),
    ),
  );

  overlay.insert(overlayEntry);
  await Future.delayed(const Duration(milliseconds: 500));

  final boundary =
      boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
  if (boundary == null) {
    overlayEntry.remove();
    return;
  }

  // Convert to image
  final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  overlayEntry.remove();

  if (byteData == null) return;
  final Uint8List pngBytes = byteData.buffer.asUint8List();

  // Save temporarily
  final tempDir = await getTemporaryDirectory();
  final file = File('${tempDir.path}/certificate.png');
  await file.writeAsBytes(pngBytes);

  if (download) {
    await ImageGallerySaverPlus.saveFile(file.path);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Certificate saved!")));
  } else {
    Share.shareXFiles([XFile(file.path)], text: " ");
  }
}
