// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GameState {
  GamePhase get phase => throw _privateConstructorUsedError;
  List<int> get scores => throw _privateConstructorUsedError;
  List<int> get skipsLeft => throw _privateConstructorUsedError;
  int get currentTeam => throw _privateConstructorUsedError;
  int get currentTurn => throw _privateConstructorUsedError;
  int get totalTurns => throw _privateConstructorUsedError;
  int get nSkipsPerTeam => throw _privateConstructorUsedError;
  int get secondsPassed => throw _privateConstructorUsedError;
  List<Word> get words => throw _privateConstructorUsedError;
  int get wordIndex => throw _privateConstructorUsedError;
  Word? get currentWord => throw _privateConstructorUsedError;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameStateCopyWith<GameState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameStateCopyWith<$Res> {
  factory $GameStateCopyWith(GameState value, $Res Function(GameState) then) =
      _$GameStateCopyWithImpl<$Res, GameState>;
  @useResult
  $Res call(
      {GamePhase phase,
      List<int> scores,
      List<int> skipsLeft,
      int currentTeam,
      int currentTurn,
      int totalTurns,
      int nSkipsPerTeam,
      int secondsPassed,
      List<Word> words,
      int wordIndex,
      Word? currentWord});

  $WordCopyWith<$Res>? get currentWord;
}

