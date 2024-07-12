// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'words_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$wordsControllerHash() => r'8a35cbea5e76d2d5ef17bd3120dca26a848c5204';

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

abstract class _$WordsController extends BuildlessAsyncNotifier<List<Word>> {
  late final String langCode;

  FutureOr<List<Word>> build(
    String langCode,
  );
}

/// See also [WordsController].
@ProviderFor(WordsController)
const wordsControllerProvider = WordsControllerFamily();

/// See also [WordsController].
class WordsControllerFamily extends Family<AsyncValue<List<Word>>> {
  /// See also [WordsController].
  const WordsControllerFamily();

  /// See also [WordsController].
  WordsControllerProvider call(
    String langCode,
  ) {
    return WordsControllerProvider(
      langCode,
    );
  }

  @override
  WordsControllerProvider getProviderOverride(
    covariant WordsControllerProvider provider,
  ) {
    return call(
      provider.langCode,
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
  String? get name => r'wordsControllerProvider';
}

/// See also [WordsController].
class WordsControllerProvider
    extends AsyncNotifierProviderImpl<WordsController, List<Word>> {
  /// See also [WordsController].
  WordsControllerProvider(
    String langCode,
  ) : this._internal(
          () => WordsController()..langCode = langCode,
          from: wordsControllerProvider,
          name: r'wordsControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$wordsControllerHash,
          dependencies: WordsControllerFamily._dependencies,
          allTransitiveDependencies:
              WordsControllerFamily._allTransitiveDependencies,
          langCode: langCode,
        );

  WordsControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.langCode,
  }) : super.internal();

  final String langCode;

  @override
  FutureOr<List<Word>> runNotifierBuild(
    covariant WordsController notifier,
  ) {
    return notifier.build(
      langCode,
    );
  }

  @override
  Override overrideWith(WordsController Function() create) {
    return ProviderOverride(
      origin: this,
      override: WordsControllerProvider._internal(
        () => create()..langCode = langCode,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        langCode: langCode,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<WordsController, List<Word>> createElement() {
    return _WordsControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WordsControllerProvider && other.langCode == langCode;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, langCode.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin WordsControllerRef on AsyncNotifierProviderRef<List<Word>> {
  /// The parameter `langCode` of this provider.
  String get langCode;
}

class _WordsControllerProviderElement
    extends AsyncNotifierProviderElement<WordsController, List<Word>>
    with WordsControllerRef {
  _WordsControllerProviderElement(super.provider);

  @override
  String get langCode => (origin as WordsControllerProvider).langCode;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
