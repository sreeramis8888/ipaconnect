// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_category_api_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$businessCategoryApiServiceHash() =>
    r'e7898064f58e1143639fbeab5c4e1cb6460b354a';

/// See also [businessCategoryApiService].
@ProviderFor(businessCategoryApiService)
final businessCategoryApiServiceProvider =
    AutoDisposeProvider<BusinesscategoryApiService>.internal(
  businessCategoryApiService,
  name: r'businessCategoryApiServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$businessCategoryApiServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BusinessCategoryApiServiceRef
    = AutoDisposeProviderRef<BusinesscategoryApiService>;
String _$getBusinessCategoriesHash() =>
    r'f5e90c0eb47ac1bd2d0a6a6f2dbf842fe0ce8ed3';

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

/// See also [getBusinessCategories].
@ProviderFor(getBusinessCategories)
const getBusinessCategoriesProvider = GetBusinessCategoriesFamily();

/// See also [getBusinessCategories].
class GetBusinessCategoriesFamily
    extends Family<AsyncValue<List<BusinessCategoryModel>>> {
  /// See also [getBusinessCategories].
  const GetBusinessCategoriesFamily();

  /// See also [getBusinessCategories].
  GetBusinessCategoriesProvider call({
    int pageNo = 1,
    int limit = 10,
  }) {
    return GetBusinessCategoriesProvider(
      pageNo: pageNo,
      limit: limit,
    );
  }

  @override
  GetBusinessCategoriesProvider getProviderOverride(
    covariant GetBusinessCategoriesProvider provider,
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
  String? get name => r'getBusinessCategoriesProvider';
}

/// See also [getBusinessCategories].
class GetBusinessCategoriesProvider
    extends AutoDisposeFutureProvider<List<BusinessCategoryModel>> {
  /// See also [getBusinessCategories].
  GetBusinessCategoriesProvider({
    int pageNo = 1,
    int limit = 10,
  }) : this._internal(
          (ref) => getBusinessCategories(
            ref as GetBusinessCategoriesRef,
            pageNo: pageNo,
            limit: limit,
          ),
          from: getBusinessCategoriesProvider,
          name: r'getBusinessCategoriesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getBusinessCategoriesHash,
          dependencies: GetBusinessCategoriesFamily._dependencies,
          allTransitiveDependencies:
              GetBusinessCategoriesFamily._allTransitiveDependencies,
          pageNo: pageNo,
          limit: limit,
        );

  GetBusinessCategoriesProvider._internal(
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
    FutureOr<List<BusinessCategoryModel>> Function(
            GetBusinessCategoriesRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetBusinessCategoriesProvider._internal(
        (ref) => create(ref as GetBusinessCategoriesRef),
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
  AutoDisposeFutureProviderElement<List<BusinessCategoryModel>>
      createElement() {
    return _GetBusinessCategoriesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetBusinessCategoriesProvider &&
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
mixin GetBusinessCategoriesRef
    on AutoDisposeFutureProviderRef<List<BusinessCategoryModel>> {
  /// The parameter `pageNo` of this provider.
  int get pageNo;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _GetBusinessCategoriesProviderElement
    extends AutoDisposeFutureProviderElement<List<BusinessCategoryModel>>
    with GetBusinessCategoriesRef {
  _GetBusinessCategoriesProviderElement(super.provider);

  @override
  int get pageNo => (origin as GetBusinessCategoriesProvider).pageNo;
  @override
  int get limit => (origin as GetBusinessCategoriesProvider).limit;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
