// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'campaign_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$campaignApiServiceHash() =>
    r'94255071d15c578ea80852163e2be7bd07f0f3e8';

/// See also [campaignApiService].
@ProviderFor(campaignApiService)
final campaignApiServiceProvider =
    AutoDisposeProvider<CampaignApiService>.internal(
  campaignApiService,
  name: r'campaignApiServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$campaignApiServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CampaignApiServiceRef = AutoDisposeProviderRef<CampaignApiService>;
String _$fetchCampaignsHash() => r'cfd89a21d97116fb007778f594b45d071bd479dc';

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

/// See also [fetchCampaigns].
@ProviderFor(fetchCampaigns)
const fetchCampaignsProvider = FetchCampaignsFamily();

/// See also [fetchCampaigns].
class FetchCampaignsFamily extends Family<AsyncValue<List<CampaignModel>>> {
  /// See also [fetchCampaigns].
  const FetchCampaignsFamily();

  /// See also [fetchCampaigns].
  FetchCampaignsProvider call({
    int pageNo = 1,
    int limit = 10,
  }) {
    return FetchCampaignsProvider(
      pageNo: pageNo,
      limit: limit,
    );
  }

  @override
  FetchCampaignsProvider getProviderOverride(
    covariant FetchCampaignsProvider provider,
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
  String? get name => r'fetchCampaignsProvider';
}

/// See also [fetchCampaigns].
class FetchCampaignsProvider
    extends AutoDisposeFutureProvider<List<CampaignModel>> {
  /// See also [fetchCampaigns].
  FetchCampaignsProvider({
    int pageNo = 1,
    int limit = 10,
  }) : this._internal(
          (ref) => fetchCampaigns(
            ref as FetchCampaignsRef,
            pageNo: pageNo,
            limit: limit,
          ),
          from: fetchCampaignsProvider,
          name: r'fetchCampaignsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchCampaignsHash,
          dependencies: FetchCampaignsFamily._dependencies,
          allTransitiveDependencies:
              FetchCampaignsFamily._allTransitiveDependencies,
          pageNo: pageNo,
          limit: limit,
        );

  FetchCampaignsProvider._internal(
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
    FutureOr<List<CampaignModel>> Function(FetchCampaignsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchCampaignsProvider._internal(
        (ref) => create(ref as FetchCampaignsRef),
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
  AutoDisposeFutureProviderElement<List<CampaignModel>> createElement() {
    return _FetchCampaignsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchCampaignsProvider &&
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
mixin FetchCampaignsRef on AutoDisposeFutureProviderRef<List<CampaignModel>> {
  /// The parameter `pageNo` of this provider.
  int get pageNo;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _FetchCampaignsProviderElement
    extends AutoDisposeFutureProviderElement<List<CampaignModel>>
    with FetchCampaignsRef {
  _FetchCampaignsProviderElement(super.provider);

  @override
  int get pageNo => (origin as FetchCampaignsProvider).pageNo;
  @override
  int get limit => (origin as FetchCampaignsProvider).limit;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
