// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events_api_service.dart';

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
String _$eventsHash() => r'4a8778ce6921ef445d97c5300a8088960d964ffa';

/// See also [events].
@ProviderFor(events)
final eventsProvider = AutoDisposeFutureProvider<List<EventsModel>>.internal(
  events,
  name: r'eventsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$eventsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EventsRef = AutoDisposeFutureProviderRef<List<EventsModel>>;
String _$eventByIdHash() => r'14f08102162c38c15253bafee96aaf5d47d9ad09';

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

/// See also [eventById].
@ProviderFor(eventById)
const eventByIdProvider = EventByIdFamily();

/// See also [eventById].
class EventByIdFamily extends Family<AsyncValue<EventsModel?>> {
  /// See also [eventById].
  const EventByIdFamily();

  /// See also [eventById].
  EventByIdProvider call(
    String id,
  ) {
    return EventByIdProvider(
      id,
    );
  }

  @override
  EventByIdProvider getProviderOverride(
    covariant EventByIdProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'eventByIdProvider';
}

/// See also [eventById].
class EventByIdProvider extends AutoDisposeFutureProvider<EventsModel?> {
  /// See also [eventById].
  EventByIdProvider(
    String id,
  ) : this._internal(
          (ref) => eventById(
            ref as EventByIdRef,
            id,
          ),
          from: eventByIdProvider,
          name: r'eventByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$eventByIdHash,
          dependencies: EventByIdFamily._dependencies,
          allTransitiveDependencies: EventByIdFamily._allTransitiveDependencies,
          id: id,
        );

  EventByIdProvider._internal(
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
    FutureOr<EventsModel?> Function(EventByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: EventByIdProvider._internal(
        (ref) => create(ref as EventByIdRef),
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
  AutoDisposeFutureProviderElement<EventsModel?> createElement() {
    return _EventByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EventByIdProvider && other.id == id;
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
mixin EventByIdRef on AutoDisposeFutureProviderRef<EventsModel?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _EventByIdProviderElement
    extends AutoDisposeFutureProviderElement<EventsModel?> with EventByIdRef {
  _EventByIdProviderElement(super.provider);

  @override
  String get id => (origin as EventByIdProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
