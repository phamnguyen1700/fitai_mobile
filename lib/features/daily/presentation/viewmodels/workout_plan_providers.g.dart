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
    r'2be2e56dc4a89fd0b753e3010bbdc6b3c836d437';

/// See also [workoutPlanSchedule].
@ProviderFor(workoutPlanSchedule)
final workoutPlanScheduleProvider =
    AutoDisposeFutureProvider<WorkoutPlanScheduleData>.internal(
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
    AutoDisposeFutureProviderRef<WorkoutPlanScheduleData>;
String _$workoutPlanDaysHash() => r'b2314230d06e7c1aaa8e810f62db20548531f3da';

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
