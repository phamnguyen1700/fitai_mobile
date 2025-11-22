// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'process_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$processRepositoryHash() => r'2b4511e34e1cb83b0abaa592695d227ade4ddd62';

/// Provider cho ProcessRepository
///
/// Copied from [processRepository].
@ProviderFor(processRepository)
final processRepositoryProvider =
    AutoDisposeProvider<ProcessRepository>.internal(
      processRepository,
      name: r'processRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$processRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProcessRepositoryRef = AutoDisposeProviderRef<ProcessRepository>;
String _$previousCheckpointCompletionHash() =>
    r'0065d1d5b43a2d66fc06b86b0e66c170ba3b626e';

/// Previous checkpoint completion percent
///
/// GET /api/checkpoints/previous/completion-percent
///
/// Copied from [previousCheckpointCompletion].
@ProviderFor(previousCheckpointCompletion)
final previousCheckpointCompletionProvider =
    AutoDisposeFutureProvider<PreviousCheckpointCompletionResponse>.internal(
      previousCheckpointCompletion,
      name: r'previousCheckpointCompletionProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$previousCheckpointCompletionHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PreviousCheckpointCompletionRef =
    AutoDisposeFutureProviderRef<PreviousCheckpointCompletionResponse>;
String _$progressLineChartHash() => r'be605560db5d9750e1596583c89a9bfb6e370455';

/// Progress line chart
///
/// GET /api/checkpoints/linechart
///
/// Copied from [progressLineChart].
@ProviderFor(progressLineChart)
final progressLineChartProvider =
    AutoDisposeFutureProvider<ProgressLineChartResponse>.internal(
      progressLineChart,
      name: r'progressLineChartProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$progressLineChartHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProgressLineChartRef =
    AutoDisposeFutureProviderRef<ProgressLineChartResponse>;
String _$bodyCompositionPieHash() =>
    r'e0b66719a0b9ec02ceecec0e39aa64852ad92ef9';

/// Body composition pie chart
///
/// GET /api/checkpoints/piechart
///
/// Copied from [bodyCompositionPie].
@ProviderFor(bodyCompositionPie)
final bodyCompositionPieProvider =
    AutoDisposeFutureProvider<BodyCompositionPieResponse>.internal(
      bodyCompositionPie,
      name: r'bodyCompositionPieProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$bodyCompositionPieHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BodyCompositionPieRef =
    AutoDisposeFutureProviderRef<BodyCompositionPieResponse>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