/// @nodoc
class _$GameStateCopyWithImpl<$Res, $Val extends GameState>
    implements $GameStateCopyWith<$Res> {
  _$GameStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phase = null,
    Object? scores = null,
    Object? skipsLeft = null,
    Object? currentTeam = null,
    Object? currentTurn = null,
    Object? totalTurns = null,
    Object? nSkipsPerTeam = null,
    Object? secondsPassed = null,
    Object? words = null,
    Object? wordIndex = null,
    Object? currentWord = freezed,
  }) {
    return _then(_value.copyWith(
      phase: null == phase
          ? _value.phase
          : phase // ignore: cast_nullable_to_non_nullable
              as GamePhase,
      scores: null == scores
          ? _value.scores
          : scores // ignore: cast_nullable_to_non_nullable
              as List<int>,
      skipsLeft: null == skipsLeft
          ? _value.skipsLeft
          : skipsLeft // ignore: cast_nullable_to_non_nullable
              as List<int>,
      currentTeam: null == currentTeam
          ? _value.currentTeam
          : currentTeam // ignore: cast_nullable_to_non_nullable
              as int,
      currentTurn: null == currentTurn
          ? _value.currentTurn
          : currentTurn // ignore: cast_nullable_to_non_nullable
              as int,
      totalTurns: null == totalTurns
          ? _value.totalTurns
          : totalTurns // ignore: cast_nullable_to_non_nullable
              as int,
      nSkipsPerTeam: null == nSkipsPerTeam
          ? _value.nSkipsPerTeam
          : nSkipsPerTeam // ignore: cast_nullable_to_non_nullable
              as int,
      secondsPassed: null == secondsPassed
          ? _value.secondsPassed
          : secondsPassed // ignore: cast_nullable_to_non_nullable
              as int,
      words: null == words
          ? _value.words
          : words // ignore: cast_nullable_to_non_nullable
              as List<Word>,
      wordIndex: null == wordIndex
          ? _value.wordIndex
          : wordIndex // ignore: cast_nullable_to_non_nullable
              as int,
      currentWord: freezed == currentWord
          ? _value.currentWord
          : currentWord // ignore: cast_nullable_to_non_nullable
              as Word?,
    ) as $Val);
  }

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WordCopyWith<$Res>? get currentWord {
    if (_value.currentWord == null) {
      return null;
    }

    return $WordCopyWith<$Res>(_value.currentWord!, (value) {
      return _then(_value.copyWith(currentWord: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GameStateImplCopyWith<$Res>
    implements $GameStateCopyWith<$Res> {
  factory _$$GameStateImplCopyWith(
          _$GameStateImpl value, $Res Function(_$GameStateImpl) then) =
      __$$GameStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {GamePhase phase,
      List<int> scores,
      List<int> skipsLeft,
      int currentTeam,
      int currentTurn,
      int totalTurns,
      int nSkipsPerTeam,
      int secondsPassed,
      List<Word> words,
      int wordIndex,
      Word? currentWord});

  @override
  $WordCopyWith<$Res>? get currentWord;
}

/// @nodoc
class __$$GameStateImplCopyWithImpl<$Res>
    extends _$GameStateCopyWithImpl<$Res, _$GameStateImpl>
    implements _$$GameStateImplCopyWith<$Res> {
  __$$GameStateImplCopyWithImpl(
      _$GameStateImpl _value, $Res Function(_$GameStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phase = null,
    Object? scores = null,
    Object? skipsLeft = null,
    Object? currentTeam = null,
    Object? currentTurn = null,
    Object? totalTurns = null,
    Object? nSkipsPerTeam = null,
    Object? secondsPassed = null,
    Object? words = null,
    Object? wordIndex = null,
    Object? currentWord = freezed,
  }) {
    return _then(_$GameStateImpl(
      phase: null == phase
          ? _value.phase
          : phase // ignore: cast_nullable_to_non_nullable
              as GamePhase,
      scores: null == scores
          ? _value._scores
          : scores // ignore: cast_nullable_to_non_nullable
              as List<int>,
      skipsLeft: null == skipsLeft
          ? _value._skipsLeft
          : skipsLeft // ignore: cast_nullable_to_non_nullable
              as List<int>,
      currentTeam: null == currentTeam
          ? _value.currentTeam
          : currentTeam // ignore: cast_nullable_to_non_nullable
              as int,
      currentTurn: null == currentTurn
          ? _value.currentTurn
          : currentTurn // ignore: cast_nullable_to_non_nullable
              as int,
      totalTurns: null == totalTurns
          ? _value.totalTurns
          : totalTurns // ignore: cast_nullable_to_non_nullable
              as int,
      nSkipsPerTeam: null == nSkipsPerTeam
          ? _value.nSkipsPerTeam
          : nSkipsPerTeam // ignore: cast_nullable_to_non_nullable
              as int,
      secondsPassed: null == secondsPassed
          ? _value.secondsPassed
          : secondsPassed // ignore: cast_nullable_to_non_nullable
              as int,
      words: null == words
          ? _value._words
          : words // ignore: cast_nullable_to_non_nullable
              as List<Word>,
      wordIndex: null == wordIndex
          ? _value.wordIndex
          : wordIndex // ignore: cast_nullable_to_non_nullable
              as int,
      currentWord: freezed == currentWord
          ? _value.currentWord
          : currentWord // ignore: cast_nullable_to_non_nullable
              as Word?,
    ));
  }
}

/// @nodoc

class _$GameStateImpl extends _GameState {
  const _$GameStateImpl(
      {this.phase = GamePhase.initial,
      final List<int> scores = const [],
      final List<int> skipsLeft = const [],
      this.currentTeam = 0,
      this.currentTurn = 0,
      this.totalTurns = 0,
      this.nSkipsPerTeam = 0,
      this.secondsPassed = 0,
      final List<Word> words = const [],
      this.wordIndex = 0,
      this.currentWord})
      : _scores = scores,
        _skipsLeft = skipsLeft,
        _words = words,
        super._();

  @override
  @JsonKey()
  final GamePhase phase;
  final List<int> _scores;
  @override
  @JsonKey()
  List<int> get scores {
    if (_scores is EqualUnmodifiableListView) return _scores;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_scores);
  }

  final List<int> _skipsLeft;
  @override
  @JsonKey()
  List<int> get skipsLeft {
    if (_skipsLeft is EqualUnmodifiableListView) return _skipsLeft;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_skipsLeft);
  }

  @override
  @JsonKey()
  final int currentTeam;
  @override
  @JsonKey()
  final int currentTurn;
  @override
  @JsonKey()
  final int totalTurns;
  @override
  @JsonKey()
  final int nSkipsPerTeam;
  @override
  @JsonKey()
  final int secondsPassed;
  final List<Word> _words;
  @override
  @JsonKey()
  List<Word> get words {
    if (_words is EqualUnmodifiableListView) return _words;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_words);
  }

  @override
  @JsonKey()
  final int wordIndex;
  @override
  final Word? currentWord;

  @override
  String toString() {
    return 'GameState(phase: $phase, scores: $scores, skipsLeft: $skipsLeft, currentTeam: $currentTeam, currentTurn: $currentTurn, totalTurns: $totalTurns, nSkipsPerTeam: $nSkipsPerTeam, secondsPassed: $secondsPassed, words: $words, wordIndex: $wordIndex, currentWord: $currentWord)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameStateImpl &&
            (identical(other.phase, phase) || other.phase == phase) &&
            const DeepCollectionEquality().equals(other._scores, _scores) &&
            const DeepCollectionEquality()
                .equals(other._skipsLeft, _skipsLeft) &&
            (identical(other.currentTeam, currentTeam) ||
                other.currentTeam == currentTeam) &&
            (identical(other.currentTurn, currentTurn) ||
                other.currentTurn == currentTurn) &&
            (identical(other.totalTurns, totalTurns) ||
                other.totalTurns == totalTurns) &&
            (identical(other.nSkipsPerTeam, nSkipsPerTeam) ||
                other.nSkipsPerTeam == nSkipsPerTeam) &&
            (identical(other.secondsPassed, secondsPassed) ||
                other.secondsPassed == secondsPassed) &&
            const DeepCollectionEquality().equals(other._words, _words) &&
            (identical(other.wordIndex, wordIndex) ||
                other.wordIndex == wordIndex) &&
            (identical(other.currentWord, currentWord) ||
                other.currentWord == currentWord));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      phase,
      const DeepCollectionEquality().hash(_scores),
      const DeepCollectionEquality().hash(_skipsLeft),
      currentTeam,
      currentTurn,
      totalTurns,
      nSkipsPerTeam,
      secondsPassed,
      const DeepCollectionEquality().hash(_words),
      wordIndex,
      currentWord);

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameStateImplCopyWith<_$GameStateImpl> get copyWith =>
      __$$GameStateImplCopyWithImpl<_$GameStateImpl>(this, _$identity);
}

abstract class _GameState extends GameState {
  const factory _GameState(
      {final GamePhase phase,
      final List<int> scores,
      final List<int> skipsLeft,
      final int currentTeam,
      final int currentTurn,
      final int totalTurns,
      final int nSkipsPerTeam,
      final int secondsPassed,
      final List<Word> words,
      final int wordIndex,
      final Word? currentWord}) = _$GameStateImpl;
  const _GameState._() : super._();

  @override
  GamePhase get phase;
  @override
  List<int> get scores;
  @override
  List<int> get skipsLeft;
  @override
  int get currentTeam;
  @override
  int get currentTurn;
  @override
  int get totalTurns;
  @override
  int get nSkipsPerTeam;
  @override
  int get secondsPassed;
  @override
  List<Word> get words;
  @override
  int get wordIndex;
  @override
  Word? get currentWord;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameStateImplCopyWith<_$GameStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
