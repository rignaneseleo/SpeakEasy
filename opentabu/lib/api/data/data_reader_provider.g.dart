// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_reader_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dataReaderHash() => r'40230c5a2b843d5266e57047eaf1452ca1c539bc';

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

/// See also [dataReader].
@ProviderFor(dataReader)
const dataReaderProvider = DataReaderFamily();

/// See also [dataReader].
class DataReaderFamily extends Family<AsyncValue<DataReader>> {
  /// See also [dataReader].
  const DataReaderFamily();

  /// See also [dataReader].
  DataReaderProvider call(
    String langCode,
  ) {
    return DataReaderProvider(
      langCode,
    );
  }

  @override
  DataReaderProvider getProviderOverride(
    covariant DataReaderProvider provider,
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
  String? get name => r'dataReaderProvider';
}

/// See also [dataReader].
class DataReaderProvider extends FutureProvider<DataReader> {
  /// See also [dataReader].
  DataReaderProvider(
    String langCode,
  ) : this._internal(
          (ref) => dataReader(
            ref as DataReaderRef,
            langCode,
          ),
          from: dataReaderProvider,
          name: r'dataReaderProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$dataReaderHash,
          dependencies: DataReaderFamily._dependencies,
          allTransitiveDependencies:
              DataReaderFamily._allTransitiveDependencies,
          langCode: langCode,
        );

  DataReaderProvider._internal(
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
    FutureOr<DataReader> Function(DataReaderRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DataReaderProvider._internal(
        (ref) => create(ref as DataReaderRef),
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
  FutureProviderElement<DataReader> createElement() {
    return _DataReaderProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DataReaderProvider && other.langCode == langCode;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, langCode.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DataReaderRef on FutureProviderRef<DataReader> {
  /// The parameter `langCode` of this provider.
  String get langCode;
}

class _DataReaderProviderElement extends FutureProviderElement<DataReader>
    with DataReaderRef {
  _DataReaderProviderElement(super.provider);

  @override
  String get langCode => (origin as DataReaderProvider).langCode;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
