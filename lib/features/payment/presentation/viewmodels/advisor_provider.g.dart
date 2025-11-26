// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'advisor_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$advisorRepositoryHash() => r'6dfa99cb117edca44ddce1b54cec46e722a9b4c6';

/// Provider cho AdvisorRepository – dùng ở controller / UI
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
String _$advisorsHash() => r'69fe2f6561dd41ed0bb81e41fff5ea085267765e';

/// Provider load danh sách advisor (Future) – dùng trực tiếp ở UI nếu muốn
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
