// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'advisor_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$advisorServiceHash() => r'bcec0f80f0c400c7824626ff54979a8fcae57e1b';

/// Provider cho AdvisorService
///
/// Copied from [advisorService].
@ProviderFor(advisorService)
final advisorServiceProvider = AutoDisposeProvider<AdvisorService>.internal(
  advisorService,
  name: r'advisorServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$advisorServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AdvisorServiceRef = AutoDisposeProviderRef<AdvisorService>;
String _$advisorRepositoryHash() => r'd429dc34fb866482f75d3ec7034c502f82c4fa52';

/// Provider cho AdvisorRepository – dùng để gán advisor, v.v.
///
/// Copied from [advisorRepository].
@ProviderFor(advisorRepository)
final advisorRepositoryProvider =
    AutoDisposeProvider<AdvisorRepository>.internal(
      advisorRepository,
      name: r'advisorRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$advisorRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AdvisorRepositoryRef = AutoDisposeProviderRef<AdvisorRepository>;
String _$advisorsHash() => r'b31fba00cc8bcc1f81b21a6db0ec7e47eebd0bf1';

/// Provider load danh sách advisor (Future) – dùng ở UI
///
/// Copied from [advisors].
@ProviderFor(advisors)
final advisorsProvider = AutoDisposeFutureProvider<List<AdvisorModel>>.internal(
  advisors,
  name: r'advisorsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$advisorsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AdvisorsRef = AutoDisposeFutureProviderRef<List<AdvisorModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
