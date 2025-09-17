import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/models/user_model.dart';
import 'package:ipaconnect/src/data/services/snackbar_service.dart';
import 'package:ipaconnect/src/data/utils/launch_url.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';

Future<void> captureAndShareOrDownloadWidgetScreenshot(BuildContext context,
    {bool download = false, required UserModel user}) async {
  // Prepare QR image bytes from base64 if available; tolerate any data URL prefix
  Uint8List? qrBytes;
  if (user.qrCode != null && user.qrCode!.isNotEmpty) {
    try {
      final String raw = user.qrCode!;
      final String base64Part = raw.contains(',') ? raw.split(',').last : raw;
      qrBytes = base64Decode(base64Part);
    } catch (_) {
      qrBytes = null;
    }
  }

  // Create a GlobalKey to hold the widget's RepaintBoundary
  final boundaryKey = GlobalKey();

  final widgetToCapture = RepaintBoundary(
    key: boundaryKey,
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: kBackgroundColor,
        body: Column(
          children: [
            Expanded(
              child: Center(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: kStrokeColor),
                    borderRadius: BorderRadius.circular(24),
                    color: Colors.transparent,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 16,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                          child: Stack(
                            children: [
                              ColorFiltered(
                                colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.4),
                                  BlendMode.darken,
                                ),
                                child: Image.asset(
                                  'assets/pngs/qr_background.png',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 320,
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                height: 320,
                                padding: const EdgeInsets.only(
                                    top: 20, left: 20, right: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/svg/ipaconnect_logo.svg',
                                          height: 22,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    GestureDetector(
                                      onTap: () => launchURL(
                                          'https://admin.ipaconnect.org/user/${user.id}'),
                                      child: Center(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: kWhite,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          padding: const EdgeInsets.all(16),
                                          child: qrBytes != null
                                              ? Image.memory(
                                                  qrBytes!,
                                                  width: 170,
                                                  height: 170,
                                                  errorBuilder: (context, error,
                                                          stackTrace) =>
                                                      Center(
                                                    child: Text(
                                                      'QR Error',
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                  ),
                                                )
                                              : QrImageView(
                                                  data:
                                                      'https://admin.ipaconnect.org/user/${user.id}',
                                                  version: QrVersions.auto,
                                                  size: 170,
                                                  gapless: false,
                                                  foregroundColor: Colors.black,
                                                  backgroundColor: kWhite,
                                                  errorStateBuilder:
                                                      (cxt, err) => Center(
                                                    child: Text(
                                                      'QR Error',
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    const SizedBox(height: 8),
                                    // Row(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.center,
                                    //   children: [
                                    //     Container(
                                    //       padding: const EdgeInsets.symmetric(
                                    //           horizontal: 12, vertical: 4),
                                    //       decoration: BoxDecoration(
                                    //         gradient: LinearGradient(colors: [
                                    //           Color(0xFF1E62B3).withOpacity(.5),
                                    //           kStrokeColor.withOpacity(.5)
                                    //         ]),
                                    //         borderRadius:
                                    //             BorderRadius.circular(10),
                                    //       ),
                                    //       child: Row(
                                    //         children: [
                                    //           SizedBox(
                                    //               height: 20,
                                    //               width: 20,
                                    //               child: Image.network(
                                    //                   user.hierarchy?.image ??
                                    //                       '')),
                                    //           const SizedBox(width: 6),
                                    //           Text(user.memberId ?? '',
                                    //               style: kSmallTitleB.copyWith(
                                    //                   color: kWhite)),
                                    //         ],
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: kWhite.withOpacity(0.07),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(24),
                            bottomRight: Radius.circular(24),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: kStrokeColor,
                                  backgroundImage: user.image != null &&
                                          user.image!.isNotEmpty
                                      ? NetworkImage(user.image!)
                                      : null,
                                  radius: 28,
                                  child: (user.image == null ||
                                          user.image!.isEmpty)
                                      ? Icon(Icons.person,
                                          size: 32, color: kGreyLight)
                                      : null,
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(user.name ?? '', style: kBodyTitleB),
                                    Text(
                                      user.profession ?? user.role ?? '',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Container(
                              padding:
                                  const EdgeInsets.all(1), // simulate border
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color.fromRGBO(
                                        30, 58, 129, 0.0), // transparent left
                                    Color.fromRGBO(
                                        30, 58, 129, 0.8), // opaque center
                                    Color.fromRGBO(
                                        30, 58, 129, 0.0), // transparent right
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.25),
                                    offset: Offset(0, 4),
                                    blurRadius: 10,
                                    spreadRadius: 0,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(Icons.email, color: kWhite, size: 18),
                                if (user.email != null && user.email != '')
                                  const SizedBox(width: 12),
                                if (user.email != null && user.email != '')
                                  Expanded(
                                    child: Text(
                                      user.email ?? '',
                                      style: TextStyle(
                                          color: kWhite, fontSize: 12),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(Icons.phone, color: kWhite, size: 18),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    user.phone ?? '',
                                    style:
                                        TextStyle(color: kWhite, fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                            if (user.location != null && user.location != '')
                              const SizedBox(height: 12),
                            if (user.location != null && user.location != '')
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.location_on,
                                      color: kWhite, size: 18),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      user.location ?? '',
                                      style: TextStyle(
                                          color: kWhite, fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  // Create an OverlayEntry to render the widget
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (_) => Material(
      color: Colors.transparent,
      child: Center(child: widgetToCapture),
    ),
  );

  // Add the widget to the overlay
  overlay.insert(overlayEntry);

  // Allow time for rendering
  await Future.delayed(const Duration(milliseconds: 500));

  // Capture the screenshot
  final boundary =
      boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
  if (boundary == null) {
    overlayEntry.remove(); // Clean up the overlay
    return;
  }

  // Convert to image
  final ui.Image image = await boundary.toImage(pixelRatio: 2.0);
  final ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
  overlayEntry.remove(); // Clean up the overlay

  if (byteData == null) return;

  final Uint8List pngBytes = byteData.buffer.asUint8List();

  // Save the image as a temporary file
  final tempDir = await getTemporaryDirectory();
  final file =
      await File('${tempDir.path}/screenshot.png').writeAsBytes(pngBytes);

  if (download) {
    // Save to gallery
    final result = await ImageGallerySaverPlus.saveFile(file.path);
    SnackbarService snackbarService = SnackbarService();
    snackbarService.showSnackBar(result['isSuccess'] == true
        ? 'QR saved to gallery!'
        : 'Failed to save QR.');
  } else {
    // Share
    Share.shareXFiles(
      [XFile(file.path)],
      text:
          'Check out my profile on IPA CONNECT!:\n https://admin.ipaconnect.org/user/${user.id}',
    );
  }
}
