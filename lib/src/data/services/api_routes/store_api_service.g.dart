// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_api_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$storeApiServiceHash() => r'efadd46d89df14f0814d084be4440a288e618c1b';

/// See also [storeApiService].
@ProviderFor(storeApiService)
final storeApiServiceProvider = AutoDisposeProvider<StoreApiService>.internal(
  storeApiService,
  name: r'storeApiServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$storeApiServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StoreApiServiceRef = AutoDisposeProviderRef<StoreApiService>;
String _$getStoreProductsHash() => r'33b7c307d3821187cb012d31b1fcf5add380346c';

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

/// See also [getStoreProducts].
@ProviderFor(getStoreProducts)
const getStoreProductsProvider = GetStoreProductsFamily();

/// See also [getStoreProducts].
class GetStoreProductsFamily extends Family<AsyncValue<List<StoreModel>>> {
  /// See also [getStoreProducts].
  const GetStoreProductsFamily();

  /// See also [getStoreProducts].
  GetStoreProductsProvider call({
    int pageNo = 1,
    int limit = 14,
    String? search,
  }) {
    return GetStoreProductsProvider(
      pageNo: pageNo,
      limit: limit,
      search: search,
    );
  }

  @override
  GetStoreProductsProvider getProviderOverride(
    covariant GetStoreProductsProvider provider,
  ) {
    return call(
      pageNo: provider.pageNo,
      limit: provider.limit,
      search: provider.search,
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
  String? get name => r'getStoreProductsProvider';
}

/// See also [getStoreProducts].
class GetStoreProductsProvider
    extends AutoDisposeFutureProvider<List<StoreModel>> {
  /// See also [getStoreProducts].
  GetStoreProductsProvider({
    int pageNo = 1,
    int limit = 14,
    String? search,
  }) : this._internal(
          (ref) => getStoreProducts(
            ref as GetStoreProductsRef,
            pageNo: pageNo,
            limit: limit,
            search: search,
          ),
          from: getStoreProductsProvider,
          name: r'getStoreProductsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getStoreProductsHash,
          dependencies: GetStoreProductsFamily._dependencies,
          allTransitiveDependencies:
              GetStoreProductsFamily._allTransitiveDependencies,
          pageNo: pageNo,
          limit: limit,
          search: search,
        );

  GetStoreProductsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.pageNo,
    required this.limit,
    required this.search,
  }) : super.internal();

  final int pageNo;
  final int limit;
  final String? search;

  @override
  Override overrideWith(
    FutureOr<List<StoreModel>> Function(GetStoreProductsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetStoreProductsProvider._internal(
        (ref) => create(ref as GetStoreProductsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        pageNo: pageNo,
        limit: limit,
        search: search,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<StoreModel>> createElement() {
    return _GetStoreProductsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetStoreProductsProvider &&
        other.pageNo == pageNo &&
        other.limit == limit &&
        other.search == search;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pageNo.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);
    hash = _SystemHash.combine(hash, search.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetStoreProductsRef on AutoDisposeFutureProviderRef<List<StoreModel>> {
  /// The parameter `pageNo` of this provider.
  int get pageNo;

  /// The parameter `limit` of this provider.
  int get limit;

  /// The parameter `search` of this provider.
  String? get search;
}

class _GetStoreProductsProviderElement
    extends AutoDisposeFutureProviderElement<List<StoreModel>>
    with GetStoreProductsRef {
  _GetStoreProductsProviderElement(super.provider);

  @override
  int get pageNo => (origin as GetStoreProductsProvider).pageNo;
  @override
  int get limit => (origin as GetStoreProductsProvider).limit;
  @override
  String? get search => (origin as GetStoreProductsProvider).search;
}

String _$getCartHash() => r'03eda3ab6667ac9841c7d39011aa921455240a71';

/// See also [getCart].
@ProviderFor(getCart)
final getCartProvider = AutoDisposeFutureProvider<CartModel?>.internal(
  getCart,
  name: r'getCartProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getCartHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetCartRef = AutoDisposeFutureProviderRef<CartModel?>;
String _$getOrdersHash() => r'2bdf360b7099a1e8929074d9aa7924b7a1b580ca';

/// See also [getOrders].
@ProviderFor(getOrders)
const getOrdersProvider = GetOrdersFamily();

/// See also [getOrders].
class GetOrdersFamily extends Family<AsyncValue<List<OrderModel>>> {
  /// See also [getOrders].
  const GetOrdersFamily();

  /// See also [getOrders].
  GetOrdersProvider call({
    int pageNo = 1,
    int limit = 10,
  }) {
    return GetOrdersProvider(
      pageNo: pageNo,
      limit: limit,
    );
  }

  @override
  GetOrdersProvider getProviderOverride(
    covariant GetOrdersProvider provider,
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
  String? get name => r'getOrdersProvider';
}

/// See also [getOrders].
class GetOrdersProvider extends AutoDisposeFutureProvider<List<OrderModel>> {
  /// See also [getOrders].
  GetOrdersProvider({
    int pageNo = 1,
    int limit = 10,
  }) : this._internal(
          (ref) => getOrders(
            ref as GetOrdersRef,
            pageNo: pageNo,
            limit: limit,
          ),
          from: getOrdersProvider,
          name: r'getOrdersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getOrdersHash,
          dependencies: GetOrdersFamily._dependencies,
          allTransitiveDependencies: GetOrdersFamily._allTransitiveDependencies,
          pageNo: pageNo,
          limit: limit,
        );

  GetOrdersProvider._internal(
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
    FutureOr<List<OrderModel>> Function(GetOrdersRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetOrdersProvider._internal(
        (ref) => create(ref as GetOrdersRef),
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
  AutoDisposeFutureProviderElement<List<OrderModel>> createElement() {
    return _GetOrdersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetOrdersProvider &&
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
mixin GetOrdersRef on AutoDisposeFutureProviderRef<List<OrderModel>> {
  /// The parameter `pageNo` of this provider.
  int get pageNo;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _GetOrdersProviderElement
    extends AutoDisposeFutureProviderElement<List<OrderModel>>
    with GetOrdersRef {
  _GetOrdersProviderElement(super.provider);

  @override
  int get pageNo => (origin as GetOrdersProvider).pageNo;
  @override
  int get limit => (origin as GetOrdersProvider).limit;
}

String _$getStoreCategoriesHash() =>
    r'80c8fc2b44b28b0367d448c8b531951497a67cba';

/// See also [getStoreCategories].
@ProviderFor(getStoreCategories)
final getStoreCategoriesProvider =
    AutoDisposeFutureProvider<List<String>>.internal(
  getStoreCategories,
  name: r'getStoreCategoriesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getStoreCategoriesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetStoreCategoriesRef = AutoDisposeFutureProviderRef<List<String>>;
String _$getSavedShippingAddressHash() =>
    r'2abf1e45c2c88cef648a727322a39848e5e69df4';

/// See also [getSavedShippingAddress].
@ProviderFor(getSavedShippingAddress)
final getSavedShippingAddressProvider =
    AutoDisposeFutureProvider<List<OrderModel>>.internal(
  getSavedShippingAddress,
  name: r'getSavedShippingAddressProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getSavedShippingAddressHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetSavedShippingAddressRef
    = AutoDisposeFutureProviderRef<List<OrderModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
