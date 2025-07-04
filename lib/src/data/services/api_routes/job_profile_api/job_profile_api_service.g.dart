// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_profile_api_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$jobProfileApiServiceHash() =>
    r'1fc4be8365561bf979fa4333e9286cbfcf770e97';

/// See also [jobProfileApiService].
@ProviderFor(jobProfileApiService)
final jobProfileApiServiceProvider =
    AutoDisposeProvider<JobProfileApiService>.internal(
  jobProfileApiService,
  name: r'jobProfileApiServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$jobProfileApiServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef JobProfileApiServiceRef = AutoDisposeProviderRef<JobProfileApiService>;
String _$getJobProfilesHash() => r'8a4400488ac68f7bb5ac02962dcdde1184614787';

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

/// See also [getJobProfiles].
@ProviderFor(getJobProfiles)
const getJobProfilesProvider = GetJobProfilesFamily();

/// See also [getJobProfiles].
class GetJobProfilesFamily extends Family<AsyncValue<List<JobProfileModel>>> {
  /// See also [getJobProfiles].
  const GetJobProfilesFamily();

  /// See also [getJobProfiles].
  GetJobProfilesProvider call({
    int pageNo = 1,
    int limit = 10,
    String? category,
    String? experience,
    String? noticePeriod,
    String? location,
    String? search,
  }) {
    return GetJobProfilesProvider(
      pageNo: pageNo,
      limit: limit,
      category: category,
      experience: experience,
      noticePeriod: noticePeriod,
      location: location,
      search: search,
    );
  }

  @override
  GetJobProfilesProvider getProviderOverride(
    covariant GetJobProfilesProvider provider,
  ) {
    return call(
      pageNo: provider.pageNo,
      limit: provider.limit,
      category: provider.category,
      experience: provider.experience,
      noticePeriod: provider.noticePeriod,
      location: provider.location,
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
  String? get name => r'getJobProfilesProvider';
}

/// See also [getJobProfiles].
class GetJobProfilesProvider
    extends AutoDisposeFutureProvider<List<JobProfileModel>> {
  /// See also [getJobProfiles].
  GetJobProfilesProvider({
    int pageNo = 1,
    int limit = 10,
    String? category,
    String? experience,
    String? noticePeriod,
    String? location,
    String? search,
  }) : this._internal(
          (ref) => getJobProfiles(
            ref as GetJobProfilesRef,
            pageNo: pageNo,
            limit: limit,
            category: category,
            experience: experience,
            noticePeriod: noticePeriod,
            location: location,
            search: search,
          ),
          from: getJobProfilesProvider,
          name: r'getJobProfilesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getJobProfilesHash,
          dependencies: GetJobProfilesFamily._dependencies,
          allTransitiveDependencies:
              GetJobProfilesFamily._allTransitiveDependencies,
          pageNo: pageNo,
          limit: limit,
          category: category,
          experience: experience,
          noticePeriod: noticePeriod,
          location: location,
          search: search,
        );

  GetJobProfilesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.pageNo,
    required this.limit,
    required this.category,
    required this.experience,
    required this.noticePeriod,
    required this.location,
    required this.search,
  }) : super.internal();

  final int pageNo;
  final int limit;
  final String? category;
  final String? experience;
  final String? noticePeriod;
  final String? location;
  final String? search;

  @override
  Override overrideWith(
    FutureOr<List<JobProfileModel>> Function(GetJobProfilesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetJobProfilesProvider._internal(
        (ref) => create(ref as GetJobProfilesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        pageNo: pageNo,
        limit: limit,
        category: category,
        experience: experience,
        noticePeriod: noticePeriod,
        location: location,
        search: search,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<JobProfileModel>> createElement() {
    return _GetJobProfilesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetJobProfilesProvider &&
        other.pageNo == pageNo &&
        other.limit == limit &&
        other.category == category &&
        other.experience == experience &&
        other.noticePeriod == noticePeriod &&
        other.location == location &&
        other.search == search;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pageNo.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);
    hash = _SystemHash.combine(hash, category.hashCode);
    hash = _SystemHash.combine(hash, experience.hashCode);
    hash = _SystemHash.combine(hash, noticePeriod.hashCode);
    hash = _SystemHash.combine(hash, location.hashCode);
    hash = _SystemHash.combine(hash, search.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetJobProfilesRef on AutoDisposeFutureProviderRef<List<JobProfileModel>> {
  /// The parameter `pageNo` of this provider.
  int get pageNo;

  /// The parameter `limit` of this provider.
  int get limit;

  /// The parameter `category` of this provider.
  String? get category;

  /// The parameter `experience` of this provider.
  String? get experience;

  /// The parameter `noticePeriod` of this provider.
  String? get noticePeriod;

  /// The parameter `location` of this provider.
  String? get location;

  /// The parameter `search` of this provider.
  String? get search;
}

class _GetJobProfilesProviderElement
    extends AutoDisposeFutureProviderElement<List<JobProfileModel>>
    with GetJobProfilesRef {
  _GetJobProfilesProviderElement(super.provider);

  @override
  int get pageNo => (origin as GetJobProfilesProvider).pageNo;
  @override
  int get limit => (origin as GetJobProfilesProvider).limit;
  @override
  String? get category => (origin as GetJobProfilesProvider).category;
  @override
  String? get experience => (origin as GetJobProfilesProvider).experience;
  @override
  String? get noticePeriod => (origin as GetJobProfilesProvider).noticePeriod;
  @override
  String? get location => (origin as GetJobProfilesProvider).location;
  @override
  String? get search => (origin as GetJobProfilesProvider).search;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
