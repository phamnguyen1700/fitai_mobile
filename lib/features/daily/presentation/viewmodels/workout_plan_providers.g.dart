// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_plan_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$workoutPlanRepositoryHash() =>
    r'74a17f1475f061543a1bff3e14a99c65d2ec33e0';

/// See also [workoutPlanRepository].
@ProviderFor(workoutPlanRepository)
final workoutPlanRepositoryProvider =
    AutoDisposeProvider<WorkoutPlanRepository>.internal(
      workoutPlanRepository,
      name: r'workoutPlanRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$workoutPlanRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WorkoutPlanRepositoryRef =
    AutoDisposeProviderRef<WorkoutPlanRepository>;
String _$workoutPlanScheduleHash() =>
    r'cd1cfc68fd1fe18307ce7346956231849f5672e5';

/// See also [workoutPlanSchedule].
@ProviderFor(workoutPlanSchedule)
final workoutPlanScheduleProvider =
    AutoDisposeFutureProvider<WorkoutPlanScheduleData?>.internal(
      workoutPlanSchedule,
      name: r'workoutPlanScheduleProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$workoutPlanScheduleHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WorkoutPlanScheduleRef =
    AutoDisposeFutureProviderRef<WorkoutPlanScheduleData?>;
String _$workoutPlanDaysHash() => r'92fa27bde61bdde57dedea9644553467bb5f5230';

/// See also [workoutPlanDays].
@ProviderFor(workoutPlanDays)
final workoutPlanDaysProvider =
    AutoDisposeFutureProvider<List<WorkoutPlanDayModel>>.internal(
      workoutPlanDays,
      name: r'workoutPlanDaysProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$workoutPlanDaysHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WorkoutPlanDaysRef =
    AutoDisposeFutureProviderRef<List<WorkoutPlanDayModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
