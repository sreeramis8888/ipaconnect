import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart'
    show DropdownButton2, DropdownStyleData, MenuItemStyleData;
import 'package:flutter/material.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/models/user_model.dart';
import 'package:ipaconnect/src/data/services/snackbar_service.dart';
import 'package:ipaconnect/src/data/utils/launch_url.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class DocumentCard extends StatelessWidget {
  final SubData brochure;
  final VoidCallback? onRemove;
  final VoidCallback? onEdit;

  const DocumentCard({
    super.key,
    required this.brochure,
    this.onRemove,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: kCardBackgroundColor,
          borderRadius: BorderRadius.circular(5),
        ),
        width: double.infinity,
        child: ListTile(
          leading: Icon(
            Icons.picture_as_pdf,
            color: Colors.red,
          ),
          title: Text(
            brochure.name ?? '',
            style: kSmallTitleL,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  Icons.download,
                  color: kWhite,
                ),
                onPressed: () async {
                  try {
                    final dir = await getApplicationDocumentsDirectory();
                    final savePath = "${dir.path}/${brochure.name}.pdf";

                    final dio = Dio();
                    await dio.download(brochure.link!, savePath);

                    final result = await OpenFile.open(savePath);
                    debugPrint("OpenFile result: ${result.message}");
                  } catch (e) {
                    SnackbarService snackbarService = SnackbarService();
                    snackbarService.showSnackBar('Failed to Download',
                        type: SnackbarType.error);
                  }
                },
              ),
              if (onRemove != null)
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: kWhite,
                  ),
                  onPressed: onRemove,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
