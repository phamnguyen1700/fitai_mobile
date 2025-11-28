// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'completion_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$completionRepositoryHash() =>
    r'0ca85390b972852516a303386defcc7a1b973265';

/// Repo provider (singleton)
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
String _$previousCompletionResultHash() =>
    r'0cc5d138b820c3d2cc965b85e27aca0ff11c23fa';

/// ======================================
/// Lấy full CompletionResult từ repo
/// ======================================
///
/// Copied from [previousCompletionResult].
@ProviderFor(previousCompletionResult)
final previousCompletionResultProvider =
    AutoDisposeFutureProvider<CompletionResult>.internal(
      previousCompletionResult,
      name: r'previousCompletionResultProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$previousCompletionResultHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PreviousCompletionResultRef =
    AutoDisposeFutureProviderRef<CompletionResult>;
String _$previousCompletionDataHash() =>
    r'ff8103870ee21ce08995ac244d8440b9ddc0accc';

/// ======================================
/// Chỉ lấy phần data cho UI
/// (CompletionPercentData? hoặc null)
/// ======================================
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
    r'5f48bf7c41bad6b07f57e0c8178255302e62be9d';

/// ======================================
/// Lấy progress cho WeeklyCheckInCard
/// result.status != has_plan → progress = 0
/// ======================================
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
String _$checkpointStatusHash() => r'46f01fae5c9bcac3c86ae37a3c33d7db87172d4c';

/// ======================================
/// STATUS PROVIDER (dùng cho OnboardingGate)
/// Trả về: "has_plan" | "no_plan" | "error" | "loading"
/// ======================================
///
/// Copied from [checkpointStatus].
@ProviderFor(checkpointStatus)
final checkpointStatusProvider = AutoDisposeProvider<String>.internal(
  checkpointStatus,
  name: r'checkpointStatusProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$checkpointStatusHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CheckpointStatusRef = AutoDisposeProviderRef<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
