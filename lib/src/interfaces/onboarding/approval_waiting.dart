import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/services/navigation_service.dart';
import 'package:ipaconnect/src/data/utils/secure_storage.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'dart:async';

import '../../data/constants/color_constants.dart';
import '../../data/notifiers/user_notifier.dart';

class ApprovalWaitingPage extends ConsumerStatefulWidget {
  const ApprovalWaitingPage({super.key});

  @override
  ConsumerState<ApprovalWaitingPage> createState() =>
      _ApprovalWaitingPageState();
}

class _ApprovalWaitingPageState extends ConsumerState<ApprovalWaitingPage> {
  Timer? _statusCheckTimer;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _startStatusCheck();
  }

  @override
  void dispose() {
    _statusCheckTimer?.cancel();
    super.dispose();
  }

  void _startStatusCheck() {
    // Check status every 30 seconds
    _statusCheckTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _checkUserStatus();
    });
  }

  Future<void> _checkUserStatus() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    try {
      // Refresh user data
      await ref.read(userProvider.notifier).refreshUser();

      // Get current user status
      final userAsync = ref.read(userProvider);

      userAsync.whenData((user) {
        if (user.status != 'pending') {
          // User status has changed, navigate to splash screen
          _statusCheckTimer?.cancel();

          NavigationService().pushNamedAndRemoveUntil('Splash');
        }
      });
    } catch (e) {
      // Handle error silently, continue checking
      print('Error checking user status: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
      }
    }
  }

  Future<void> _manualRefresh() async {
    await _checkUserStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Scaffold(
          appBar: AppBar(
            scrolledUnderElevation: 0,
            backgroundColor: kBackgroundColor,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
            actions: [
              IconButton(
                onPressed: _isRefreshing ? null : _manualRefresh,
                icon: _isRefreshing
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(kPrimaryColor),
                        ),
                      )
                    : Icon(Icons.refresh, color: kPrimaryColor),
              ),
            ],
          ),
          backgroundColor: kBackgroundColor,
          body: RefreshIndicator(
            backgroundColor: kCardBackgroundColor,
            onRefresh: _manualRefresh,
            color: kPrimaryColor,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Container(
                height: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    kToolbarHeight,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 130,
                        height: 130,
                        child: LoadingIndicator(
                          indicatorType: Indicator.ballRotateChase,
                          colors: [kPrimaryColor],
                          strokeWidth: 2,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Your request to join has been sent',
                        textAlign: TextAlign.center,
                        style: kHeadTitleB,
                      ),
                      const SizedBox(height: 12),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          'Access to the app will be made available to you soon! Thank you for your patience.',
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(fontSize: 15, color: Color(0xFFAEB9E1)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (_isRefreshing) ...[
                        const SizedBox(height: 16),
                        Text(
                          'Checking approval status...',
                          style: TextStyle(
                            fontSize: 14,
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      TextButton.icon(
                        onPressed: () {
                          _statusCheckTimer?.cancel();

                          NavigationService()
                              .pushNamedReplacement('PhoneNumber');
                        },
                        icon: Icon(Icons.logout, color: kPrimaryColor),
                        label: Text(
                          'Logout',
                          style: kSmallTitleB.copyWith(color: kPrimaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
