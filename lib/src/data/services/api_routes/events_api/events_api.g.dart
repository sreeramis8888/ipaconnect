// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$eventsApiServiceHash() => r'efab456a736c58e66de91a40956a22c7e61ab0c6';

/// See also [eventsApiService].
@ProviderFor(eventsApiService)
final eventsApiServiceProvider = AutoDisposeProvider<EventsApiService>.internal(
  eventsApiService,
  name: r'eventsApiServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$eventsApiServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EventsApiServiceRef = AutoDisposeProviderRef<EventsApiService>;
String _$fetchEventsHash() => r'88031911777f2fd1d093417df5f49dcf1102ef07';

/// See also [fetchEvents].
@ProviderFor(fetchEvents)
final fetchEventsProvider =
    AutoDisposeFutureProvider<List<EventsModel>>.internal(
  fetchEvents,
  name: r'fetchEventsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$fetchEventsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FetchEventsRef = AutoDisposeFutureProviderRef<List<EventsModel>>;
String _$fetchEventByIdHash() => r'903429b7627413c046f6d9529b9b5c156e19788a';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [fetchEventById].
@ProviderFor(fetchEventById)
const fetchEventByIdProvider = FetchEventByIdFamily();

/// See also [fetchEventById].
class FetchEventByIdFamily extends Family<AsyncValue<EventsModel>> {
  /// See also [fetchEventById].
  const FetchEventByIdFamily();

  /// See also [fetchEventById].
  FetchEventByIdProvider call({
    required String id,
  }) {
    return FetchEventByIdProvider(
      id: id,
    );
  }

  @override
  FetchEventByIdProvider getProviderOverride(
    covariant FetchEventByIdProvider provider,
  ) {
    return call(
      id: provider.id,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'fetchEventByIdProvider';
}

/// See also [fetchEventById].
class FetchEventByIdProvider extends AutoDisposeFutureProvider<EventsModel> {
  /// See also [fetchEventById].
  FetchEventByIdProvider({
    required String id,
  }) : this._internal(
          (ref) => fetchEventById(
            ref as FetchEventByIdRef,
            id: id,
          ),
          from: fetchEventByIdProvider,
          name: r'fetchEventByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchEventByIdHash,
          dependencies: FetchEventByIdFamily._dependencies,
          allTransitiveDependencies:
              FetchEventByIdFamily._allTransitiveDependencies,
          id: id,
        );

  FetchEventByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<EventsModel> Function(FetchEventByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchEventByIdProvider._internal(
        (ref) => create(ref as FetchEventByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<EventsModel> createElement() {
    return _FetchEventByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchEventByIdProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchEventByIdRef on AutoDisposeFutureProviderRef<EventsModel> {
  /// The parameter `id` of this provider.
  String get id;
}

class _FetchEventByIdProviderElement
    extends AutoDisposeFutureProviderElement<EventsModel>
    with FetchEventByIdRef {
  _FetchEventByIdProviderElement(super.provider);

  @override
  String get id => (origin as FetchEventByIdProvider).id;
}

String _$fetchEventAttendanceHash() =>
    r'66831d0462461a8e17b11ca6278304da25d8260d';

/// See also [fetchEventAttendance].
@ProviderFor(fetchEventAttendance)
const fetchEventAttendanceProvider = FetchEventAttendanceFamily();

/// See also [fetchEventAttendance].
class FetchEventAttendanceFamily
    extends Family<AsyncValue<AttendanceUserListModel>> {
  /// See also [fetchEventAttendance].
  const FetchEventAttendanceFamily();

  /// See also [fetchEventAttendance].
  FetchEventAttendanceProvider call({
    required String eventId,
  }) {
    return FetchEventAttendanceProvider(
      eventId: eventId,
    );
  }

  @override
  FetchEventAttendanceProvider getProviderOverride(
    covariant FetchEventAttendanceProvider provider,
  ) {
    return call(
      eventId: provider.eventId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'fetchEventAttendanceProvider';
}

/// See also [fetchEventAttendance].
class FetchEventAttendanceProvider
    extends AutoDisposeFutureProvider<AttendanceUserListModel> {
  /// See also [fetchEventAttendance].
  FetchEventAttendanceProvider({
    required String eventId,
  }) : this._internal(
          (ref) => fetchEventAttendance(
            ref as FetchEventAttendanceRef,
            eventId: eventId,
          ),
          from: fetchEventAttendanceProvider,
          name: r'fetchEventAttendanceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchEventAttendanceHash,
          dependencies: FetchEventAttendanceFamily._dependencies,
          allTransitiveDependencies:
              FetchEventAttendanceFamily._allTransitiveDependencies,
          eventId: eventId,
        );

  FetchEventAttendanceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.eventId,
  }) : super.internal();

  final String eventId;

  @override
  Override overrideWith(
    FutureOr<AttendanceUserListModel> Function(FetchEventAttendanceRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchEventAttendanceProvider._internal(
        (ref) => create(ref as FetchEventAttendanceRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        eventId: eventId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<AttendanceUserListModel> createElement() {
    return _FetchEventAttendanceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchEventAttendanceProvider && other.eventId == eventId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, eventId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchEventAttendanceRef
    on AutoDisposeFutureProviderRef<AttendanceUserListModel> {
  /// The parameter `eventId` of this provider.
  String get eventId;
}

class _FetchEventAttendanceProviderElement
    extends AutoDisposeFutureProviderElement<AttendanceUserListModel>
    with FetchEventAttendanceRef {
  _FetchEventAttendanceProviderElement(super.provider);

  @override
  String get eventId => (origin as FetchEventAttendanceProvider).eventId;
}

String _$fetchMyEventsHash() => r'c2b8c1066e73c61a75e9ebcde14f9c9249d957ca';

/// See also [fetchMyEvents].
@ProviderFor(fetchMyEvents)
final fetchMyEventsProvider =
    AutoDisposeFutureProvider<List<EventsModel>>.internal(
  fetchMyEvents,
  name: r'fetchMyEventsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fetchMyEventsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FetchMyEventsRef = AutoDisposeFutureProviderRef<List<EventsModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
