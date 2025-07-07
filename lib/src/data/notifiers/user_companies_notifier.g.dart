// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_companies_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userCompaniesNotifierHash() =>
    r'a24527b1cc03784b55d79640099dd3cc802a1517';

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

abstract class _$UserCompaniesNotifier
    extends BuildlessAutoDisposeNotifier<List<CompanyModel>> {
  late final String userId;

  List<CompanyModel> build(
    String userId,
  );
}

/// See also [UserCompaniesNotifier].
@ProviderFor(UserCompaniesNotifier)
const userCompaniesNotifierProvider = UserCompaniesNotifierFamily();

/// See also [UserCompaniesNotifier].
class UserCompaniesNotifierFamily extends Family<List<CompanyModel>> {
  /// See also [UserCompaniesNotifier].
  const UserCompaniesNotifierFamily();

  /// See also [UserCompaniesNotifier].
  UserCompaniesNotifierProvider call(
    String userId,
  ) {
    return UserCompaniesNotifierProvider(
      userId,
    );
  }

  @override
  UserCompaniesNotifierProvider getProviderOverride(
    covariant UserCompaniesNotifierProvider provider,
  ) {
    return call(
      provider.userId,
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
  String? get name => r'userCompaniesNotifierProvider';
}

/// See also [UserCompaniesNotifier].
class UserCompaniesNotifierProvider extends AutoDisposeNotifierProviderImpl<
    UserCompaniesNotifier, List<CompanyModel>> {
  /// See also [UserCompaniesNotifier].
  UserCompaniesNotifierProvider(
    String userId,
  ) : this._internal(
          () => UserCompaniesNotifier()..userId = userId,
          from: userCompaniesNotifierProvider,
          name: r'userCompaniesNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userCompaniesNotifierHash,
          dependencies: UserCompaniesNotifierFamily._dependencies,
          allTransitiveDependencies:
              UserCompaniesNotifierFamily._allTransitiveDependencies,
          userId: userId,
        );

  UserCompaniesNotifierProvider._internal(
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
  List<CompanyModel> runNotifierBuild(
    covariant UserCompaniesNotifier notifier,
  ) {
    return notifier.build(
      userId,
    );
  }

  @override
  Override overrideWith(UserCompaniesNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: UserCompaniesNotifierProvider._internal(
        () => create()..userId = userId,
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
  AutoDisposeNotifierProviderElement<UserCompaniesNotifier, List<CompanyModel>>
      createElement() {
    return _UserCompaniesNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserCompaniesNotifierProvider && other.userId == userId;
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
mixin UserCompaniesNotifierRef
    on AutoDisposeNotifierProviderRef<List<CompanyModel>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserCompaniesNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<UserCompaniesNotifier,
        List<CompanyModel>> with UserCompaniesNotifierRef {
  _UserCompaniesNotifierProviderElement(super.provider);

  @override
  String get userId => (origin as UserCompaniesNotifierProvider).userId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
