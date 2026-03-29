// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'word.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Word {
  String get wordToGuess => throw _privateConstructorUsedError;
  List<String> get taboos => throw _privateConstructorUsedError;

  /// Create a copy of Word
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WordCopyWith<Word> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WordCopyWith<$Res> {
  factory $WordCopyWith(Word value, $Res Function(Word) then) =
      _$WordCopyWithImpl<$Res, Word>;
  @useResult
  $Res call({String wordToGuess, List<String> taboos});
}

/// @nodoc
class _$WordCopyWithImpl<$Res, $Val extends Word>
    implements $WordCopyWith<$Res> {
  _$WordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Word
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? wordToGuess = null,
    Object? taboos = null,
  }) {
    return _then(_value.copyWith(
      wordToGuess: null == wordToGuess
          ? _value.wordToGuess
          : wordToGuess // ignore: cast_nullable_to_non_nullable
              as String,
      taboos: null == taboos
          ? _value.taboos
          : taboos // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WordImplCopyWith<$Res> implements $WordCopyWith<$Res> {
  factory _$$WordImplCopyWith(
          _$WordImpl value, $Res Function(_$WordImpl) then) =
      __$$WordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String wordToGuess, List<String> taboos});
}

/// @nodoc
class __$$WordImplCopyWithImpl<$Res>
    extends _$WordCopyWithImpl<$Res, _$WordImpl>
    implements _$$WordImplCopyWith<$Res> {
  __$$WordImplCopyWithImpl(_$WordImpl _value, $Res Function(_$WordImpl) _then)
      : super(_value, _then);

  /// Create a copy of Word
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? wordToGuess = null,
    Object? taboos = null,
  }) {
    return _then(_$WordImpl(
      wordToGuess: null == wordToGuess
          ? _value.wordToGuess
          : wordToGuess // ignore: cast_nullable_to_non_nullable
              as String,
      taboos: null == taboos
          ? _value._taboos
          : taboos // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$WordImpl implements _Word {
  const _$WordImpl(
      {required this.wordToGuess, required final List<String> taboos})
      : _taboos = taboos;

  @override
  final String wordToGuess;
  final List<String> _taboos;
  @override
  List<String> get taboos {
    if (_taboos is EqualUnmodifiableListView) return _taboos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_taboos);
  }

  @override
  String toString() {
    return 'Word(wordToGuess: $wordToGuess, taboos: $taboos)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WordImpl &&
            (identical(other.wordToGuess, wordToGuess) ||
                other.wordToGuess == wordToGuess) &&
            const DeepCollectionEquality().equals(other._taboos, _taboos));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, wordToGuess, const DeepCollectionEquality().hash(_taboos));

  /// Create a copy of Word
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WordImplCopyWith<_$WordImpl> get copyWith =>
      __$$WordImplCopyWithImpl<_$WordImpl>(this, _$identity);
}

abstract class _Word implements Word {
  const factory _Word(
      {required final String wordToGuess,
      required final List<String> taboos}) = _$WordImpl;

  @override
  String get wordToGuess;
  @override
  List<String> get taboos;

  /// Create a copy of Word
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WordImplCopyWith<_$WordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
