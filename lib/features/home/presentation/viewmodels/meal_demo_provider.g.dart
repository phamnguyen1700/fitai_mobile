// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_demo_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mealDemoRepositoryHash() =>
    r'5d6e744f08b5b403b2d5e4334f27c6d253ea76a3';

/// Repo provider
///
/// Copied from [mealDemoRepository].
@ProviderFor(mealDemoRepository)
final mealDemoRepositoryProvider =
    AutoDisposeProvider<MealDemoRepository>.internal(
      mealDemoRepository,
      name: r'mealDemoRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$mealDemoRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MealDemoRepositoryRef = AutoDisposeProviderRef<MealDemoRepository>;
String _$mealDemoListHash() => r'd8e0918ab9d6ffe7492d2f0c43471c394ab2d8bd';

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

/// See also [mealDemoList].
@ProviderFor(mealDemoList)
const mealDemoListProvider = MealDemoListFamily();

/// See also [mealDemoList].
class MealDemoListFamily extends Family<AsyncValue<MealDemoListResponse>> {
  /// See also [mealDemoList].
  const MealDemoListFamily();

  /// See also [mealDemoList].
  MealDemoListProvider call({
    int pageNumber = 1,
    int pageSize = 15,
    bool? isDeleted,
  }) {
    return MealDemoListProvider(
      pageNumber: pageNumber,
      pageSize: pageSize,
      isDeleted: isDeleted,
    );
  }

  @override
  MealDemoListProvider getProviderOverride(
    covariant MealDemoListProvider provider,
  ) {
    return call(
      pageNumber: provider.pageNumber,
      pageSize: provider.pageSize,
      isDeleted: provider.isDeleted,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'mealDemoListProvider';
}

/// See also [mealDemoList].
class MealDemoListProvider
    extends AutoDisposeFutureProvider<MealDemoListResponse> {
  /// See also [mealDemoList].
  MealDemoListProvider({int pageNumber = 1, int pageSize = 15, bool? isDeleted})
    : this._internal(
        (ref) => mealDemoList(
          ref as MealDemoListRef,
          pageNumber: pageNumber,
          pageSize: pageSize,
          isDeleted: isDeleted,
        ),
        from: mealDemoListProvider,
        name: r'mealDemoListProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$mealDemoListHash,
        dependencies: MealDemoListFamily._dependencies,
        allTransitiveDependencies:
            MealDemoListFamily._allTransitiveDependencies,
        pageNumber: pageNumber,
        pageSize: pageSize,
        isDeleted: isDeleted,
      );

  MealDemoListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.pageNumber,
    required this.pageSize,
    required this.isDeleted,
  }) : super.internal();

  final int pageNumber;
  final int pageSize;
  final bool? isDeleted;

  @override
  Override overrideWith(
    FutureOr<MealDemoListResponse> Function(MealDemoListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MealDemoListProvider._internal(
        (ref) => create(ref as MealDemoListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        pageNumber: pageNumber,
        pageSize: pageSize,
        isDeleted: isDeleted,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<MealDemoListResponse> createElement() {
    return _MealDemoListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MealDemoListProvider &&
        other.pageNumber == pageNumber &&
        other.pageSize == pageSize &&
        other.isDeleted == isDeleted;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pageNumber.hashCode);
    hash = _SystemHash.combine(hash, pageSize.hashCode);
    hash = _SystemHash.combine(hash, isDeleted.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MealDemoListRef on AutoDisposeFutureProviderRef<MealDemoListResponse> {
  /// The parameter `pageNumber` of this provider.
  int get pageNumber;

  /// The parameter `pageSize` of this provider.
  int get pageSize;

  /// The parameter `isDeleted` of this provider.
  bool? get isDeleted;
}

class _MealDemoListProviderElement
    extends AutoDisposeFutureProviderElement<MealDemoListResponse>
    with MealDemoListRef {
  _MealDemoListProviderElement(super.provider);

  @override
  int get pageNumber => (origin as MealDemoListProvider).pageNumber;
  @override
  int get pageSize => (origin as MealDemoListProvider).pageSize;
  @override
  bool? get isDeleted => (origin as MealDemoListProvider).isDeleted;
}

String _$mealDemoItemsHash() => r'791dd18c2dfeb354b4ce17ca159e6ca11c10630b';

/// See also [mealDemoItems].
@ProviderFor(mealDemoItems)
const mealDemoItemsProvider = MealDemoItemsFamily();

/// See also [mealDemoItems].
class MealDemoItemsFamily extends Family<AsyncValue<List<MealDemo>>> {
  /// See also [mealDemoItems].
  const MealDemoItemsFamily();

  /// See also [mealDemoItems].
  MealDemoItemsProvider call({
    int pageNumber = 1,
    int pageSize = 15,
    bool? isDeleted,
  }) {
    return MealDemoItemsProvider(
      pageNumber: pageNumber,
      pageSize: pageSize,
      isDeleted: isDeleted,
    );
  }

  @override
  MealDemoItemsProvider getProviderOverride(
    covariant MealDemoItemsProvider provider,
  ) {
    return call(
      pageNumber: provider.pageNumber,
      pageSize: provider.pageSize,
      isDeleted: provider.isDeleted,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'mealDemoItemsProvider';
}

/// See also [mealDemoItems].
class MealDemoItemsProvider extends AutoDisposeFutureProvider<List<MealDemo>> {
  /// See also [mealDemoItems].
  MealDemoItemsProvider({
    int pageNumber = 1,
    int pageSize = 15,
    bool? isDeleted,
  }) : this._internal(
         (ref) => mealDemoItems(
           ref as MealDemoItemsRef,
           pageNumber: pageNumber,
           pageSize: pageSize,
           isDeleted: isDeleted,
         ),
         from: mealDemoItemsProvider,
         name: r'mealDemoItemsProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$mealDemoItemsHash,
         dependencies: MealDemoItemsFamily._dependencies,
         allTransitiveDependencies:
             MealDemoItemsFamily._allTransitiveDependencies,
         pageNumber: pageNumber,
         pageSize: pageSize,
         isDeleted: isDeleted,
       );

  MealDemoItemsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.pageNumber,
    required this.pageSize,
    required this.isDeleted,
  }) : super.internal();

  final int pageNumber;
  final int pageSize;
  final bool? isDeleted;

  @override
  Override overrideWith(
    FutureOr<List<MealDemo>> Function(MealDemoItemsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MealDemoItemsProvider._internal(
        (ref) => create(ref as MealDemoItemsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        pageNumber: pageNumber,
        pageSize: pageSize,
        isDeleted: isDeleted,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<MealDemo>> createElement() {
    return _MealDemoItemsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MealDemoItemsProvider &&
        other.pageNumber == pageNumber &&
        other.pageSize == pageSize &&
        other.isDeleted == isDeleted;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pageNumber.hashCode);
    hash = _SystemHash.combine(hash, pageSize.hashCode);
    hash = _SystemHash.combine(hash, isDeleted.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MealDemoItemsRef on AutoDisposeFutureProviderRef<List<MealDemo>> {
  /// The parameter `pageNumber` of this provider.
  int get pageNumber;

  /// The parameter `pageSize` of this provider.
  int get pageSize;

  /// The parameter `isDeleted` of this provider.
  bool? get isDeleted;
}

class _MealDemoItemsProviderElement
    extends AutoDisposeFutureProviderElement<List<MealDemo>>
    with MealDemoItemsRef {
  _MealDemoItemsProviderElement(super.provider);

  @override
  int get pageNumber => (origin as MealDemoItemsProvider).pageNumber;
  @override
  int get pageSize => (origin as MealDemoItemsProvider).pageSize;
  @override
  bool? get isDeleted => (origin as MealDemoItemsProvider).isDeleted;
}

String _$mealDemoDetailHash() => r'e6ec4d661f0eb352d8d64f37bd666cfa282a3971';

/// Lấy chi tiết 1 meal demo (response đầy đủ)
///
/// Copied from [mealDemoDetail].
@ProviderFor(mealDemoDetail)
const mealDemoDetailProvider = MealDemoDetailFamily();

/// Lấy chi tiết 1 meal demo (response đầy đủ)
///
/// Copied from [mealDemoDetail].
class MealDemoDetailFamily extends Family<AsyncValue<MealDemoDetailResponse>> {
  /// Lấy chi tiết 1 meal demo (response đầy đủ)
  ///
  /// Copied from [mealDemoDetail].
  const MealDemoDetailFamily();

  /// Lấy chi tiết 1 meal demo (response đầy đủ)
  ///
  /// Copied from [mealDemoDetail].
  MealDemoDetailProvider call(String mealDemoId) {
    return MealDemoDetailProvider(mealDemoId);
  }

  @override
  MealDemoDetailProvider getProviderOverride(
    covariant MealDemoDetailProvider provider,
  ) {
    return call(provider.mealDemoId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'mealDemoDetailProvider';
}

/// Lấy chi tiết 1 meal demo (response đầy đủ)
///
/// Copied from [mealDemoDetail].
class MealDemoDetailProvider
    extends AutoDisposeFutureProvider<MealDemoDetailResponse> {
  /// Lấy chi tiết 1 meal demo (response đầy đủ)
  ///
  /// Copied from [mealDemoDetail].
  MealDemoDetailProvider(String mealDemoId)
    : this._internal(
        (ref) => mealDemoDetail(ref as MealDemoDetailRef, mealDemoId),
        from: mealDemoDetailProvider,
        name: r'mealDemoDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$mealDemoDetailHash,
        dependencies: MealDemoDetailFamily._dependencies,
        allTransitiveDependencies:
            MealDemoDetailFamily._allTransitiveDependencies,
        mealDemoId: mealDemoId,
      );

  MealDemoDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mealDemoId,
  }) : super.internal();

  final String mealDemoId;

  @override
  Override overrideWith(
    FutureOr<MealDemoDetailResponse> Function(MealDemoDetailRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MealDemoDetailProvider._internal(
        (ref) => create(ref as MealDemoDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mealDemoId: mealDemoId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<MealDemoDetailResponse> createElement() {
    return _MealDemoDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MealDemoDetailProvider && other.mealDemoId == mealDemoId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mealDemoId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MealDemoDetailRef
    on AutoDisposeFutureProviderRef<MealDemoDetailResponse> {
  /// The parameter `mealDemoId` of this provider.
  String get mealDemoId;
}

class _MealDemoDetailProviderElement
    extends AutoDisposeFutureProviderElement<MealDemoDetailResponse>
    with MealDemoDetailRef {
  _MealDemoDetailProviderElement(super.provider);

  @override
  String get mealDemoId => (origin as MealDemoDetailProvider).mealDemoId;
}

String _$mealDemoMenusHash() => r'ce58cb0d7982be78e7d09ca871b27872ae29d6f2';

/// Lấy list menu (MealDemoDetail) theo mealDemoId
///
/// Copied from [mealDemoMenus].
@ProviderFor(mealDemoMenus)
const mealDemoMenusProvider = MealDemoMenusFamily();

/// Lấy list menu (MealDemoDetail) theo mealDemoId
///
/// Copied from [mealDemoMenus].
class MealDemoMenusFamily extends Family<AsyncValue<List<MealDemoDetail>>> {
  /// Lấy list menu (MealDemoDetail) theo mealDemoId
  ///
  /// Copied from [mealDemoMenus].
  const MealDemoMenusFamily();

  /// Lấy list menu (MealDemoDetail) theo mealDemoId
  ///
  /// Copied from [mealDemoMenus].
  MealDemoMenusProvider call(String mealDemoId) {
    return MealDemoMenusProvider(mealDemoId);
  }

  @override
  MealDemoMenusProvider getProviderOverride(
    covariant MealDemoMenusProvider provider,
  ) {
    return call(provider.mealDemoId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'mealDemoMenusProvider';
}

/// Lấy list menu (MealDemoDetail) theo mealDemoId
///
/// Copied from [mealDemoMenus].
class MealDemoMenusProvider
    extends AutoDisposeFutureProvider<List<MealDemoDetail>> {
  /// Lấy list menu (MealDemoDetail) theo mealDemoId
  ///
  /// Copied from [mealDemoMenus].
  MealDemoMenusProvider(String mealDemoId)
    : this._internal(
        (ref) => mealDemoMenus(ref as MealDemoMenusRef, mealDemoId),
        from: mealDemoMenusProvider,
        name: r'mealDemoMenusProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$mealDemoMenusHash,
        dependencies: MealDemoMenusFamily._dependencies,
        allTransitiveDependencies:
            MealDemoMenusFamily._allTransitiveDependencies,
        mealDemoId: mealDemoId,
      );

  MealDemoMenusProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mealDemoId,
  }) : super.internal();

  final String mealDemoId;

  @override
  Override overrideWith(
    FutureOr<List<MealDemoDetail>> Function(MealDemoMenusRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MealDemoMenusProvider._internal(
        (ref) => create(ref as MealDemoMenusRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mealDemoId: mealDemoId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<MealDemoDetail>> createElement() {
    return _MealDemoMenusProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MealDemoMenusProvider && other.mealDemoId == mealDemoId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mealDemoId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MealDemoMenusRef on AutoDisposeFutureProviderRef<List<MealDemoDetail>> {
  /// The parameter `mealDemoId` of this provider.
  String get mealDemoId;
}

class _MealDemoMenusProviderElement
    extends AutoDisposeFutureProviderElement<List<MealDemoDetail>>
    with MealDemoMenusRef {
  _MealDemoMenusProviderElement(super.provider);

  @override
  String get mealDemoId => (origin as MealDemoMenusProvider).mealDemoId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
