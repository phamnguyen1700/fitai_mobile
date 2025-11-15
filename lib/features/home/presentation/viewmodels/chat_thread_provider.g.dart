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

String _$sendChatMessageHash() => r'e5d19a82c75d6317037925a419fffc52da8fea6e';

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
    String role = 'customer',
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
    String role = 'customer',
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

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
