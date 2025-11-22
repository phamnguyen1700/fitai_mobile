// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_photo_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mealPhotoRepositoryHash() =>
    r'c396fd586a59f6c81dc895d3c44efe13289855d5';

/// Repo provider – dùng chung toàn app
///
/// Copied from [mealPhotoRepository].
@ProviderFor(mealPhotoRepository)
final mealPhotoRepositoryProvider =
    AutoDisposeProvider<MealPhotoRepository>.internal(
      mealPhotoRepository,
      name: r'mealPhotoRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$mealPhotoRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MealPhotoRepositoryRef = AutoDisposeProviderRef<MealPhotoRepository>;
String _$uploadMealPhotoControllerHash() =>
    r'cefd4ba2c05e970a03ebb75ff4424d00a391cfa9';

/// Controller upload ảnh + mark-completed
///
/// - state: AsyncValue<UploadMealPhotoResponse?>
///   + null: chưa upload
///   + loading: đang upload
///   + data: kết quả trả về từ API
///   + error: lỗi khi upload/mark
///
/// Copied from [UploadMealPhotoController].
@ProviderFor(UploadMealPhotoController)
final uploadMealPhotoControllerProvider =
    AutoDisposeNotifierProvider<
      UploadMealPhotoController,
      AsyncValue<UploadMealPhotoResponse?>
    >.internal(
      UploadMealPhotoController.new,
      name: r'uploadMealPhotoControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$uploadMealPhotoControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$UploadMealPhotoController =
    AutoDisposeNotifier<AsyncValue<UploadMealPhotoResponse?>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
