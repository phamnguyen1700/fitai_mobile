// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'achievement_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$achievementRepositoryHash() =>
    r'64c7abb0bba36113b118e99546e88a9614bdec44';

/// Repo provider (keepAlive vì xài nhiều chỗ cũng ok)
///
/// Copied from [achievementRepository].
@ProviderFor(achievementRepository)
final achievementRepositoryProvider = Provider<AchievementRepository>.internal(
  achievementRepository,
  name: r'achievementRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$achievementRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AchievementRepositoryRef = ProviderRef<AchievementRepository>;
String _$achievementSummaryHash() =>
    r'e1d351d71f816f62f2f80487adf1b6af55405d42';

/// FutureProvider load AchievementSummary từ repo
///
/// Copied from [achievementSummary].
@ProviderFor(achievementSummary)
final achievementSummaryProvider =
    AutoDisposeFutureProvider<AchievementSummary?>.internal(
      achievementSummary,
      name: r'achievementSummaryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$achievementSummaryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AchievementSummaryRef =
    AutoDisposeFutureProviderRef<AchievementSummary?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
