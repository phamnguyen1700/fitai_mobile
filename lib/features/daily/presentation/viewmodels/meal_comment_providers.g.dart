// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_comment_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mealCommentRepositoryHash() =>
    r'35a30aab288baf08ce161537c2e76b9f88359df6';

/// Provider cho repository (dùng port fitness)
///
/// Copied from [mealCommentRepository].
@ProviderFor(mealCommentRepository)
final mealCommentRepositoryProvider =
    AutoDisposeProvider<MealCommentRepository>.internal(
      mealCommentRepository,
      name: r'mealCommentRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$mealCommentRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MealCommentRepositoryRef =
    AutoDisposeProviderRef<MealCommentRepository>;
String _$mealCommentsControllerHash() =>
    r'150ec8857c677c74f43aca2a574a2fe70a423737';

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

abstract class _$MealCommentsController
    extends BuildlessAutoDisposeAsyncNotifier<MealCommentsData> {
  late final String mealLogId;

  FutureOr<MealCommentsData> build(String mealLogId);
}

/// Controller dạng family theo mealLogId
///
/// Dùng được cho cả:
/// - load comments
/// - add comment
/// - delete comment
///
/// Cách dùng:
/// ```dart
/// final state = ref.watch(mealCommentsControllerProvider(mealLogId));
/// // state: AsyncValue<MealCommentsData>
/// ```
///
/// Gọi action:
/// ```dart
/// ref
///   .read(mealCommentsControllerProvider(mealLogId).notifier)
///   .addComment("Hello");
/// ```
///
/// Copied from [MealCommentsController].
@ProviderFor(MealCommentsController)
const mealCommentsControllerProvider = MealCommentsControllerFamily();

/// Controller dạng family theo mealLogId
///
/// Dùng được cho cả:
/// - load comments
/// - add comment
/// - delete comment
///
/// Cách dùng:
/// ```dart
/// final state = ref.watch(mealCommentsControllerProvider(mealLogId));
/// // state: AsyncValue<MealCommentsData>
/// ```
///
/// Gọi action:
/// ```dart
/// ref
///   .read(mealCommentsControllerProvider(mealLogId).notifier)
///   .addComment("Hello");
/// ```
///
/// Copied from [MealCommentsController].
class MealCommentsControllerFamily
    extends Family<AsyncValue<MealCommentsData>> {
  /// Controller dạng family theo mealLogId
  ///
  /// Dùng được cho cả:
  /// - load comments
  /// - add comment
  /// - delete comment
  ///
  /// Cách dùng:
  /// ```dart
  /// final state = ref.watch(mealCommentsControllerProvider(mealLogId));
  /// // state: AsyncValue<MealCommentsData>
  /// ```
  ///
  /// Gọi action:
  /// ```dart
  /// ref
  ///   .read(mealCommentsControllerProvider(mealLogId).notifier)
  ///   .addComment("Hello");
  /// ```
  ///
  /// Copied from [MealCommentsController].
  const MealCommentsControllerFamily();

  /// Controller dạng family theo mealLogId
  ///
  /// Dùng được cho cả:
  /// - load comments
  /// - add comment
  /// - delete comment
  ///
  /// Cách dùng:
  /// ```dart
  /// final state = ref.watch(mealCommentsControllerProvider(mealLogId));
  /// // state: AsyncValue<MealCommentsData>
  /// ```
  ///
  /// Gọi action:
  /// ```dart
  /// ref
  ///   .read(mealCommentsControllerProvider(mealLogId).notifier)
  ///   .addComment("Hello");
  /// ```
  ///
  /// Copied from [MealCommentsController].
  MealCommentsControllerProvider call(String mealLogId) {
    return MealCommentsControllerProvider(mealLogId);
  }

  @override
  MealCommentsControllerProvider getProviderOverride(
    covariant MealCommentsControllerProvider provider,
  ) {
    return call(provider.mealLogId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'mealCommentsControllerProvider';
}

/// Controller dạng family theo mealLogId
///
/// Dùng được cho cả:
/// - load comments
/// - add comment
/// - delete comment
///
/// Cách dùng:
/// ```dart
/// final state = ref.watch(mealCommentsControllerProvider(mealLogId));
/// // state: AsyncValue<MealCommentsData>
/// ```
///
/// Gọi action:
/// ```dart
/// ref
///   .read(mealCommentsControllerProvider(mealLogId).notifier)
///   .addComment("Hello");
/// ```
///
/// Copied from [MealCommentsController].
class MealCommentsControllerProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          MealCommentsController,
          MealCommentsData
        > {
  /// Controller dạng family theo mealLogId
  ///
  /// Dùng được cho cả:
  /// - load comments
  /// - add comment
  /// - delete comment
  ///
  /// Cách dùng:
  /// ```dart
  /// final state = ref.watch(mealCommentsControllerProvider(mealLogId));
  /// // state: AsyncValue<MealCommentsData>
  /// ```
  ///
  /// Gọi action:
  /// ```dart
  /// ref
  ///   .read(mealCommentsControllerProvider(mealLogId).notifier)
  ///   .addComment("Hello");
  /// ```
  ///
  /// Copied from [MealCommentsController].
  MealCommentsControllerProvider(String mealLogId)
    : this._internal(
        () => MealCommentsController()..mealLogId = mealLogId,
        from: mealCommentsControllerProvider,
        name: r'mealCommentsControllerProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$mealCommentsControllerHash,
        dependencies: MealCommentsControllerFamily._dependencies,
        allTransitiveDependencies:
            MealCommentsControllerFamily._allTransitiveDependencies,
        mealLogId: mealLogId,
      );

  MealCommentsControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mealLogId,
  }) : super.internal();

  final String mealLogId;

  @override
  FutureOr<MealCommentsData> runNotifierBuild(
    covariant MealCommentsController notifier,
  ) {
    return notifier.build(mealLogId);
  }

  @override
  Override overrideWith(MealCommentsController Function() create) {
    return ProviderOverride(
      origin: this,
      override: MealCommentsControllerProvider._internal(
        () => create()..mealLogId = mealLogId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mealLogId: mealLogId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    MealCommentsController,
    MealCommentsData
  >
  createElement() {
    return _MealCommentsControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MealCommentsControllerProvider &&
        other.mealLogId == mealLogId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mealLogId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MealCommentsControllerRef
    on AutoDisposeAsyncNotifierProviderRef<MealCommentsData> {
  /// The parameter `mealLogId` of this provider.
  String get mealLogId;
}

class _MealCommentsControllerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          MealCommentsController,
          MealCommentsData
        >
    with MealCommentsControllerRef {
  _MealCommentsControllerProviderElement(super.provider);

  @override
  String get mealLogId => (origin as MealCommentsControllerProvider).mealLogId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
