import 'package:flutter/material.dart';
import 'package:ipaconnect/src/data/notifiers/rating_notifier.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_button.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';

class AddReviewModal extends StatefulWidget {
  final String entityId;
  final String entityType;
  final RatingNotifier notifier;
  final String? userId;
  final String? userName;
  final VoidCallback? onSubmitted;

  const AddReviewModal({
    super.key,
    required this.entityId,
    required this.entityType,
    required this.notifier,
    this.userId,
    this.userName,
    this.onSubmitted,
  });

  @override
  State<AddReviewModal> createState() => _AddReviewModalState();
}

class _AddReviewModalState extends State<AddReviewModal> {
  final _formKey = GlobalKey<FormState>();
  int _rating = 0;
  String _review = '';
  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 10),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
                child: Container(
                    width: 80,
                    height: 4,
                    decoration: BoxDecoration(
                        color: kGreyDark,
                        borderRadius: BorderRadius.circular(2)))),
            SizedBox(height: 16),
            Center(child: Text('Add Review', style: kBodyTitleB)),
            SizedBox(height: 18),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                    5,
                    (i) => IconButton(
                          icon: Icon(
                            i < _rating
                                ? Icons.star_rounded
                                : Icons.star_border_rounded,
                            color: Colors.amber,
                            size: 28,
                          ),
                          splashRadius: 20,
                          onPressed: () {
                            setState(() {
                              _rating = i + 1;
                            });
                          },
                        )),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Write your review',
                labelStyle: kBodyTitleR.copyWith(color: kSecondaryTextColor),
                filled: true,
                fillColor: kBackgroundColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: kPrimaryColor.withOpacity(0.2)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: kPrimaryColor.withOpacity(0.2)),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              ),
              maxLines: 3,
              style: kBodyTitleR.copyWith(color: kWhite),
              onChanged: (val) => _review = val,
              validator: (val) =>
                  val == null || val.isEmpty ? 'Enter review' : null,
            ),
            SizedBox(height: 18),
            customButton(
              label: _submitting ? 'Submitting...' : 'Submit',
              onPressed: _submitting
                  ? null
                  : () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() => _submitting = true);
                        await widget.notifier.addRating(
                          userId: widget.userId ?? 'userId',
                          userName: widget.userName ?? 'User',
                          targetId: widget.entityId,
                          targetType: widget.entityType,
                          rating: _rating,
                          review: _review,
                        );
                        if (context.mounted) Navigator.pop(context);
                        await widget.notifier.refreshRatings(
                            entityId: widget.entityId,
                            entityType: widget.entityType);
                        if (widget.onSubmitted != null) widget.onSubmitted!();

                        setState(() => _submitting = false);
                      }
                    },
              buttonColor: kPrimaryColor,
              labelColor: kWhite,
              fontSize: 16,
              buttonHeight: 44,
            ),
            SizedBox(height: 18),
          ],
        ),
      ),
    );
  }
}
