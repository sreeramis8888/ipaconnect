// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products_api_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$productsApiServiceHash() =>
    r'4a6dc038105823c282b8b59f63dc2d101b2fcbb7';

/// See also [productsApiService].
@ProviderFor(productsApiService)
final productsApiServiceProvider =
    AutoDisposeProvider<ProductsApiService>.internal(
  productsApiService,
  name: r'productsApiServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$productsApiServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProductsApiServiceRef = AutoDisposeProviderRef<ProductsApiService>;
String _$getProductsHash() => r'7981b3b8f091402da18e4d7e25f355cc4aef2dbb';

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

/// See also [getProducts].
@ProviderFor(getProducts)
const getProductsProvider = GetProductsFamily();

/// See also [getProducts].
class GetProductsFamily extends Family<AsyncValue<List<ProductModel>>> {
  /// See also [getProducts].
  const GetProductsFamily();

  /// See also [getProducts].
  GetProductsProvider call({
    int pageNo = 1,
    int limit = 10,
    required String companyId,
  }) {
    return GetProductsProvider(
      pageNo: pageNo,
      limit: limit,
      companyId: companyId,
    );
  }

  @override
  GetProductsProvider getProviderOverride(
    covariant GetProductsProvider provider,
  ) {
    return call(
      pageNo: provider.pageNo,
      limit: provider.limit,
      companyId: provider.companyId,
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
  String? get name => r'getProductsProvider';
}

/// See also [getProducts].
class GetProductsProvider
    extends AutoDisposeFutureProvider<List<ProductModel>> {
  /// See also [getProducts].
  GetProductsProvider({
    int pageNo = 1,
    int limit = 10,
    required String companyId,
  }) : this._internal(
          (ref) => getProducts(
            ref as GetProductsRef,
            pageNo: pageNo,
            limit: limit,
            companyId: companyId,
          ),
          from: getProductsProvider,
          name: r'getProductsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getProductsHash,
          dependencies: GetProductsFamily._dependencies,
          allTransitiveDependencies:
              GetProductsFamily._allTransitiveDependencies,
          pageNo: pageNo,
          limit: limit,
          companyId: companyId,
        );

  GetProductsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.pageNo,
    required this.limit,
    required this.companyId,
  }) : super.internal();

  final int pageNo;
  final int limit;
  final String companyId;

  @override
  Override overrideWith(
    FutureOr<List<ProductModel>> Function(GetProductsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetProductsProvider._internal(
        (ref) => create(ref as GetProductsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        pageNo: pageNo,
        limit: limit,
        companyId: companyId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ProductModel>> createElement() {
    return _GetProductsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetProductsProvider &&
        other.pageNo == pageNo &&
        other.limit == limit &&
        other.companyId == companyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pageNo.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);
    hash = _SystemHash.combine(hash, companyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetProductsRef on AutoDisposeFutureProviderRef<List<ProductModel>> {
  /// The parameter `pageNo` of this provider.
  int get pageNo;

  /// The parameter `limit` of this provider.
  int get limit;

  /// The parameter `companyId` of this provider.
  String get companyId;
}

class _GetProductsProviderElement
    extends AutoDisposeFutureProviderElement<List<ProductModel>>
    with GetProductsRef {
  _GetProductsProviderElement(super.provider);

  @override
  int get pageNo => (origin as GetProductsProvider).pageNo;
  @override
  int get limit => (origin as GetProductsProvider).limit;
  @override
  String get companyId => (origin as GetProductsProvider).companyId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
