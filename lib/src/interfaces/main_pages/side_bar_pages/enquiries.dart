import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/models/enquiry_model.dart';
import 'package:ipaconnect/src/data/notifiers/enquiry_notifier.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_round_button.dart';
import 'package:ipaconnect/src/interfaces/components/loading/loading_indicator.dart';
import 'package:ipaconnect/src/interfaces/components/animations/staggered_entrance.dart';

class EnquiriesPage extends ConsumerStatefulWidget {
  const EnquiriesPage({Key? key}) : super(key: key);

  @override
  ConsumerState<EnquiriesPage> createState() => _EnquiriesPageState();
}

class _EnquiriesPageState extends ConsumerState<EnquiriesPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchInitialEnquiries();
  }

  Future<void> _fetchInitialEnquiries() async {
    await ref.read(enquiryNotifierProvider.notifier).fetchMoreEnquiries();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(enquiryNotifierProvider.notifier).fetchMoreEnquiries();
    }
  }

  @override
  Widget build(BuildContext context) {
    final enquiries = ref.watch(enquiryNotifierProvider);
    final isLoading = ref.read(enquiryNotifierProvider.notifier).isLoading;
    final isFirstLoad = ref.read(enquiryNotifierProvider.notifier).isFirstLoad;

    return RefreshIndicator(
      backgroundColor: kPrimaryColor,
      color: kCardBackgroundColor,
      onRefresh: () =>
          ref.read(enquiryNotifierProvider.notifier).refreshEnquiries(),
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          backgroundColor: kBackgroundColor,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(8),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: CustomRoundButton(
                offset: Offset(4, 0),
                iconPath: 'assets/svg/icons/arrow_back_ios.svg',
              ),
            ),
          ),
          title: Text('Enquiries',
              style: kBodyTitleR.copyWith(
                  fontSize: 16, color: kSecondaryTextColor)),
          centerTitle: false,
        ),
        body: isFirstLoad
            ? Center(child: LoadingAnimation())
            : enquiries.isEmpty
                ? Center(child: Text('No Enquiries', style: kBodyTitleB))
                : StartupStagger(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16.0),
                      itemCount: enquiries.length + 1,
                      itemBuilder: (context, index) {
                        if (index == enquiries.length) {
                          return isLoading
                              ? Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Center(child: LoadingAnimation()),
                                )
                              : const SizedBox.shrink();
                        }
                        final enquiry = enquiries[index];
                        return StaggerItem(
                          order: 1 + (index % 8),
                          from: SlideFrom.bottom,
                          child: Card(
                            color: kCardBackgroundColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            margin: const EdgeInsets.only(bottom: 16),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.person, color: kPrimaryColor),
                                      const SizedBox(width: 8),
                                      Text(enquiry.name ?? '-', style: kBodyTitleB),
                                      const Spacer(),
                                      Text(
                                        enquiry.createdAt != null
                                            ? '${enquiry.createdAt!.day}/${enquiry.createdAt!.month}/${enquiry.createdAt!.year}'
                                            : '',
                                        style: kSmallTitleL.copyWith(
                                            color: kSecondaryTextColor),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(Icons.email,
                                          color: kSecondaryTextColor, size: 18),
                                      const SizedBox(width: 6),
                                      Text(enquiry.email ?? '-',
                                          style: kSmallTitleL),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.phone,
                                          color: kSecondaryTextColor, size: 18),
                                      const SizedBox(width: 6),
                                      Text(enquiry.phone ?? '-',
                                          style: kSmallTitleL),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text('Message:', style: kSmallTitleB),
                                  Text(enquiry.message ?? '-', style: kSmallTitleL),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
      ),
    );
  }
}
