import 'package:flutter/material.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/models/user_model.dart';
import 'package:ipaconnect/src/interfaces/components/dialogs/image_details_dialog.dart';
import 'package:ipaconnect/src/interfaces/components/dropdown/remove_edit_dropdown.dart';

class CertificateCard extends StatelessWidget {
  final VoidCallback? onRemove;
  final VoidCallback? onEdit;
  final SubData certificate;

  const CertificateCard({
    required this.onRemove,
    required this.certificate,
    required this.onEdit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showImageDetails(
          context: context,
          imageUrl: certificate.link ?? '',
          title: certificate.name ?? '',
        );
      },
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.only(
          bottom: 16,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: kStrokeColor),
          ),
          height: 220.0,
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 160.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5)),
                  image: DecorationImage(
                    image: NetworkImage(certificate.link!),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(5),
                          bottomRight: Radius.circular(5)),
                      color: kCardBackgroundColor),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child:
                              Text(certificate.name ?? '', style: kBodyTitleR),
                        ),
                        if (onRemove != null)
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: kStrokeColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: RemoveEditDropdown(
                                onRemove: onRemove!,
                                onEdit: onEdit!,
                              ),
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
  }
}
