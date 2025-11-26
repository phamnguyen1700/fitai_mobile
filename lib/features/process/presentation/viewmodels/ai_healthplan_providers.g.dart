// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_healthplan_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$nextCheckpointTargetHash() =>
    r'917f9901eb85a6bda110623b157618f863086fdc';

/// See also [nextCheckpointTarget].
@ProviderFor(nextCheckpointTarget)
final nextCheckpointTargetProvider =
    FutureProvider<NextCheckpointTarget?>.internal(
      nextCheckpointTarget,
      name: r'nextCheckpointTargetProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$nextCheckpointTargetHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NextCheckpointTargetRef = FutureProviderRef<NextCheckpointTarget?>;
String _$aiHealthPlanServiceHash() =>
    r'b429891c5f1c6d23d5d34d526b8ad5f7d4cb0e56';

/// See also [aiHealthPlanService].
@ProviderFor(aiHealthPlanService)
final aiHealthPlanServiceProvider = Provider<AiHealthPlanService>.internal(
  aiHealthPlanService,
  name: r'aiHealthPlanServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$aiHealthPlanServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AiHealthPlanServiceRef = ProviderRef<AiHealthPlanService>;
String _$aiHealthPlanRepositoryHash() =>
    r'26e873f8a48b8b34eeb46f25ba50b6f61b903055';

/// See also [aiHealthPlanRepository].
@ProviderFor(aiHealthPlanRepository)
final aiHealthPlanRepositoryProvider =
    Provider<AiHealthPlanRepository>.internal(
      aiHealthPlanRepository,
      name: r'aiHealthPlanRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$aiHealthPlanRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AiHealthPlanRepositoryRef = ProviderRef<AiHealthPlanRepository>;
String _$mealPlanGenerateHash() => r'4493d6ff2c7ecc947d0026c590fbee329a9b2e49';

/// See also [mealPlanGenerate].
@ProviderFor(mealPlanGenerate)
final mealPlanGenerateProvider =
    FutureProvider<GenerateMealPlanWithTargetResponse>.internal(
      mealPlanGenerate,
      name: r'mealPlanGenerateProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$mealPlanGenerateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MealPlanGenerateRef =
    FutureProviderRef<GenerateMealPlanWithTargetResponse>;
String _$mealPlanDaysHash() => r'67e430c77d401133aa3b5755e7176b8cfaa1ca07';

/// Trả về danh sách DailyMealPlan (7–14 ngày) cho UI dùng
///
/// Copied from [mealPlanDays].
@ProviderFor(mealPlanDays)
final mealPlanDaysProvider = FutureProvider<List<DailyMealPlan>>.internal(
  mealPlanDays,
  name: r'mealPlanDaysProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mealPlanDaysHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MealPlanDaysRef = FutureProviderRef<List<DailyMealPlan>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
