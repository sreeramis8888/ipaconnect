// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userDataApiServiceHash() =>
    r'830a2b8a9d6f0e5fdda9b58f3e75b2e242ba85c6';

/// See also [userDataApiService].
@ProviderFor(userDataApiService)
final userDataApiServiceProvider =
    AutoDisposeProvider<UserDataApiService>.internal(
  userDataApiService,
  name: r'userDataApiServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userDataApiServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserDataApiServiceRef = AutoDisposeProviderRef<UserDataApiService>;
String _$getUserDetailsHash() => r'f7f80861d16d9e12ea8824fece785072cc1fe7cc';

/// See also [getUserDetails].
@ProviderFor(getUserDetails)
final getUserDetailsProvider = AutoDisposeFutureProvider<UserModel?>.internal(
  getUserDetails,
  name: r'getUserDetailsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getUserDetailsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetUserDetailsRef = AutoDisposeFutureProviderRef<UserModel?>;
String _$getUserDetailsByIdHash() =>
    r'ff49e65dad74c258f09542e143201e7d1aab2809';

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

/// See also [getUserDetailsById].
@ProviderFor(getUserDetailsById)
const getUserDetailsByIdProvider = GetUserDetailsByIdFamily();

/// See also [getUserDetailsById].
class GetUserDetailsByIdFamily extends Family<AsyncValue<UserModel?>> {
  /// See also [getUserDetailsById].
  const GetUserDetailsByIdFamily();

  /// See also [getUserDetailsById].
  GetUserDetailsByIdProvider call({
    required String userId,
  }) {
    return GetUserDetailsByIdProvider(
      userId: userId,
    );
  }

  @override
  GetUserDetailsByIdProvider getProviderOverride(
    covariant GetUserDetailsByIdProvider provider,
  ) {
    return call(
      userId: provider.userId,
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
  String? get name => r'getUserDetailsByIdProvider';
}

/// See also [getUserDetailsById].
class GetUserDetailsByIdProvider extends AutoDisposeFutureProvider<UserModel?> {
  /// See also [getUserDetailsById].
  GetUserDetailsByIdProvider({
    required String userId,
  }) : this._internal(
          (ref) => getUserDetailsById(
            ref as GetUserDetailsByIdRef,
            userId: userId,
          ),
          from: getUserDetailsByIdProvider,
          name: r'getUserDetailsByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getUserDetailsByIdHash,
          dependencies: GetUserDetailsByIdFamily._dependencies,
          allTransitiveDependencies:
              GetUserDetailsByIdFamily._allTransitiveDependencies,
          userId: userId,
        );

  GetUserDetailsByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    FutureOr<UserModel?> Function(GetUserDetailsByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetUserDetailsByIdProvider._internal(
        (ref) => create(ref as GetUserDetailsByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<UserModel?> createElement() {
    return _GetUserDetailsByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetUserDetailsByIdProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetUserDetailsByIdRef on AutoDisposeFutureProviderRef<UserModel?> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _GetUserDetailsByIdProviderElement
    extends AutoDisposeFutureProviderElement<UserModel?>
    with GetUserDetailsByIdRef {
  _GetUserDetailsByIdProviderElement(super.provider);

  @override
  String get userId => (origin as GetUserDetailsByIdProvider).userId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
