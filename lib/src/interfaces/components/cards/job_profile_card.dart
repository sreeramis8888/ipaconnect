import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/models/job_profile_model.dart';
import 'package:ipaconnect/src/data/services/snackbar_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';

class JobProfileCard extends StatelessWidget {
  final JobProfileModel profile;

  const JobProfileCard({super.key, required this.profile});
  Future<void> _downloadResume(BuildContext context) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final savePath = "${dir.path}/${profile.name}_resume.pdf";

      final dio = Dio();
      await dio.download(profile.resume!, savePath);

      final result = await OpenFile.open(savePath);
      debugPrint("OpenFile result: ${result.message}");
    } catch (e) {
      SnackbarService snackbarService = SnackbarService();
      snackbarService.showSnackBar('Failed to Download',
          type: SnackbarType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kCardBackgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Name + Updated Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(profile.name ?? '-', style: kBodyTitleB),
              Text(
                profile.updatedAt != null
                    ? 'Resume Updated On: '
                        '${profile.updatedAt!.day.toString().padLeft(2, '0')}/'
                        '${profile.updatedAt!.month.toString().padLeft(2, '0')}/'
                        '${profile.updatedAt!.year}'
                    : '',
                style: kBodyTitleR.copyWith(
                  color: kSecondaryTextColor,
                  fontSize: 10,
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),
          Text(profile.designation ?? '-',
              style: kBodyTitleR.copyWith(color: kSecondaryTextColor)),

          const SizedBox(height: 12),
          if (profile.experience != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: kBlue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(profile.experience!,
                  style: kBodyTitleSB.copyWith(color: kWhite, fontSize: 12)),
            ),

          const SizedBox(height: 12),
          if (profile.noticePeriod != null)
            Text(profile.noticePeriod ?? '',
                style: kSmallTitleM.copyWith(color: kSecondaryTextColor)),

          const SizedBox(height: 8),
          if (profile.email != null)
            Row(children: [
              const Icon(Icons.email, color: kWhite, size: 16),
              const SizedBox(width: 8),
              Text(profile.email!,
                  style: TextStyle(
                    color: kWhite,
                  )),
            ]),

          if (profile.phone != null)
            Row(children: [
              const Icon(Icons.phone, color: kWhite, size: 16),
              const SizedBox(width: 8),
              Text(profile.phone!,
                  style: TextStyle(
                    color: kWhite,
                  )),
            ]),

          if (profile.location != null)
            Row(children: [
              const Icon(Icons.location_on, color: kWhite, size: 16),
              const SizedBox(width: 8),
              Text(profile.location!,
                  style: TextStyle(
                    color: kWhite,
                  )),
            ]),

          const SizedBox(height: 16),
          Text('Resume',
              style: kBodyTitleR.copyWith(
                  color: kSecondaryTextColor, fontSize: 10)),
          const SizedBox(height: 8),

          Row(
            children: [
              Icon(
                FontAwesomeIcons.filePdf,
                color: kRed,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text('CV.pdf',
                    overflow: TextOverflow.ellipsis,
                    style: kBodyTitleSB.copyWith(fontSize: 15)),
              ),
              IconButton(
                icon:
                    const Icon(Icons.download_rounded, color: kWhite, size: 28),
                onPressed: () => _downloadResume(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
