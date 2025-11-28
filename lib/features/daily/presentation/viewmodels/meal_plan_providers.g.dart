// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_plan_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mealPlanRepositoryHash() =>
    r'3326c4f3613d869f6a8da08ac483cfd74448d6fc';

/// Repository singleton (codegen)
///
/// Copied from [mealPlanRepository].
@ProviderFor(mealPlanRepository)
final mealPlanRepositoryProvider =
    AutoDisposeProvider<MealPlanRepository>.internal(
      mealPlanRepository,
      name: r'mealPlanRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$mealPlanRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MealPlanRepositoryRef = AutoDisposeProviderRef<MealPlanRepository>;
String _$dailyMealsHash() => r'ac5e26234e0c3bccc119f8afdcfd5facb1bd0e6a';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// ===============================
/// FETCH DAILY MEALS (result full)
/// ===============================
///
/// Copied from [dailyMeals].
@ProviderFor(dailyMeals)
const dailyMealsProvider = DailyMealsFamily();

/// ===============================
/// FETCH DAILY MEALS (result full)
/// ===============================
///
/// Copied from [dailyMeals].
class DailyMealsFamily extends Family<AsyncValue<MealPlanResult>> {
  /// ===============================
  /// FETCH DAILY MEALS (result full)
  /// ===============================
  ///
  /// Copied from [dailyMeals].
  const DailyMealsFamily();

  /// ===============================
  /// FETCH DAILY MEALS (result full)
  /// ===============================
  ///
  /// Copied from [dailyMeals].
  DailyMealsProvider call(int dayNumber) {
    return DailyMealsProvider(dayNumber);
  }

  @override
  DailyMealsProvider getProviderOverride(
    covariant DailyMealsProvider provider,
  ) {
    return call(provider.dayNumber);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'dailyMealsProvider';
}

/// ===============================
/// FETCH DAILY MEALS (result full)
/// ===============================
///
/// Copied from [dailyMeals].
class DailyMealsProvider extends AutoDisposeFutureProvider<MealPlanResult> {
  /// ===============================
  /// FETCH DAILY MEALS (result full)
  /// ===============================
  ///
  /// Copied from [dailyMeals].
  DailyMealsProvider(int dayNumber)
    : this._internal(
        (ref) => dailyMeals(ref as DailyMealsRef, dayNumber),
        from: dailyMealsProvider,
        name: r'dailyMealsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$dailyMealsHash,
        dependencies: DailyMealsFamily._dependencies,
        allTransitiveDependencies: DailyMealsFamily._allTransitiveDependencies,
        dayNumber: dayNumber,
      );

  DailyMealsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.dayNumber,
  }) : super.internal();

  final int dayNumber;

  @override
  Override overrideWith(
    FutureOr<MealPlanResult> Function(DailyMealsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DailyMealsProvider._internal(
        (ref) => create(ref as DailyMealsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        dayNumber: dayNumber,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<MealPlanResult> createElement() {
    return _DailyMealsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DailyMealsProvider && other.dayNumber == dayNumber;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, dayNumber.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DailyMealsRef on AutoDisposeFutureProviderRef<MealPlanResult> {
  /// The parameter `dayNumber` of this provider.
  int get dayNumber;
}

class _DailyMealsProviderElement
    extends AutoDisposeFutureProviderElement<MealPlanResult>
    with DailyMealsRef {
  _DailyMealsProviderElement(super.provider);

  @override
  int get dayNumber => (origin as DailyMealsProvider).dayNumber;
}

String _$todayMealsHash() => r'3601511d47d69fe10b51b137f47404d6c4c270fe';

/// ===============================
/// TODAY MEALS (theo currentDay)
/// ===============================
///
/// Copied from [todayMeals].
@ProviderFor(todayMeals)
final todayMealsProvider = AutoDisposeFutureProvider<MealPlanResult>.internal(
  todayMeals,
  name: r'todayMealsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$todayMealsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodayMealsRef = AutoDisposeFutureProviderRef<MealPlanResult>;
String _$mealPlanStatusHash() => r'3cdaedeef0f98c9e8b9cdaec271ceed302e32c9e';

/// ======================================
/// STATUS PROVIDER — để OnboardingGate bắt
/// ======================================
/// trả về: 'has_plan' | 'no_plan' | 'error' | 'loading'
///
/// Copied from [mealPlanStatus].
@ProviderFor(mealPlanStatus)
final mealPlanStatusProvider = AutoDisposeProvider<String>.internal(
  mealPlanStatus,
  name: r'mealPlanStatusProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mealPlanStatusHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MealPlanStatusRef = AutoDisposeProviderRef<String>;
String _$currentDayHash() => r'6d0c5a6ecb6baa3bab0f6231455b17e1426ef22b';

/// ============
/// Current Day
/// ============
///
/// Copied from [CurrentDay].
@ProviderFor(CurrentDay)
final currentDayProvider =
    AutoDisposeNotifierProvider<CurrentDay, int>.internal(
      CurrentDay.new,
      name: r'currentDayProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$currentDayHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CurrentDay = AutoDisposeNotifier<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
