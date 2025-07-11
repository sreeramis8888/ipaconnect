// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hierarchy_api_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$hierarchyApiServiceHash() =>
    r'a91742ba26c7a9776fba30411297584f3445b06d';

/// See also [hierarchyApiService].
@ProviderFor(hierarchyApiService)
final hierarchyApiServiceProvider =
    AutoDisposeProvider<HierarchyApiService>.internal(
  hierarchyApiService,
  name: r'hierarchyApiServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$hierarchyApiServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HierarchyApiServiceRef = AutoDisposeProviderRef<HierarchyApiService>;
String _$getHierarchyHash() => r'ada7dade2bebd3717f00b38e899ce69fda8128c8';

/// See also [getHierarchy].
@ProviderFor(getHierarchy)
final getHierarchyProvider =
    AutoDisposeFutureProvider<List<HierarchyModel>>.internal(
  getHierarchy,
  name: r'getHierarchyProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getHierarchyHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetHierarchyRef = AutoDisposeFutureProviderRef<List<HierarchyModel>>;
String _$getHierarchyUsersHash() => r'2e6a5bc9e5b86edd607023787c0978b69af2b176';

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

/// See also [getHierarchyUsers].
@ProviderFor(getHierarchyUsers)
const getHierarchyUsersProvider = GetHierarchyUsersFamily();

/// See also [getHierarchyUsers].
class GetHierarchyUsersFamily extends Family<AsyncValue<List<UserModel>>> {
  /// See also [getHierarchyUsers].
  const GetHierarchyUsersFamily();

  /// See also [getHierarchyUsers].
  GetHierarchyUsersProvider call({
    required String hierarchyId,
    required int page,
    required int limit,
  }) {
    return GetHierarchyUsersProvider(
      hierarchyId: hierarchyId,
      page: page,
      limit: limit,
    );
  }

  @override
  GetHierarchyUsersProvider getProviderOverride(
    covariant GetHierarchyUsersProvider provider,
  ) {
    return call(
      hierarchyId: provider.hierarchyId,
      page: provider.page,
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
  String? get name => r'getHierarchyUsersProvider';
}

/// See also [getHierarchyUsers].
class GetHierarchyUsersProvider
    extends AutoDisposeFutureProvider<List<UserModel>> {
  /// See also [getHierarchyUsers].
  GetHierarchyUsersProvider({
    required String hierarchyId,
    required int page,
    required int limit,
  }) : this._internal(
          (ref) => getHierarchyUsers(
            ref as GetHierarchyUsersRef,
            hierarchyId: hierarchyId,
            page: page,
            limit: limit,
          ),
          from: getHierarchyUsersProvider,
          name: r'getHierarchyUsersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getHierarchyUsersHash,
          dependencies: GetHierarchyUsersFamily._dependencies,
          allTransitiveDependencies:
              GetHierarchyUsersFamily._allTransitiveDependencies,
          hierarchyId: hierarchyId,
          page: page,
          limit: limit,
        );

  GetHierarchyUsersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.hierarchyId,
    required this.page,
    required this.limit,
  }) : super.internal();

  final String hierarchyId;
  final int page;
  final int limit;

  @override
  Override overrideWith(
    FutureOr<List<UserModel>> Function(GetHierarchyUsersRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetHierarchyUsersProvider._internal(
        (ref) => create(ref as GetHierarchyUsersRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        hierarchyId: hierarchyId,
        page: page,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<UserModel>> createElement() {
    return _GetHierarchyUsersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetHierarchyUsersProvider &&
        other.hierarchyId == hierarchyId &&
        other.page == page &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, hierarchyId.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetHierarchyUsersRef on AutoDisposeFutureProviderRef<List<UserModel>> {
  /// The parameter `hierarchyId` of this provider.
  String get hierarchyId;

  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _GetHierarchyUsersProviderElement
    extends AutoDisposeFutureProviderElement<List<UserModel>>
    with GetHierarchyUsersRef {
  _GetHierarchyUsersProviderElement(super.provider);

  @override
  String get hierarchyId => (origin as GetHierarchyUsersProvider).hierarchyId;
  @override
  int get page => (origin as GetHierarchyUsersProvider).page;
  @override
  int get limit => (origin as GetHierarchyUsersProvider).limit;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
