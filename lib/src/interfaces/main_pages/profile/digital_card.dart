import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/models/user_model.dart';
import 'package:ipaconnect/src/data/utils/launch_url.dart';
import 'package:ipaconnect/src/data/utils/share_qr.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_round_button.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:qr_flutter/qr_flutter.dart';

class DigitalCardPage extends StatelessWidget {
  final UserModel user;
  const DigitalCardPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF030920),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: CustomRoundButton(
              offset: Offset(4, 0),
              iconPath: 'assets/svg/icons/arrow_back_ios.svg',
            ),
          ),
        ),
        title: Text('Digital Card',
            style:
                kBodyTitleR.copyWith(fontSize: 16, color: kSecondaryTextColor)),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFF030920),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                              height: 350,
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
                                      GestureDetector(
                                        onTap: () =>
                                            captureAndShareOrDownloadWidgetScreenshot(
                                          context,
                                          user: user,
                                        ),
                                        child: Row(
                                          children: [
                                            Transform.rotate(
                                              angle:
                                                  -30 * 3.141592653589793 / 180,
                                              child: Icon(Icons.send,
                                                  color: kWhite, size: 20),
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              'Send Card',
                                              style: TextStyle(
                                                  color: kWhite, fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  InkWell(
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
                                                qrBytes,
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
                                                errorStateBuilder: (cxt, err) =>
                                                    Center(
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
                                  Center(
                                    child: Text(
                                      'Scan or click to preview',
                                      style: TextStyle(
                                          color: kWhite, fontSize: 14),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 4),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(colors: [
                                            Color(0xFF1E62B3).withOpacity(.5),
                                            kStrokeColor.withOpacity(.5)
                                          ]),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                                height: 20,
                                                width: 20,
                                                child: Image.network(
                                                    user.hierarchy?.image ??
                                                        '')),
                                            const SizedBox(width: 6),
                                            Text(user.memberId ?? '',
                                                style: kSmallTitleB.copyWith(
                                                    color: kWhite)),
                                          ],
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
                                backgroundImage:
                                    user.image != null && user.image!.isNotEmpty
                                        ? NetworkImage(user.image!)
                                        : null,
                                radius: 28,
                                child:
                                    (user.image == null || user.image!.isEmpty)
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
                            padding: const EdgeInsets.all(1), // simulate border
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
                                    style:
                                        TextStyle(color: kWhite, fontSize: 12),
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
                                  style: TextStyle(color: kWhite, fontSize: 12),
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
                                    style:
                                        TextStyle(color: kWhite, fontSize: 12),
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
    );
  }
}
