// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promotions_api_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$promotionsApiServiceHash() =>
    r'90ad092fe2aa591ea28f767b95e35491eba8a0ee';

/// See also [promotionsApiService].
@ProviderFor(promotionsApiService)
final promotionsApiServiceProvider =
    AutoDisposeProvider<PromotionsApiService>.internal(
  promotionsApiService,
  name: r'promotionsApiServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$promotionsApiServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PromotionsApiServiceRef = AutoDisposeProviderRef<PromotionsApiService>;
String _$promotionsHash() => r'a3a3af6c1634e001bad42a4acfb33dddd17587ca';

/// See also [promotions].
@ProviderFor(promotions)
final promotionsProvider = AutoDisposeFutureProvider<List<Promotion>>.internal(
  promotions,
  name: r'promotionsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$promotionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PromotionsRef = AutoDisposeFutureProviderRef<List<Promotion>>;
String _$promotionByIdHash() => r'c4510ab17743eab6571e76c8b39827d1cb9045d7';

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

/// See also [promotionById].
@ProviderFor(promotionById)
const promotionByIdProvider = PromotionByIdFamily();

/// See also [promotionById].
class PromotionByIdFamily extends Family<AsyncValue<Promotion>> {
  /// See also [promotionById].
  const PromotionByIdFamily();

  /// See also [promotionById].
  PromotionByIdProvider call(
    String id,
  ) {
    return PromotionByIdProvider(
      id,
    );
  }

  @override
  PromotionByIdProvider getProviderOverride(
    covariant PromotionByIdProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'promotionByIdProvider';
}

/// See also [promotionById].
class PromotionByIdProvider extends AutoDisposeFutureProvider<Promotion> {
  /// See also [promotionById].
  PromotionByIdProvider(
    String id,
  ) : this._internal(
          (ref) => promotionById(
            ref as PromotionByIdRef,
            id,
          ),
          from: promotionByIdProvider,
          name: r'promotionByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$promotionByIdHash,
          dependencies: PromotionByIdFamily._dependencies,
          allTransitiveDependencies:
              PromotionByIdFamily._allTransitiveDependencies,
          id: id,
        );

  PromotionByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<Promotion> Function(PromotionByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PromotionByIdProvider._internal(
        (ref) => create(ref as PromotionByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Promotion> createElement() {
    return _PromotionByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PromotionByIdProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PromotionByIdRef on AutoDisposeFutureProviderRef<Promotion> {
  /// The parameter `id` of this provider.
  String get id;
}

class _PromotionByIdProviderElement
    extends AutoDisposeFutureProviderElement<Promotion> with PromotionByIdRef {
  _PromotionByIdProviderElement(super.provider);

  @override
  String get id => (origin as PromotionByIdProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
