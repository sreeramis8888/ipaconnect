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
String _$getCompaniesHash() => r'3bfb0e27956c0ec7ce9d6095d1949e912e00b31e';

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
    String? query,
  }) {
    return GetCompaniesProvider(
      pageNo: pageNo,
      limit: limit,
      categoryId: categoryId,
      query: query,
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
      query: provider.query,
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
    String? query,
  }) : this._internal(
          (ref) => getCompanies(
            ref as GetCompaniesRef,
            pageNo: pageNo,
            limit: limit,
            categoryId: categoryId,
            query: query,
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
          query: query,
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
    required this.query,
  }) : super.internal();

  final int pageNo;
  final int limit;
  final String? categoryId;
  final String? query;

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
        query: query,
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
        other.categoryId == categoryId &&
        other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pageNo.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

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

  /// The parameter `query` of this provider.
  String? get query;
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
  @override
  String? get query => (origin as GetCompaniesProvider).query;
}

String _$getCompaniesByUserIdHash() =>
    r'b790a053b9fe6dc55ecc084fce2bb9f1464313b6';

/// See also [getCompaniesByUserId].
@ProviderFor(getCompaniesByUserId)
const getCompaniesByUserIdProvider = GetCompaniesByUserIdFamily();

/// See also [getCompaniesByUserId].
class GetCompaniesByUserIdFamily
    extends Family<AsyncValue<List<CompanyModel>>> {
  /// See also [getCompaniesByUserId].
  const GetCompaniesByUserIdFamily();

  /// See also [getCompaniesByUserId].
  GetCompaniesByUserIdProvider call({
    required String userId,
    int pageNo = 1,
    int limit = 10,
  }) {
    return GetCompaniesByUserIdProvider(
      userId: userId,
      pageNo: pageNo,
      limit: limit,
    );
  }

  @override
  GetCompaniesByUserIdProvider getProviderOverride(
    covariant GetCompaniesByUserIdProvider provider,
  ) {
    return call(
      userId: provider.userId,
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
  String? get name => r'getCompaniesByUserIdProvider';
}

/// See also [getCompaniesByUserId].
class GetCompaniesByUserIdProvider
    extends AutoDisposeFutureProvider<List<CompanyModel>> {
  /// See also [getCompaniesByUserId].
  GetCompaniesByUserIdProvider({
    required String userId,
    int pageNo = 1,
    int limit = 10,
  }) : this._internal(
          (ref) => getCompaniesByUserId(
            ref as GetCompaniesByUserIdRef,
            userId: userId,
            pageNo: pageNo,
            limit: limit,
          ),
          from: getCompaniesByUserIdProvider,
          name: r'getCompaniesByUserIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getCompaniesByUserIdHash,
          dependencies: GetCompaniesByUserIdFamily._dependencies,
          allTransitiveDependencies:
              GetCompaniesByUserIdFamily._allTransitiveDependencies,
          userId: userId,
          pageNo: pageNo,
          limit: limit,
        );

  GetCompaniesByUserIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
    required this.pageNo,
    required this.limit,
  }) : super.internal();

  final String userId;
  final int pageNo;
  final int limit;

  @override
  Override overrideWith(
    FutureOr<List<CompanyModel>> Function(GetCompaniesByUserIdRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetCompaniesByUserIdProvider._internal(
        (ref) => create(ref as GetCompaniesByUserIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
        pageNo: pageNo,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<CompanyModel>> createElement() {
    return _GetCompaniesByUserIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetCompaniesByUserIdProvider &&
        other.userId == userId &&
        other.pageNo == pageNo &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);
    hash = _SystemHash.combine(hash, pageNo.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetCompaniesByUserIdRef
    on AutoDisposeFutureProviderRef<List<CompanyModel>> {
  /// The parameter `userId` of this provider.
  String get userId;

  /// The parameter `pageNo` of this provider.
  int get pageNo;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _GetCompaniesByUserIdProviderElement
    extends AutoDisposeFutureProviderElement<List<CompanyModel>>
    with GetCompaniesByUserIdRef {
  _GetCompaniesByUserIdProviderElement(super.provider);

  @override
  String get userId => (origin as GetCompaniesByUserIdProvider).userId;
  @override
  int get pageNo => (origin as GetCompaniesByUserIdProvider).pageNo;
  @override
  int get limit => (origin as GetCompaniesByUserIdProvider).limit;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
