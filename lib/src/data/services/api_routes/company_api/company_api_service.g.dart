// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_api_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$companyApiServiceHash() => r'420a69dc2c56c393aa08b63a3c51b366fea7a9ea';

/// See also [companyApiService].
@ProviderFor(companyApiService)
final companyApiServiceProvider =
    AutoDisposeProvider<CompanyApiService>.internal(
  companyApiService,
  name: r'companyApiServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$companyApiServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CompanyApiServiceRef = AutoDisposeProviderRef<CompanyApiService>;
String _$getCompaniesHash() => r'04349595a39b3b210ca4dcfba3ccc6e8cdf45299';

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

/// See also [getCompanies].
@ProviderFor(getCompanies)
const getCompaniesProvider = GetCompaniesFamily();

/// See also [getCompanies].
class GetCompaniesFamily extends Family<AsyncValue<List<CompanyModel>>> {
  /// See also [getCompanies].
  const GetCompaniesFamily();

  /// See also [getCompanies].
  GetCompaniesProvider call({
    int pageNo = 1,
    int limit = 10,
    String? categoryId,
  }) {
    return GetCompaniesProvider(
      pageNo: pageNo,
      limit: limit,
      categoryId: categoryId,
    );
  }

  @override
  GetCompaniesProvider getProviderOverride(
    covariant GetCompaniesProvider provider,
  ) {
    return call(
      pageNo: provider.pageNo,
      limit: provider.limit,
      categoryId: provider.categoryId,
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
  String? get name => r'getCompaniesProvider';
}

/// See also [getCompanies].
class GetCompaniesProvider
    extends AutoDisposeFutureProvider<List<CompanyModel>> {
  /// See also [getCompanies].
  GetCompaniesProvider({
    int pageNo = 1,
    int limit = 10,
    String? categoryId,
  }) : this._internal(
          (ref) => getCompanies(
            ref as GetCompaniesRef,
            pageNo: pageNo,
            limit: limit,
            categoryId: categoryId,
          ),
          from: getCompaniesProvider,
          name: r'getCompaniesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getCompaniesHash,
          dependencies: GetCompaniesFamily._dependencies,
          allTransitiveDependencies:
              GetCompaniesFamily._allTransitiveDependencies,
          pageNo: pageNo,
          limit: limit,
          categoryId: categoryId,
        );

  GetCompaniesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.pageNo,
    required this.limit,
    required this.categoryId,
  }) : super.internal();

  final int pageNo;
  final int limit;
  final String? categoryId;

  @override
  Override overrideWith(
    FutureOr<List<CompanyModel>> Function(GetCompaniesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetCompaniesProvider._internal(
        (ref) => create(ref as GetCompaniesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        pageNo: pageNo,
        limit: limit,
        categoryId: categoryId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<CompanyModel>> createElement() {
    return _GetCompaniesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetCompaniesProvider &&
        other.pageNo == pageNo &&
        other.limit == limit &&
        other.categoryId == categoryId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pageNo.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetCompaniesRef on AutoDisposeFutureProviderRef<List<CompanyModel>> {
  /// The parameter `pageNo` of this provider.
  int get pageNo;

  /// The parameter `limit` of this provider.
  int get limit;

  /// The parameter `categoryId` of this provider.
  String? get categoryId;
}

class _GetCompaniesProviderElement
    extends AutoDisposeFutureProviderElement<List<CompanyModel>>
    with GetCompaniesRef {
  _GetCompaniesProviderElement(super.provider);

  @override
  int get pageNo => (origin as GetCompaniesProvider).pageNo;
  @override
  int get limit => (origin as GetCompaniesProvider).limit;
  @override
  String? get categoryId => (origin as GetCompaniesProvider).categoryId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
