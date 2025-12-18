// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_api_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notificationApiServiceHash() =>
    r'80110d97f50312379e474b2ab54bde635dbf836f';

/// See also [notificationApiService].
@ProviderFor(notificationApiService)
final notificationApiServiceProvider =
    AutoDisposeProvider<NotificationApiService>.internal(
  notificationApiService,
  name: r'notificationApiServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationApiServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NotificationApiServiceRef
    = AutoDisposeProviderRef<NotificationApiService>;
String _$fetchNotificationsHash() =>
    r'a018bb3956acbec1a40523f0622b0769352f642d';

/// See also [fetchNotifications].
@ProviderFor(fetchNotifications)
final fetchNotificationsProvider =
    AutoDisposeFutureProvider<List<NotificationModel>>.internal(
  fetchNotifications,
  name: r'fetchNotificationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fetchNotificationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FetchNotificationsRef
    = AutoDisposeFutureProviderRef<List<NotificationModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
