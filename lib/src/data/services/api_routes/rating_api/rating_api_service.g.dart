// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating_api_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$ratingApiServiceHash() => r'384ac94b5e0519798c1c7b8f0e10367ebadd50c2';

/// See also [ratingApiService].
@ProviderFor(ratingApiService)
final ratingApiServiceProvider = AutoDisposeProvider<RatingApiService>.internal(
  ratingApiService,
  name: r'ratingApiServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$ratingApiServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RatingApiServiceRef = AutoDisposeProviderRef<RatingApiService>;
String _$getRatingsByEntityHash() =>
    r'73c9482977bd96cc7d78d4c8f76910af103564e7';

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

/// See also [getRatingsByEntity].
@ProviderFor(getRatingsByEntity)
const getRatingsByEntityProvider = GetRatingsByEntityFamily();

/// See also [getRatingsByEntity].
class GetRatingsByEntityFamily extends Family<AsyncValue<List<RatingModel>>> {
  /// See also [getRatingsByEntity].
  const GetRatingsByEntityFamily();

  /// See also [getRatingsByEntity].
  GetRatingsByEntityProvider call({
    required String entityId,
    required String entityType,
    int pageNo = 1,
    int limit = 10,
  }) {
    return GetRatingsByEntityProvider(
      entityId: entityId,
      entityType: entityType,
      pageNo: pageNo,
      limit: limit,
    );
  }

  @override
  GetRatingsByEntityProvider getProviderOverride(
    covariant GetRatingsByEntityProvider provider,
  ) {
    return call(
      entityId: provider.entityId,
      entityType: provider.entityType,
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
  String? get name => r'getRatingsByEntityProvider';
}

/// See also [getRatingsByEntity].
class GetRatingsByEntityProvider
    extends AutoDisposeFutureProvider<List<RatingModel>> {
  /// See also [getRatingsByEntity].
  GetRatingsByEntityProvider({
    required String entityId,
    required String entityType,
    int pageNo = 1,
    int limit = 10,
  }) : this._internal(
          (ref) => getRatingsByEntity(
            ref as GetRatingsByEntityRef,
            entityId: entityId,
            entityType: entityType,
            pageNo: pageNo,
            limit: limit,
          ),
          from: getRatingsByEntityProvider,
          name: r'getRatingsByEntityProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getRatingsByEntityHash,
          dependencies: GetRatingsByEntityFamily._dependencies,
          allTransitiveDependencies:
              GetRatingsByEntityFamily._allTransitiveDependencies,
          entityId: entityId,
          entityType: entityType,
          pageNo: pageNo,
          limit: limit,
        );

  GetRatingsByEntityProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.entityId,
    required this.entityType,
    required this.pageNo,
    required this.limit,
  }) : super.internal();

  final String entityId;
  final String entityType;
  final int pageNo;
  final int limit;

  @override
  Override overrideWith(
    FutureOr<List<RatingModel>> Function(GetRatingsByEntityRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetRatingsByEntityProvider._internal(
        (ref) => create(ref as GetRatingsByEntityRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        entityId: entityId,
        entityType: entityType,
        pageNo: pageNo,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<RatingModel>> createElement() {
    return _GetRatingsByEntityProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetRatingsByEntityProvider &&
        other.entityId == entityId &&
        other.entityType == entityType &&
        other.pageNo == pageNo &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, entityId.hashCode);
    hash = _SystemHash.combine(hash, entityType.hashCode);
    hash = _SystemHash.combine(hash, pageNo.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetRatingsByEntityRef on AutoDisposeFutureProviderRef<List<RatingModel>> {
  /// The parameter `entityId` of this provider.
  String get entityId;

  /// The parameter `entityType` of this provider.
  String get entityType;

  /// The parameter `pageNo` of this provider.
  int get pageNo;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _GetRatingsByEntityProviderElement
    extends AutoDisposeFutureProviderElement<List<RatingModel>>
    with GetRatingsByEntityRef {
  _GetRatingsByEntityProviderElement(super.provider);

  @override
  String get entityId => (origin as GetRatingsByEntityProvider).entityId;
  @override
  String get entityType => (origin as GetRatingsByEntityProvider).entityType;
  @override
  int get pageNo => (origin as GetRatingsByEntityProvider).pageNo;
  @override
  int get limit => (origin as GetRatingsByEntityProvider).limit;
}

String _$getMyRatingsHash() => r'9c278eaecd038651231adfafb16f6d13659eb962';

/// See also [getMyRatings].
@ProviderFor(getMyRatings)
const getMyRatingsProvider = GetMyRatingsFamily();

/// See also [getMyRatings].
class GetMyRatingsFamily extends Family<AsyncValue<List<RatingModel>>> {
  /// See also [getMyRatings].
  const GetMyRatingsFamily();

  /// See also [getMyRatings].
  GetMyRatingsProvider call({
    required String entityType,
    int pageNo = 1,
    int limit = 10,
  }) {
    return GetMyRatingsProvider(
      entityType: entityType,
      pageNo: pageNo,
      limit: limit,
    );
  }

  @override
  GetMyRatingsProvider getProviderOverride(
    covariant GetMyRatingsProvider provider,
  ) {
    return call(
      entityType: provider.entityType,
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
  String? get name => r'getMyRatingsProvider';
}

/// See also [getMyRatings].
class GetMyRatingsProvider
    extends AutoDisposeFutureProvider<List<RatingModel>> {
  /// See also [getMyRatings].
  GetMyRatingsProvider({
    required String entityType,
    int pageNo = 1,
    int limit = 10,
  }) : this._internal(
          (ref) => getMyRatings(
            ref as GetMyRatingsRef,
            entityType: entityType,
            pageNo: pageNo,
            limit: limit,
          ),
          from: getMyRatingsProvider,
          name: r'getMyRatingsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getMyRatingsHash,
          dependencies: GetMyRatingsFamily._dependencies,
          allTransitiveDependencies:
              GetMyRatingsFamily._allTransitiveDependencies,
          entityType: entityType,
          pageNo: pageNo,
          limit: limit,
        );

  GetMyRatingsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.entityType,
    required this.pageNo,
    required this.limit,
  }) : super.internal();

  final String entityType;
  final int pageNo;
  final int limit;

  @override
  Override overrideWith(
    FutureOr<List<RatingModel>> Function(GetMyRatingsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetMyRatingsProvider._internal(
        (ref) => create(ref as GetMyRatingsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        entityType: entityType,
        pageNo: pageNo,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<RatingModel>> createElement() {
    return _GetMyRatingsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetMyRatingsProvider &&
        other.entityType == entityType &&
        other.pageNo == pageNo &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, entityType.hashCode);
    hash = _SystemHash.combine(hash, pageNo.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetMyRatingsRef on AutoDisposeFutureProviderRef<List<RatingModel>> {
  /// The parameter `entityType` of this provider.
  String get entityType;

  /// The parameter `pageNo` of this provider.
  int get pageNo;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _GetMyRatingsProviderElement
    extends AutoDisposeFutureProviderElement<List<RatingModel>>
    with GetMyRatingsRef {
  _GetMyRatingsProviderElement(super.provider);

  @override
  String get entityType => (origin as GetMyRatingsProvider).entityType;
  @override
  int get pageNo => (origin as GetMyRatingsProvider).pageNo;
  @override
  int get limit => (origin as GetMyRatingsProvider).limit;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
