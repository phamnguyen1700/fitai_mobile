// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_comments_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$workoutCommentRepositoryHash() =>
    r'b5b610057ecdb2734a2b01fd40ab94ddfebfd2da';

/// Repository provider
///
/// Copied from [workoutCommentRepository].
@ProviderFor(workoutCommentRepository)
final workoutCommentRepositoryProvider =
    AutoDisposeProvider<WorkoutCommentRepository>.internal(
      workoutCommentRepository,
      name: r'workoutCommentRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$workoutCommentRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WorkoutCommentRepositoryRef =
    AutoDisposeProviderRef<WorkoutCommentRepository>;
String _$workoutCommentsControllerHash() =>
    r'6a6c18b150d749d0ab51cf5220e908a5af3ead58';

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

abstract class _$WorkoutCommentsController
    extends BuildlessAutoDisposeAsyncNotifier<WorkoutExerciseCommentsData> {
  late final String exerciseLogId;

  FutureOr<WorkoutExerciseCommentsData> build(String exerciseLogId);
}

/// Controller dạng family theo exerciseLogId
///
/// Dùng được cho:
/// - load comments
/// - add comment
/// - delete comment
///
/// Copied from [WorkoutCommentsController].
@ProviderFor(WorkoutCommentsController)
const workoutCommentsControllerProvider = WorkoutCommentsControllerFamily();

/// Controller dạng family theo exerciseLogId
///
/// Dùng được cho:
/// - load comments
/// - add comment
/// - delete comment
///
/// Copied from [WorkoutCommentsController].
class WorkoutCommentsControllerFamily
    extends Family<AsyncValue<WorkoutExerciseCommentsData>> {
  /// Controller dạng family theo exerciseLogId
  ///
  /// Dùng được cho:
  /// - load comments
  /// - add comment
  /// - delete comment
  ///
  /// Copied from [WorkoutCommentsController].
  const WorkoutCommentsControllerFamily();

  /// Controller dạng family theo exerciseLogId
  ///
  /// Dùng được cho:
  /// - load comments
  /// - add comment
  /// - delete comment
  ///
  /// Copied from [WorkoutCommentsController].
  WorkoutCommentsControllerProvider call(String exerciseLogId) {
    return WorkoutCommentsControllerProvider(exerciseLogId);
  }

  @override
  WorkoutCommentsControllerProvider getProviderOverride(
    covariant WorkoutCommentsControllerProvider provider,
  ) {
    return call(provider.exerciseLogId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'workoutCommentsControllerProvider';
}

/// Controller dạng family theo exerciseLogId
///
/// Dùng được cho:
/// - load comments
/// - add comment
/// - delete comment
///
/// Copied from [WorkoutCommentsController].
class WorkoutCommentsControllerProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          WorkoutCommentsController,
          WorkoutExerciseCommentsData
        > {
  /// Controller dạng family theo exerciseLogId
  ///
  /// Dùng được cho:
  /// - load comments
  /// - add comment
  /// - delete comment
  ///
  /// Copied from [WorkoutCommentsController].
  WorkoutCommentsControllerProvider(String exerciseLogId)
    : this._internal(
        () => WorkoutCommentsController()..exerciseLogId = exerciseLogId,
        from: workoutCommentsControllerProvider,
        name: r'workoutCommentsControllerProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$workoutCommentsControllerHash,
        dependencies: WorkoutCommentsControllerFamily._dependencies,
        allTransitiveDependencies:
            WorkoutCommentsControllerFamily._allTransitiveDependencies,
        exerciseLogId: exerciseLogId,
      );

  WorkoutCommentsControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.exerciseLogId,
  }) : super.internal();

  final String exerciseLogId;

  @override
  FutureOr<WorkoutExerciseCommentsData> runNotifierBuild(
    covariant WorkoutCommentsController notifier,
  ) {
    return notifier.build(exerciseLogId);
  }

  @override
  Override overrideWith(WorkoutCommentsController Function() create) {
    return ProviderOverride(
      origin: this,
      override: WorkoutCommentsControllerProvider._internal(
        () => create()..exerciseLogId = exerciseLogId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        exerciseLogId: exerciseLogId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    WorkoutCommentsController,
    WorkoutExerciseCommentsData
  >
  createElement() {
    return _WorkoutCommentsControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WorkoutCommentsControllerProvider &&
        other.exerciseLogId == exerciseLogId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, exerciseLogId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin WorkoutCommentsControllerRef
    on AutoDisposeAsyncNotifierProviderRef<WorkoutExerciseCommentsData> {
  /// The parameter `exerciseLogId` of this provider.
  String get exerciseLogId;
}

class _WorkoutCommentsControllerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          WorkoutCommentsController,
          WorkoutExerciseCommentsData
        >
    with WorkoutCommentsControllerRef {
  _WorkoutCommentsControllerProviderElement(super.provider);

  @override
  String get exerciseLogId =>
      (origin as WorkoutCommentsControllerProvider).exerciseLogId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
