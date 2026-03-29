// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GameSettings {
  int get nPlayers => throw _privateConstructorUsedError;
  int get turnDurationInSeconds => throw _privateConstructorUsedError;
  int get nSkip => throw _privateConstructorUsedError;
  int get nTurns => throw _privateConstructorUsedError;
  int get nTaboos => throw _privateConstructorUsedError;

  /// Create a copy of GameSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameSettingsCopyWith<GameSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameSettingsCopyWith<$Res> {
  factory $GameSettingsCopyWith(
          GameSettings value, $Res Function(GameSettings) then) =
      _$GameSettingsCopyWithImpl<$Res, GameSettings>;
  @useResult
  $Res call(
      {int nPlayers,
      int turnDurationInSeconds,
      int nSkip,
      int nTurns,
      int nTaboos});
}

/// @nodoc
class _$GameSettingsCopyWithImpl<$Res, $Val extends GameSettings>
    implements $GameSettingsCopyWith<$Res> {
  _$GameSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nPlayers = null,
    Object? turnDurationInSeconds = null,
    Object? nSkip = null,
    Object? nTurns = null,
    Object? nTaboos = null,
  }) {
    return _then(_value.copyWith(
      nPlayers: null == nPlayers
          ? _value.nPlayers
          : nPlayers // ignore: cast_nullable_to_non_nullable
              as int,
      turnDurationInSeconds: null == turnDurationInSeconds
          ? _value.turnDurationInSeconds
          : turnDurationInSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      nSkip: null == nSkip
          ? _value.nSkip
          : nSkip // ignore: cast_nullable_to_non_nullable
              as int,
      nTurns: null == nTurns
          ? _value.nTurns
          : nTurns // ignore: cast_nullable_to_non_nullable
              as int,
      nTaboos: null == nTaboos
          ? _value.nTaboos
          : nTaboos // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GameSettingsImplCopyWith<$Res>
    implements $GameSettingsCopyWith<$Res> {
  factory _$$GameSettingsImplCopyWith(
          _$GameSettingsImpl value, $Res Function(_$GameSettingsImpl) then) =
      __$$GameSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int nPlayers,
      int turnDurationInSeconds,
      int nSkip,
      int nTurns,
      int nTaboos});
}

/// @nodoc
class __$$GameSettingsImplCopyWithImpl<$Res>
    extends _$GameSettingsCopyWithImpl<$Res, _$GameSettingsImpl>
    implements _$$GameSettingsImplCopyWith<$Res> {
  __$$GameSettingsImplCopyWithImpl(
      _$GameSettingsImpl _value, $Res Function(_$GameSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of GameSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nPlayers = null,
    Object? turnDurationInSeconds = null,
    Object? nSkip = null,
    Object? nTurns = null,
    Object? nTaboos = null,
  }) {
    return _then(_$GameSettingsImpl(
      nPlayers: null == nPlayers
          ? _value.nPlayers
          : nPlayers // ignore: cast_nullable_to_non_nullable
              as int,
      turnDurationInSeconds: null == turnDurationInSeconds
          ? _value.turnDurationInSeconds
          : turnDurationInSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      nSkip: null == nSkip
          ? _value.nSkip
          : nSkip // ignore: cast_nullable_to_non_nullable
              as int,
      nTurns: null == nTurns
          ? _value.nTurns
          : nTurns // ignore: cast_nullable_to_non_nullable
              as int,
      nTaboos: null == nTaboos
          ? _value.nTaboos
          : nTaboos // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$GameSettingsImpl implements _GameSettings {
  const _$GameSettingsImpl(
      {this.nPlayers = 2,
      this.turnDurationInSeconds = 90,
      this.nSkip = 3,
      this.nTurns = 10,
      this.nTaboos = 5});

  @override
  @JsonKey()
  final int nPlayers;
  @override
  @JsonKey()
  final int turnDurationInSeconds;
  @override
  @JsonKey()
  final int nSkip;
  @override
  @JsonKey()
  final int nTurns;
  @override
  @JsonKey()
  final int nTaboos;

  @override
  String toString() {
    return 'GameSettings(nPlayers: $nPlayers, turnDurationInSeconds: $turnDurationInSeconds, nSkip: $nSkip, nTurns: $nTurns, nTaboos: $nTaboos)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameSettingsImpl &&
            (identical(other.nPlayers, nPlayers) ||
                other.nPlayers == nPlayers) &&
            (identical(other.turnDurationInSeconds, turnDurationInSeconds) ||
                other.turnDurationInSeconds == turnDurationInSeconds) &&
            (identical(other.nSkip, nSkip) || other.nSkip == nSkip) &&
            (identical(other.nTurns, nTurns) || other.nTurns == nTurns) &&
            (identical(other.nTaboos, nTaboos) || other.nTaboos == nTaboos));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, nPlayers, turnDurationInSeconds, nSkip, nTurns, nTaboos);

  /// Create a copy of GameSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameSettingsImplCopyWith<_$GameSettingsImpl> get copyWith =>
      __$$GameSettingsImplCopyWithImpl<_$GameSettingsImpl>(this, _$identity);
}

abstract class _GameSettings implements GameSettings {
  const factory _GameSettings(
      {final int nPlayers,
      final int turnDurationInSeconds,
      final int nSkip,
      final int nTurns,
      final int nTaboos}) = _$GameSettingsImpl;

  @override
  int get nPlayers;
  @override
  int get turnDurationInSeconds;
  @override
  int get nSkip;
  @override
  int get nTurns;
  @override
  int get nTaboos;

  /// Create a copy of GameSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameSettingsImplCopyWith<_$GameSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
