// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_api_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$newsApiServiceHash() => r'15abdfb35e3e3308602fae74e29a620b26f8f63d';

/// See also [newsApiService].
@ProviderFor(newsApiService)
final newsApiServiceProvider = AutoDisposeProvider<NewsApiService>.internal(
  newsApiService,
  name: r'newsApiServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$newsApiServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NewsApiServiceRef = AutoDisposeProviderRef<NewsApiService>;
String _$newsHash() => r'1c4ef2ffb2b24f88cf9546ed7746a7239c4f53c5';

/// See also [news].
@ProviderFor(news)
final newsProvider = AutoDisposeFutureProvider<List<NewsModel>>.internal(
  news,
  name: r'newsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$newsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NewsRef = AutoDisposeFutureProviderRef<List<NewsModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
