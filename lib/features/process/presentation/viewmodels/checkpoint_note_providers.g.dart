// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkpoint_note_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$checkpointNoteServiceHash() =>
    r'f34005287ca263a070c9fb04025278df0f1c5bc5';

/// ===============================
/// SERVICE PROVIDER
/// ApiClient.fitness() đã được inject bên trong Service
/// ===============================
///
/// Copied from [checkpointNoteService].
@ProviderFor(checkpointNoteService)
final checkpointNoteServiceProvider =
    AutoDisposeProvider<CheckpointNoteService>.internal(
      checkpointNoteService,
      name: r'checkpointNoteServiceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$checkpointNoteServiceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CheckpointNoteServiceRef =
    AutoDisposeProviderRef<CheckpointNoteService>;
String _$checkpointNoteRepositoryHash() =>
    r'935d0afdd2cbe639c4850fb64241fa9bfb58f7e0';

/// ===============================
/// REPOSITORY PROVIDER
/// Repo sử dụng service ở trên
/// ===============================
///
/// Copied from [checkpointNoteRepository].
@ProviderFor(checkpointNoteRepository)
final checkpointNoteRepositoryProvider =
    AutoDisposeProvider<CheckpointNoteRepository>.internal(
      checkpointNoteRepository,
      name: r'checkpointNoteRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$checkpointNoteRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CheckpointNoteRepositoryRef =
    AutoDisposeProviderRef<CheckpointNoteRepository>;
String _$checkpointNoteControllerHash() =>
    r'85e9e31d736461d29c023a8919549a0808b84198';

/// ===============================
/// CONTROLLER — SUBMIT NOTE
/// Giống mutation: gọi API để lưu note
/// ===============================
///
/// Copied from [CheckpointNoteController].
@ProviderFor(CheckpointNoteController)
final checkpointNoteControllerProvider =
    AutoDisposeNotifierProvider<
      CheckpointNoteController,
      AsyncValue<void>
    >.internal(
      CheckpointNoteController.new,
      name: r'checkpointNoteControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$checkpointNoteControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CheckpointNoteController = AutoDisposeNotifier<AsyncValue<void>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
