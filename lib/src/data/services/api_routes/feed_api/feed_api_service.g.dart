// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_api_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$feedApiServiceHash() => r'81640f5923e7f14ba09ca00b5f717a72ab0e7e5f';

/// See also [feedApiService].
@ProviderFor(feedApiService)
final feedApiServiceProvider = AutoDisposeProvider<FeedApiService>.internal(
  feedApiService,
  name: r'feedApiServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$feedApiServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FeedApiServiceRef = AutoDisposeProviderRef<FeedApiService>;
String _$getFeedsHash() => r'90f53441cf85f6deb850399ef57f29dd18675703';

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

/// See also [getFeeds].
@ProviderFor(getFeeds)
const getFeedsProvider = GetFeedsFamily();

/// See also [getFeeds].
class GetFeedsFamily extends Family<AsyncValue<List<FeedModel>>> {
  /// See also [getFeeds].
  const GetFeedsFamily();

  /// See also [getFeeds].
  GetFeedsProvider call({
    int pageNo = 1,
    int limit = 10,
  }) {
    return GetFeedsProvider(
      pageNo: pageNo,
      limit: limit,
    );
  }

  @override
  GetFeedsProvider getProviderOverride(
    covariant GetFeedsProvider provider,
  ) {
    return call(
      pageNo: provider.pageNo,
      limit: provider.limit,
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
  String? get name => r'getFeedsProvider';
}

/// See also [getFeeds].
class GetFeedsProvider extends AutoDisposeFutureProvider<List<FeedModel>> {
  /// See also [getFeeds].
  GetFeedsProvider({
    int pageNo = 1,
    int limit = 10,
  }) : this._internal(
          (ref) => getFeeds(
            ref as GetFeedsRef,
            pageNo: pageNo,
            limit: limit,
          ),
          from: getFeedsProvider,
          name: r'getFeedsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getFeedsHash,
          dependencies: GetFeedsFamily._dependencies,
          allTransitiveDependencies: GetFeedsFamily._allTransitiveDependencies,
          pageNo: pageNo,
          limit: limit,
        );

  GetFeedsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.pageNo,
    required this.limit,
  }) : super.internal();

  final int pageNo;
  final int limit;

  @override
  Override overrideWith(
    FutureOr<List<FeedModel>> Function(GetFeedsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetFeedsProvider._internal(
        (ref) => create(ref as GetFeedsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        pageNo: pageNo,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<FeedModel>> createElement() {
    return _GetFeedsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetFeedsProvider &&
        other.pageNo == pageNo &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pageNo.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetFeedsRef on AutoDisposeFutureProviderRef<List<FeedModel>> {
  /// The parameter `pageNo` of this provider.
  int get pageNo;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _GetFeedsProviderElement
    extends AutoDisposeFutureProviderElement<List<FeedModel>> with GetFeedsRef {
  _GetFeedsProviderElement(super.provider);

  @override
  int get pageNo => (origin as GetFeedsProvider).pageNo;
  @override
  int get limit => (origin as GetFeedsProvider).limit;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
