// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_api_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatApiServiceHash() => r'8c0f269f9db8e5735c55342f047688c6f740f799';

/// See also [chatApiService].
@ProviderFor(chatApiService)
final chatApiServiceProvider = AutoDisposeProvider<ChatApiService>.internal(
  chatApiService,
  name: r'chatApiServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$chatApiServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ChatApiServiceRef = AutoDisposeProviderRef<ChatApiService>;
String _$getConversationsHash() => r'2af885bd41e0113291aee35aee3396bad0b01962';

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

/// See also [getConversations].
@ProviderFor(getConversations)
const getConversationsProvider = GetConversationsFamily();

/// See also [getConversations].
class GetConversationsFamily
    extends Family<AsyncValue<List<ConversationModel>>> {
  /// See also [getConversations].
  const GetConversationsFamily();

  /// See also [getConversations].
  GetConversationsProvider call({
    int pageNo = 1,
    int limit = 10,
  }) {
    return GetConversationsProvider(
      pageNo: pageNo,
      limit: limit,
    );
  }

  @override
  GetConversationsProvider getProviderOverride(
    covariant GetConversationsProvider provider,
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
  String? get name => r'getConversationsProvider';
}

/// See also [getConversations].
class GetConversationsProvider
    extends AutoDisposeFutureProvider<List<ConversationModel>> {
  /// See also [getConversations].
  GetConversationsProvider({
    int pageNo = 1,
    int limit = 10,
  }) : this._internal(
          (ref) => getConversations(
            ref as GetConversationsRef,
            pageNo: pageNo,
            limit: limit,
          ),
          from: getConversationsProvider,
          name: r'getConversationsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getConversationsHash,
          dependencies: GetConversationsFamily._dependencies,
          allTransitiveDependencies:
              GetConversationsFamily._allTransitiveDependencies,
          pageNo: pageNo,
          limit: limit,
        );

  GetConversationsProvider._internal(
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
    FutureOr<List<ConversationModel>> Function(GetConversationsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetConversationsProvider._internal(
        (ref) => create(ref as GetConversationsRef),
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
  AutoDisposeFutureProviderElement<List<ConversationModel>> createElement() {
    return _GetConversationsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetConversationsProvider &&
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
mixin GetConversationsRef
    on AutoDisposeFutureProviderRef<List<ConversationModel>> {
  /// The parameter `pageNo` of this provider.
  int get pageNo;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _GetConversationsProviderElement
    extends AutoDisposeFutureProviderElement<List<ConversationModel>>
    with GetConversationsRef {
  _GetConversationsProviderElement(super.provider);

  @override
  int get pageNo => (origin as GetConversationsProvider).pageNo;
  @override
  int get limit => (origin as GetConversationsProvider).limit;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
