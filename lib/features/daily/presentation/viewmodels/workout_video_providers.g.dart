// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_video_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$workoutVideoRepositoryHash() =>
    r'eb6b1920e5b51887fb4efc707d7f4cb0ff0ab689';

/// Singleton repo
///
/// Copied from [workoutVideoRepository].
@ProviderFor(workoutVideoRepository)
final workoutVideoRepositoryProvider =
    AutoDisposeProvider<WorkoutVideoRepository>.internal(
      workoutVideoRepository,
      name: r'workoutVideoRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$workoutVideoRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WorkoutVideoRepositoryRef =
    AutoDisposeProviderRef<WorkoutVideoRepository>;
String _$workoutVideoUploadControllerHash() =>
    r'0bc707aefc75b6b63eeda8f2e97ab33a599f34d8';

/// Controller để gọi upload từ UI
///
/// Copied from [WorkoutVideoUploadController].
@ProviderFor(WorkoutVideoUploadController)
final workoutVideoUploadControllerProvider =
    AutoDisposeAsyncNotifierProvider<
      WorkoutVideoUploadController,
      void
    >.internal(
      WorkoutVideoUploadController.new,
      name: r'workoutVideoUploadControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$workoutVideoUploadControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$WorkoutVideoUploadController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
