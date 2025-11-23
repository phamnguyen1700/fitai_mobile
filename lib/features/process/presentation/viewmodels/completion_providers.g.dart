// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'completion_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$completionRepositoryHash() =>
    r'0ca85390b972852516a303386defcc7a1b973265';

/// Repo provider – để chỗ khác có thể override khi test
///
/// Copied from [completionRepository].
@ProviderFor(completionRepository)
final completionRepositoryProvider =
    AutoDisposeProvider<CompletionRepository>.internal(
      completionRepository,
      name: r'completionRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$completionRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CompletionRepositoryRef = AutoDisposeProviderRef<CompletionRepository>;
String _$previousCompletionDataHash() =>
    r'37dfa1967d88a991a25aa4994031eb30798f1fec';

/// Lấy full data của previous checkpoint
///
/// Copied from [previousCompletionData].
@ProviderFor(previousCompletionData)
final previousCompletionDataProvider =
    AutoDisposeFutureProvider<CompletionPercentData?>.internal(
      previousCompletionData,
      name: r'previousCompletionDataProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$previousCompletionDataHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PreviousCompletionDataRef =
    AutoDisposeFutureProviderRef<CompletionPercentData?>;
String _$previousCompletionProgressHash() =>
    r'69aa5bbfd562038c298fb8e002f549e21ea331dd';

/// Lấy progress đã chuẩn hoá 0.0–1.0
/// Dùng để map vào WeeklyCheckInCard.progress
///
/// Copied from [previousCompletionProgress].
@ProviderFor(previousCompletionProgress)
final previousCompletionProgressProvider =
    AutoDisposeFutureProvider<double>.internal(
      previousCompletionProgress,
      name: r'previousCompletionProgressProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$previousCompletionProgressHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PreviousCompletionProgressRef = AutoDisposeFutureProviderRef<double>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
