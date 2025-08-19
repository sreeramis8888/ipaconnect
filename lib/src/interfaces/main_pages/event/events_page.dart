import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/notifiers/events_notifier.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/services/api_routes/events_api/events_api.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_round_button.dart';
import 'package:ipaconnect/src/interfaces/components/custom_widgets/custom_event_widget.dart';
import 'package:ipaconnect/src/interfaces/components/loading/loading_indicator.dart';
import 'package:ipaconnect/src/interfaces/main_pages/event/add_event.dart';

class EventsPage extends ConsumerStatefulWidget {
  final int initialTabIndex;

  const EventsPage({Key? key, this.initialTabIndex = 0}) : super(key: key);

  @override
  ConsumerState<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends ConsumerState<EventsPage>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    final int safeInitialIndex = (widget.initialTabIndex >= 0 &&
            widget.initialTabIndex <= 2)
        ? widget.initialTabIndex
        : 0;
    _tabController =
        TabController(length: 3, vsync: this, initialIndex: safeInitialIndex);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
    _scrollController.addListener(_onScroll);
    _fetchInitialEvents();
  }

  Future<void> _fetchInitialEvents() async {
    await ref.read(eventsNotifierProvider.notifier).fetchMoreEVents();
  }

  void _onScroll() {
    if (_tabController.index == 0 &&
        _scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
      ref.read(eventsNotifierProvider.notifier).fetchMoreEVents();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Events',
          style: kSmallTitleL,
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
        bottom: TabBar(
          indicatorColor: kPrimaryColor,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorWeight: 3,
          labelColor: kPrimaryColor,
          dividerColor: kBackgroundColor,
          unselectedLabelColor: kSecondaryTextColor,
          labelStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          controller: _tabController,
          tabs: const [
            Tab(text: 'All Events'),
            Tab(text: 'My Events'),
            Tab(text: 'Registered'),
          ],
        ),
      ),
      backgroundColor: kBackgroundColor,
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAllEventsTab(),
          _buildMyEventsTab(),
          _buildRegisteredEventsTab(),
        ],
      ),
      floatingActionButton:
          (_tabController.index == 0 || _tabController.index == 1)
              ? FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddEventPage()),
                    );
                  },
                  backgroundColor: kPrimaryColor,
                  child: Icon(Icons.add, color: kWhite),
                )
              : null,
    );
  }

  Widget _buildAllEventsTab() {
    final events = ref.watch(eventsNotifierProvider);
    final notifier = ref.read(eventsNotifierProvider.notifier);
    final isLoading = notifier.isLoading;
    final isFirstLoad = notifier.isFirstLoad;
    return isFirstLoad
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
                return eventWidget(context: context, event: event);
              },
            ),
          );
  }

  Widget _buildMyEventsTab() {
    final asyncMyCreatedEvents = ref.watch(fetchMyCreatedEventsProvider);
    return asyncMyCreatedEvents.when(
      data: (myEvents) {
        if (myEvents.isEmpty) {
          return Center(
              child: Text('No events created by you', style: kBodyTitleB));
        }
        return RefreshIndicator(
          onRefresh: () async {
            await ref
                .read(eventsNotifierProvider.notifier)
                .fetchMyCreatedEvents();
            ref.invalidate(fetchMyCreatedEventsProvider);
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: myEvents.length,
            itemBuilder: (context, index) {
              final event = myEvents[index];
              return eventWidget(context: context, event: event);
            },
          ),
        );
      },
      loading: () => const Center(child: LoadingAnimation()),
      error: (error, stackTrace) =>
          Center(child: Text('Failed to load', style: kBodyTitleB)),
    );
  }

  Widget _buildRegisteredEventsTab() {
    final asyncRegisteredEvents = ref.watch(fetchMyEventsProvider);
    return asyncRegisteredEvents.when(
      data: (registeredEvents) {
        if (registeredEvents.isEmpty) {
          return Center(
              child: Text('No events registered', style: kBodyTitleB));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: registeredEvents.length,
          itemBuilder: (context, index) {
            final event = registeredEvents[index];
            return eventWidget(context: context, event: event);
          },
        );
      },
      loading: () => const Center(child: LoadingAnimation()),
      error: (error, stackTrace) =>
          Center(child: Text('Failed to load', style: kBodyTitleB)),
    );
  }
}
