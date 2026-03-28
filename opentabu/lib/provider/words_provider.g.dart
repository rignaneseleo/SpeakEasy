// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'words_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$wordRepositoryHash() => r'61b5a503e12f8afc6fc5a9bf867e7bfcd1d78165';

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

/// See also [wordRepository].
@ProviderFor(wordRepository)
const wordRepositoryProvider = WordRepositoryFamily();

/// See also [wordRepository].
class WordRepositoryFamily extends Family<AsyncValue<CsvWordRepository>> {
  /// See also [wordRepository].
  const WordRepositoryFamily();

  /// See also [wordRepository].
  WordRepositoryProvider call(
    String langCode,
  ) {
    return WordRepositoryProvider(
      langCode,
    );
  }

  @override
  WordRepositoryProvider getProviderOverride(
    covariant WordRepositoryProvider provider,
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
  String? get name => r'wordRepositoryProvider';
}

/// See also [wordRepository].
class WordRepositoryProvider extends FutureProvider<CsvWordRepository> {
  /// See also [wordRepository].
  WordRepositoryProvider(
    String langCode,
  ) : this._internal(
          (ref) => wordRepository(
            ref as WordRepositoryRef,
            langCode,
          ),
          from: wordRepositoryProvider,
          name: r'wordRepositoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$wordRepositoryHash,
          dependencies: WordRepositoryFamily._dependencies,
          allTransitiveDependencies:
              WordRepositoryFamily._allTransitiveDependencies,
          langCode: langCode,
        );

  WordRepositoryProvider._internal(
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
  Override overrideWith(
    FutureOr<CsvWordRepository> Function(WordRepositoryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WordRepositoryProvider._internal(
        (ref) => create(ref as WordRepositoryRef),
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
  FutureProviderElement<CsvWordRepository> createElement() {
    return _WordRepositoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WordRepositoryProvider && other.langCode == langCode;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, langCode.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin WordRepositoryRef on FutureProviderRef<CsvWordRepository> {
  /// The parameter `langCode` of this provider.
  String get langCode;
}

class _WordRepositoryProviderElement
    extends FutureProviderElement<CsvWordRepository> with WordRepositoryRef {
  _WordRepositoryProviderElement(super.provider);

  @override
  String get langCode => (origin as WordRepositoryProvider).langCode;
}

String _$wordsControllerHash() => r'f0c4eb4a818dd21c309c261e1ea349b8898bfbf2';

/// See also [WordsController].
@ProviderFor(WordsController)
final wordsControllerProvider =
    AsyncNotifierProvider<WordsController, List<Word>>.internal(
  WordsController.new,
  name: r'wordsControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$wordsControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$WordsController = AsyncNotifier<List<Word>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
