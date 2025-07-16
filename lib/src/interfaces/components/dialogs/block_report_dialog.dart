import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/notifiers/user_notifier.dart';
import 'package:ipaconnect/src/data/services/api_routes/user_api/user_data/user_data_api.dart';
import 'package:ipaconnect/src/interfaces/components/loading/loading_indicator.dart';

class ReportPersonDialog extends StatelessWidget {
  final String? userId;
  final VoidCallback onReportStatusChanged;
  final String reportType;
  final String reportedItemId;

  ReportPersonDialog({
    this.userId,
    required this.onReportStatusChanged,
    super.key,
    required this.reportType,
    required this.reportedItemId,
  });

  TextEditingController reasonController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 12,
      backgroundColor: kCardBackgroundColor,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Are you sure you want to report this ?',
                textAlign: TextAlign.center, style: kBodyTitleB),
            const SizedBox(height: 30.0),
            TextFormField(
              controller: reasonController,
              decoration: InputDecoration(
                labelText: 'Content',
                labelStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: kStrokeColor,
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: kStrokeColor,
                    width: 2.0,
                  ),
                ),
                filled: true,
                fillColor: kStrokeColor,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
              ),
              style: kBodyTitleB,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Reason is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 20.0),
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Consumer(
          builder: (context, ref, child) {
            return ElevatedButton(
              onPressed: () async {
                final userDataApiService =
                    ref.watch(userDataApiServiceProvider);
                userDataApiService.createReport(
                    reason: reasonController.text,
                    reportedItemId: reportedItemId,
                    reportType: reportType);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 14.0),
                shadowColor: kPrimaryColor,
                elevation: 6,
              ),
              child: Text(
                'Report',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

void showReportPersonDialog({
  required BuildContext context,
  String? userId,
  required VoidCallback onReportStatusChanged,
  required String reportType,
  required String reportedItemId,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ReportPersonDialog(
        reportType: reportType,
        userId: userId,
        onReportStatusChanged: onReportStatusChanged,
        reportedItemId: reportedItemId,
      );
    },
  );
}

// Function to show the BlockPersonDialog
void showBlockPersonDialog({
  required BuildContext context,
  required String userId,
  required VoidCallback onBlockStatusChanged,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return BlockPersonDialog(
        userId: userId,
        onBlockStatusChanged: onBlockStatusChanged,
      );
    },
  );
}

class BlockPersonDialog extends ConsumerStatefulWidget {
  final String userId;
  final VoidCallback onBlockStatusChanged;

  BlockPersonDialog({
    required this.userId,
    required this.onBlockStatusChanged,
    super.key,
  });

  @override
  _BlockPersonDialogState createState() => _BlockPersonDialogState();
}

class _BlockPersonDialogState extends ConsumerState<BlockPersonDialog> {
  late TextEditingController reasonController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    reasonController = TextEditingController();
  }

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncUser = ref.watch(userProvider);

    // Determine block status dynamically
    return asyncUser.when(
        loading: () => const LoadingAnimation(),
        error: (error, stackTrace) {
          return const Center(
            child: LoadingAnimation(),
          );
        },
        data: (user) {
          bool isBlocked = user.blockedUsers
                  ?.any((blockedUser) => blockedUser == widget.userId) ??
              false;
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            elevation: 12,
            backgroundColor: Colors.white,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (asyncUser.isLoading)
                    LoadingAnimation()
                  else
                    Column(
                      children: [
                        Text(
                          isBlocked
                              ? 'Are you sure you want to unblock this person?'
                              : 'Are you sure you want to block this person?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.blueGrey[900],
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        if (!isBlocked)
                          Form(
                            key: _formKey,
                            child: TextFormField(
                              controller: reasonController,
                              decoration: InputDecoration(
                                labelText: 'Reason',
                                labelStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 1.5,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color: kPrimaryColor,
                                    width: 2.0,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 20.0),
                              ),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Reason is required';
                                }
                                return null;
                              },
                            ),
                          ),
                        const SizedBox(height: 20.0),
                        _buildActions(context, isBlocked),
                      ],
                    ),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildActions(BuildContext context, bool isBlocked) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: () async {
            // Show loading dialog
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return Center(child: LoadingAnimation());
              },
            );

            try {
              await _toggleBlockStatus(context, isBlocked);
              ref.read(userProvider.notifier).refreshUser();
            } finally {
              // Hide loading dialog
              Navigator.of(context).pop(); // Close the loading dialog
            }

            // Close the current dialog
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 14.0),
            shadowColor: kPrimaryColor,
            elevation: 6,
          ),
          child: Text(
            isBlocked ? 'Unblock' : 'Block',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _toggleBlockStatus(BuildContext context, bool isBlocked) async {
    final userDataApiService = ref.watch(userDataApiServiceProvider);
    if (isBlocked) {
      await userDataApiService.unBlockUser(
        widget.userId,
      );
    } else {
      await userDataApiService.blockUser(
        widget.userId,
        reasonController.text,
        ref,
      );
    }
    widget.onBlockStatusChanged();
  }
}
