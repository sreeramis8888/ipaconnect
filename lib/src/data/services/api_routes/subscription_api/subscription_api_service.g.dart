// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_api_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$subscriptionApiServiceHash() =>
    r'1f3fd45be8a8f4b101178470d2263cd33481746d';

/// See also [subscriptionApiService].
@ProviderFor(subscriptionApiService)
final subscriptionApiServiceProvider =
    AutoDisposeProvider<SubscriptionApiService>.internal(
  subscriptionApiService,
  name: r'subscriptionApiServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$subscriptionApiServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SubscriptionApiServiceRef
    = AutoDisposeProviderRef<SubscriptionApiService>;
String _$fetchSubscriptionHash() => r'a92c29c3cb906a49be94d44e47e4af2b74827760';

/// See also [fetchSubscription].
@ProviderFor(fetchSubscription)
final fetchSubscriptionProvider =
    AutoDisposeFutureProvider<Map<String, dynamic>?>.internal(
  fetchSubscription,
  name: r'fetchSubscriptionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fetchSubscriptionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FetchSubscriptionRef
    = AutoDisposeFutureProviderRef<Map<String, dynamic>?>;
String _$createSubscriptionPaymentHash() =>
    r'd8748da2318cb490874e585e0626d5f7d4c68f14';

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

/// See also [createSubscriptionPayment].
@ProviderFor(createSubscriptionPayment)
const createSubscriptionPaymentProvider = CreateSubscriptionPaymentFamily();

/// See also [createSubscriptionPayment].
class CreateSubscriptionPaymentFamily
    extends Family<AsyncValue<Map<String, dynamic>?>> {
  /// See also [createSubscriptionPayment].
  const CreateSubscriptionPaymentFamily();

  /// See also [createSubscriptionPayment].
  CreateSubscriptionPaymentProvider call({
    required String subscriptionId,
    required double amount,
    required String currency,
    required String paymentMethod,
  }) {
    return CreateSubscriptionPaymentProvider(
      subscriptionId: subscriptionId,
      amount: amount,
      currency: currency,
      paymentMethod: paymentMethod,
    );
  }

  @override
  CreateSubscriptionPaymentProvider getProviderOverride(
    covariant CreateSubscriptionPaymentProvider provider,
  ) {
    return call(
      subscriptionId: provider.subscriptionId,
      amount: provider.amount,
      currency: provider.currency,
      paymentMethod: provider.paymentMethod,
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
  String? get name => r'createSubscriptionPaymentProvider';
}

/// See also [createSubscriptionPayment].
class CreateSubscriptionPaymentProvider
    extends AutoDisposeFutureProvider<Map<String, dynamic>?> {
  /// See also [createSubscriptionPayment].
  CreateSubscriptionPaymentProvider({
    required String subscriptionId,
    required double amount,
    required String currency,
    required String paymentMethod,
  }) : this._internal(
          (ref) => createSubscriptionPayment(
            ref as CreateSubscriptionPaymentRef,
            subscriptionId: subscriptionId,
            amount: amount,
            currency: currency,
            paymentMethod: paymentMethod,
          ),
          from: createSubscriptionPaymentProvider,
          name: r'createSubscriptionPaymentProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$createSubscriptionPaymentHash,
          dependencies: CreateSubscriptionPaymentFamily._dependencies,
          allTransitiveDependencies:
              CreateSubscriptionPaymentFamily._allTransitiveDependencies,
          subscriptionId: subscriptionId,
          amount: amount,
          currency: currency,
          paymentMethod: paymentMethod,
        );

  CreateSubscriptionPaymentProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.subscriptionId,
    required this.amount,
    required this.currency,
    required this.paymentMethod,
  }) : super.internal();

  final String subscriptionId;
  final double amount;
  final String currency;
  final String paymentMethod;

  @override
  Override overrideWith(
    FutureOr<Map<String, dynamic>?> Function(
            CreateSubscriptionPaymentRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CreateSubscriptionPaymentProvider._internal(
        (ref) => create(ref as CreateSubscriptionPaymentRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        subscriptionId: subscriptionId,
        amount: amount,
        currency: currency,
        paymentMethod: paymentMethod,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, dynamic>?> createElement() {
    return _CreateSubscriptionPaymentProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CreateSubscriptionPaymentProvider &&
        other.subscriptionId == subscriptionId &&
        other.amount == amount &&
        other.currency == currency &&
        other.paymentMethod == paymentMethod;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, subscriptionId.hashCode);
    hash = _SystemHash.combine(hash, amount.hashCode);
    hash = _SystemHash.combine(hash, currency.hashCode);
    hash = _SystemHash.combine(hash, paymentMethod.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CreateSubscriptionPaymentRef
    on AutoDisposeFutureProviderRef<Map<String, dynamic>?> {
  /// The parameter `subscriptionId` of this provider.
  String get subscriptionId;

  /// The parameter `amount` of this provider.
  double get amount;

  /// The parameter `currency` of this provider.
  String get currency;

  /// The parameter `paymentMethod` of this provider.
  String get paymentMethod;
}

class _CreateSubscriptionPaymentProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, dynamic>?>
    with CreateSubscriptionPaymentRef {
  _CreateSubscriptionPaymentProviderElement(super.provider);

  @override
  String get subscriptionId =>
      (origin as CreateSubscriptionPaymentProvider).subscriptionId;
  @override
  double get amount => (origin as CreateSubscriptionPaymentProvider).amount;
  @override
  String get currency => (origin as CreateSubscriptionPaymentProvider).currency;
  @override
  String get paymentMethod =>
      (origin as CreateSubscriptionPaymentProvider).paymentMethod;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
