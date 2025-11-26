// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_thread_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatThreadRepositoryHash() =>
    r'0788e82bd553bf0d3652ceec274789ae6c8d5f0f';

/// See also [chatThreadRepository].
@ProviderFor(chatThreadRepository)
final chatThreadRepositoryProvider =
    AutoDisposeProvider<ChatThreadRepository>.internal(
      chatThreadRepository,
      name: r'chatThreadRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$chatThreadRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ChatThreadRepositoryRef = AutoDisposeProviderRef<ChatThreadRepository>;
String _$chatThreadsHash() => r'7096a33f54f1ef415ffe46759018aa189394ab1a';

/// See also [chatThreads].
@ProviderFor(chatThreads)
final chatThreadsProvider =
    AutoDisposeFutureProvider<List<ChatThread>>.internal(
      chatThreads,
      name: r'chatThreadsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$chatThreadsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ChatThreadsRef = AutoDisposeFutureProviderRef<List<ChatThread>>;
String _$createChatThreadHash() => r'4f290d425f457cfbce44dc247c289f6594213dc4';

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

/// See also [createChatThread].
@ProviderFor(createChatThread)
const createChatThreadProvider = CreateChatThreadFamily();

/// See also [createChatThread].
class CreateChatThreadFamily extends Family<AsyncValue<CreateChatThreadData>> {
  /// See also [createChatThread].
  const CreateChatThreadFamily();

  /// See also [createChatThread].
  CreateChatThreadProvider call({
    String? title,
    String threadType = 'fitness',
  }) {
    return CreateChatThreadProvider(title: title, threadType: threadType);
  }

  @override
  CreateChatThreadProvider getProviderOverride(
    covariant CreateChatThreadProvider provider,
  ) {
    return call(title: provider.title, threadType: provider.threadType);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'createChatThreadProvider';
}

/// See also [createChatThread].
class CreateChatThreadProvider
    extends AutoDisposeFutureProvider<CreateChatThreadData> {
  /// See also [createChatThread].
  CreateChatThreadProvider({String? title, String threadType = 'fitness'})
    : this._internal(
        (ref) => createChatThread(
          ref as CreateChatThreadRef,
          title: title,
          threadType: threadType,
        ),
        from: createChatThreadProvider,
        name: r'createChatThreadProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$createChatThreadHash,
        dependencies: CreateChatThreadFamily._dependencies,
        allTransitiveDependencies:
            CreateChatThreadFamily._allTransitiveDependencies,
        title: title,
        threadType: threadType,
      );

  CreateChatThreadProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.title,
    required this.threadType,
  }) : super.internal();

  final String? title;
  final String threadType;

  @override
  Override overrideWith(
    FutureOr<CreateChatThreadData> Function(CreateChatThreadRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CreateChatThreadProvider._internal(
        (ref) => create(ref as CreateChatThreadRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        title: title,
        threadType: threadType,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<CreateChatThreadData> createElement() {
    return _CreateChatThreadProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CreateChatThreadProvider &&
        other.title == title &&
        other.threadType == threadType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, title.hashCode);
    hash = _SystemHash.combine(hash, threadType.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CreateChatThreadRef
    on AutoDisposeFutureProviderRef<CreateChatThreadData> {
  /// The parameter `title` of this provider.
  String? get title;

  /// The parameter `threadType` of this provider.
  String get threadType;
}

class _CreateChatThreadProviderElement
    extends AutoDisposeFutureProviderElement<CreateChatThreadData>
    with CreateChatThreadRef {
  _CreateChatThreadProviderElement(super.provider);

  @override
  String? get title => (origin as CreateChatThreadProvider).title;
  @override
  String get threadType => (origin as CreateChatThreadProvider).threadType;
}

String _$sendChatMessageHash() => r'e92b8ea0585835c5a06e2727702f4b08e50f2dfc';

/// See also [sendChatMessage].
@ProviderFor(sendChatMessage)
const sendChatMessageProvider = SendChatMessageFamily();

/// See also [sendChatMessage].
class SendChatMessageFamily extends Family<AsyncValue<ChatMessage>> {
  /// See also [sendChatMessage].
  const SendChatMessageFamily();

  /// See also [sendChatMessage].
  SendChatMessageProvider call({
    required String threadId,
    required String content,
    String role = 'user',
    String? data,
  }) {
    return SendChatMessageProvider(
      threadId: threadId,
      content: content,
      role: role,
      data: data,
    );
  }

  @override
  SendChatMessageProvider getProviderOverride(
    covariant SendChatMessageProvider provider,
  ) {
    return call(
      threadId: provider.threadId,
      content: provider.content,
      role: provider.role,
      data: provider.data,
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
  String? get name => r'sendChatMessageProvider';
}

/// See also [sendChatMessage].
class SendChatMessageProvider extends AutoDisposeFutureProvider<ChatMessage> {
  /// See also [sendChatMessage].
  SendChatMessageProvider({
    required String threadId,
    required String content,
    String role = 'user',
    String? data,
  }) : this._internal(
         (ref) => sendChatMessage(
           ref as SendChatMessageRef,
           threadId: threadId,
           content: content,
           role: role,
           data: data,
         ),
         from: sendChatMessageProvider,
         name: r'sendChatMessageProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$sendChatMessageHash,
         dependencies: SendChatMessageFamily._dependencies,
         allTransitiveDependencies:
             SendChatMessageFamily._allTransitiveDependencies,
         threadId: threadId,
         content: content,
         role: role,
         data: data,
       );

  SendChatMessageProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.threadId,
    required this.content,
    required this.role,
    required this.data,
  }) : super.internal();

  final String threadId;
  final String content;
  final String role;
  final String? data;

  @override
  Override overrideWith(
    FutureOr<ChatMessage> Function(SendChatMessageRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SendChatMessageProvider._internal(
        (ref) => create(ref as SendChatMessageRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        threadId: threadId,
        content: content,
        role: role,
        data: data,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ChatMessage> createElement() {
    return _SendChatMessageProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SendChatMessageProvider &&
        other.threadId == threadId &&
        other.content == content &&
        other.role == role &&
        other.data == data;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, threadId.hashCode);
    hash = _SystemHash.combine(hash, content.hashCode);
    hash = _SystemHash.combine(hash, role.hashCode);
    hash = _SystemHash.combine(hash, data.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SendChatMessageRef on AutoDisposeFutureProviderRef<ChatMessage> {
  /// The parameter `threadId` of this provider.
  String get threadId;

  /// The parameter `content` of this provider.
  String get content;

  /// The parameter `role` of this provider.
  String get role;

  /// The parameter `data` of this provider.
  String? get data;
}

class _SendChatMessageProviderElement
    extends AutoDisposeFutureProviderElement<ChatMessage>
    with SendChatMessageRef {
  _SendChatMessageProviderElement(super.provider);

  @override
  String get threadId => (origin as SendChatMessageProvider).threadId;
  @override
  String get content => (origin as SendChatMessageProvider).content;
  @override
  String get role => (origin as SendChatMessageProvider).role;
  @override
  String? get data => (origin as SendChatMessageProvider).data;
}

String _$threadMessagesHash() => r'e0c460a829eb1b34b66796ccc1943f03e2e3248d';

/// =======================
/// GET messages của 1 thread
/// =======================
///
/// Copied from [threadMessages].
@ProviderFor(threadMessages)
const threadMessagesProvider = ThreadMessagesFamily();

/// =======================
/// GET messages của 1 thread
/// =======================
///
/// Copied from [threadMessages].
class ThreadMessagesFamily extends Family<AsyncValue<List<ChatMessage>>> {
  /// =======================
  /// GET messages của 1 thread
  /// =======================
  ///
  /// Copied from [threadMessages].
  const ThreadMessagesFamily();

  /// =======================
  /// GET messages của 1 thread
  /// =======================
  ///
  /// Copied from [threadMessages].
  ThreadMessagesProvider call({required String threadId}) {
    return ThreadMessagesProvider(threadId: threadId);
  }

  @override
  ThreadMessagesProvider getProviderOverride(
    covariant ThreadMessagesProvider provider,
  ) {
    return call(threadId: provider.threadId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'threadMessagesProvider';
}

/// =======================
/// GET messages của 1 thread
/// =======================
///
/// Copied from [threadMessages].
class ThreadMessagesProvider
    extends AutoDisposeFutureProvider<List<ChatMessage>> {
  /// =======================
  /// GET messages của 1 thread
  /// =======================
  ///
  /// Copied from [threadMessages].
  ThreadMessagesProvider({required String threadId})
    : this._internal(
        (ref) => threadMessages(ref as ThreadMessagesRef, threadId: threadId),
        from: threadMessagesProvider,
        name: r'threadMessagesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$threadMessagesHash,
        dependencies: ThreadMessagesFamily._dependencies,
        allTransitiveDependencies:
            ThreadMessagesFamily._allTransitiveDependencies,
        threadId: threadId,
      );

  ThreadMessagesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.threadId,
  }) : super.internal();

  final String threadId;

  @override
  Override overrideWith(
    FutureOr<List<ChatMessage>> Function(ThreadMessagesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ThreadMessagesProvider._internal(
        (ref) => create(ref as ThreadMessagesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        threadId: threadId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ChatMessage>> createElement() {
    return _ThreadMessagesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ThreadMessagesProvider && other.threadId == threadId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, threadId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ThreadMessagesRef on AutoDisposeFutureProviderRef<List<ChatMessage>> {
  /// The parameter `threadId` of this provider.
  String get threadId;
}

class _ThreadMessagesProviderElement
    extends AutoDisposeFutureProviderElement<List<ChatMessage>>
    with ThreadMessagesRef {
  _ThreadMessagesProviderElement(super.provider);

  @override
  String get threadId => (origin as ThreadMessagesProvider).threadId;
}

String _$mealPlanGenerateHash() => r'd631bd9a16db8b91c7a6f3fd2739a25977b29e26';

/// See also [mealPlanGenerate].
@ProviderFor(mealPlanGenerate)
final mealPlanGenerateProvider =
    FutureProvider<MealPlanGenerateResponse>.internal(
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
typedef MealPlanGenerateRef = FutureProviderRef<MealPlanGenerateResponse>;
String _$mealPlanDailyMealsHash() =>
    r'd96e85f355cd528bc199d1f69e711fa29d274d21';

/// See also [mealPlanDailyMeals].
@ProviderFor(mealPlanDailyMeals)
final mealPlanDailyMealsProvider = FutureProvider<List<DailyMealPlan>>.internal(
  mealPlanDailyMeals,
  name: r'mealPlanDailyMealsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mealPlanDailyMealsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MealPlanDailyMealsRef = FutureProviderRef<List<DailyMealPlan>>;
String _$workoutPlanGenerateHash() =>
    r'b189a8f697b893a4a661b267d46217f9bfcb6e62';

/// See also [workoutPlanGenerate].
@ProviderFor(workoutPlanGenerate)
final workoutPlanGenerateProvider =
    FutureProvider<WorkoutPlanGenerateResponse>.internal(
      workoutPlanGenerate,
      name: r'workoutPlanGenerateProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$workoutPlanGenerateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WorkoutPlanGenerateRef = FutureProviderRef<WorkoutPlanGenerateResponse>;
String _$workoutPlanDaysHash() => r'3ca835029d7044cc1f389bdc6fb2865dc4b13c4a';

/// Chỉ cần danh sách các ngày (dayNumber, sessionName, exercises)
///
/// Copied from [workoutPlanDays].
@ProviderFor(workoutPlanDays)
final workoutPlanDaysProvider = FutureProvider<List<WorkoutPlanDay>>.internal(
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
typedef WorkoutPlanDaysRef = FutureProviderRef<List<WorkoutPlanDay>>;
String _$aiHealthPlanCreateControllerHash() =>
    r'43fed9cff8462a81072e66a4fbc77c4ee4110d2b';

/// =======================
/// SAVE AI HEALTH PLAN
/// =======================
/// - Gọi khi ChatMessage.data (ChatMessageMeta) != null
/// - UI có thể watch để hiện loading banner
///
/// Copied from [AiHealthPlanCreateController].
@ProviderFor(AiHealthPlanCreateController)
final aiHealthPlanCreateControllerProvider =
    AutoDisposeNotifierProvider<
      AiHealthPlanCreateController,
      AsyncValue<void>
    >.internal(
      AiHealthPlanCreateController.new,
      name: r'aiHealthPlanCreateControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$aiHealthPlanCreateControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AiHealthPlanCreateController = AutoDisposeNotifier<AsyncValue<void>>;
String _$workoutPlanSaveAllControllerHash() =>
    r'ba9f3629b9d445074d0fd907acfb6d10f796cf14';

/// See also [WorkoutPlanSaveAllController].
@ProviderFor(WorkoutPlanSaveAllController)
final workoutPlanSaveAllControllerProvider =
    AutoDisposeNotifierProvider<
      WorkoutPlanSaveAllController,
      AsyncValue<WorkoutPlanSaveAllResponse?>
    >.internal(
      WorkoutPlanSaveAllController.new,
      name: r'workoutPlanSaveAllControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$workoutPlanSaveAllControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$WorkoutPlanSaveAllController =
    AutoDisposeNotifier<AsyncValue<WorkoutPlanSaveAllResponse?>>;
String _$mealPlanSaveBatchControllerHash() =>
    r'baeb81cdd9aaa278a201073a1317010bb6926d1c';

/// See also [MealPlanSaveBatchController].
@ProviderFor(MealPlanSaveBatchController)
final mealPlanSaveBatchControllerProvider =
    AutoDisposeNotifierProvider<
      MealPlanSaveBatchController,
      AsyncValue<MealPlanSaveBatchResponse?>
    >.internal(
      MealPlanSaveBatchController.new,
      name: r'mealPlanSaveBatchControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$mealPlanSaveBatchControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$MealPlanSaveBatchController =
    AutoDisposeNotifier<AsyncValue<MealPlanSaveBatchResponse?>>;
String _$aiHealthPlanActivateControllerHash() =>
    r'e6f0359848b2efc3e1c4ff2b7a18aff4a25c6a9e';

/// See also [AiHealthPlanActivateController].
@ProviderFor(AiHealthPlanActivateController)
final aiHealthPlanActivateControllerProvider =
    AutoDisposeNotifierProvider<
      AiHealthPlanActivateController,
      AsyncValue<AiHealthPlanActivateResponse?>
    >.internal(
      AiHealthPlanActivateController.new,
      name: r'aiHealthPlanActivateControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$aiHealthPlanActivateControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AiHealthPlanActivateController =
    AutoDisposeNotifier<AsyncValue<AiHealthPlanActivateResponse?>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
