import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/models/events_model.dart';
import 'package:ipaconnect/src/data/notifiers/events_notifier.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/services/navigation_service.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_round_button.dart';
import 'package:ipaconnect/src/interfaces/components/custom_widgets/custom_event_widget.dart';
import 'package:ipaconnect/src/interfaces/components/loading/loading_indicator.dart';

class EventsPage extends ConsumerStatefulWidget {
  const EventsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends ConsumerState<EventsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchInitialEvents();
  }

  Future<void> _fetchInitialEvents() async {
    await ref.read(eventsNotifierProvider.notifier).fetchMoreEVents();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(eventsNotifierProvider.notifier).fetchMoreEVents();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final events = ref.watch(eventsNotifierProvider);
    final notifier = ref.read(eventsNotifierProvider.notifier);
    final isLoading = notifier.isLoading;
    final isFirstLoad = notifier.isFirstLoad;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Events',
          style: kSmallTitleR,
        ),
        backgroundColor: kBackgroundColor,
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
      ),
      backgroundColor: kBackgroundColor,
      body: isFirstLoad
          ? const Center(child: LoadingAnimation())
          : RefreshIndicator(
              onRefresh: () =>
                  ref.read(eventsNotifierProvider.notifier).refreshEvents(),
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16.0),
                itemCount: events.length + 1,
                itemBuilder: (context, index) {
                  if (index == events.length) {
                    return isLoading
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Center(child: LoadingAnimation()),
                          )
                        : const SizedBox.shrink();
                  }
                  final event = events[index];
                  return _buildEventCard(event);
                },
              ),
            ),
    );
  }

  Widget _buildEventCard(EventsModel event) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: GestureDetector(
        onTap: () {
          NavigationService navigationService = NavigationService();
          navigationService.pushNamed('EventDetails', arguments: event);
        },
        child: eventWidget(
          context: context,
          event: event,
        ),
      ),
    );
  }
}
