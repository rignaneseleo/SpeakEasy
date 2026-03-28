// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analytics_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Analytics {
  int get matchesPlayed => throw _privateConstructorUsedError;
  int get correctAnswers => throw _privateConstructorUsedError;
  int get wrongAnswers => throw _privateConstructorUsedError;
  int get skipsUsed => throw _privateConstructorUsedError;

  /// Create a copy of Analytics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnalyticsCopyWith<Analytics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalyticsCopyWith<$Res> {
  factory $AnalyticsCopyWith(Analytics value, $Res Function(Analytics) then) =
      _$AnalyticsCopyWithImpl<$Res, Analytics>;
  @useResult
  $Res call(
      {int matchesPlayed, int correctAnswers, int wrongAnswers, int skipsUsed});
}

/// @nodoc
class _$AnalyticsCopyWithImpl<$Res, $Val extends Analytics>
    implements $AnalyticsCopyWith<$Res> {
  _$AnalyticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Analytics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? matchesPlayed = null,
    Object? correctAnswers = null,
    Object? wrongAnswers = null,
    Object? skipsUsed = null,
  }) {
    return _then(_value.copyWith(
      matchesPlayed: null == matchesPlayed
          ? _value.matchesPlayed
          : matchesPlayed // ignore: cast_nullable_to_non_nullable
              as int,
      correctAnswers: null == correctAnswers
          ? _value.correctAnswers
          : correctAnswers // ignore: cast_nullable_to_non_nullable
              as int,
      wrongAnswers: null == wrongAnswers
          ? _value.wrongAnswers
          : wrongAnswers // ignore: cast_nullable_to_non_nullable
              as int,
      skipsUsed: null == skipsUsed
          ? _value.skipsUsed
          : skipsUsed // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AnalyticsImplCopyWith<$Res>
    implements $AnalyticsCopyWith<$Res> {
  factory _$$AnalyticsImplCopyWith(
          _$AnalyticsImpl value, $Res Function(_$AnalyticsImpl) then) =
      __$$AnalyticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int matchesPlayed, int correctAnswers, int wrongAnswers, int skipsUsed});
}

/// @nodoc
class __$$AnalyticsImplCopyWithImpl<$Res>
    extends _$AnalyticsCopyWithImpl<$Res, _$AnalyticsImpl>
    implements _$$AnalyticsImplCopyWith<$Res> {
  __$$AnalyticsImplCopyWithImpl(
      _$AnalyticsImpl _value, $Res Function(_$AnalyticsImpl) _then)
      : super(_value, _then);

  /// Create a copy of Analytics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? matchesPlayed = null,
    Object? correctAnswers = null,
    Object? wrongAnswers = null,
    Object? skipsUsed = null,
  }) {
    return _then(_$AnalyticsImpl(
      matchesPlayed: null == matchesPlayed
          ? _value.matchesPlayed
          : matchesPlayed // ignore: cast_nullable_to_non_nullable
              as int,
      correctAnswers: null == correctAnswers
          ? _value.correctAnswers
          : correctAnswers // ignore: cast_nullable_to_non_nullable
              as int,
      wrongAnswers: null == wrongAnswers
          ? _value.wrongAnswers
          : wrongAnswers // ignore: cast_nullable_to_non_nullable
              as int,
      skipsUsed: null == skipsUsed
          ? _value.skipsUsed
          : skipsUsed // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$AnalyticsImpl implements _Analytics {
  const _$AnalyticsImpl(
      {this.matchesPlayed = 0,
      this.correctAnswers = 0,
      this.wrongAnswers = 0,
      this.skipsUsed = 0});

  @override
  @JsonKey()
  final int matchesPlayed;
  @override
  @JsonKey()
  final int correctAnswers;
  @override
  @JsonKey()
  final int wrongAnswers;
  @override
  @JsonKey()
  final int skipsUsed;

  @override
  String toString() {
    return 'Analytics(matchesPlayed: $matchesPlayed, correctAnswers: $correctAnswers, wrongAnswers: $wrongAnswers, skipsUsed: $skipsUsed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalyticsImpl &&
            (identical(other.matchesPlayed, matchesPlayed) ||
                other.matchesPlayed == matchesPlayed) &&
            (identical(other.correctAnswers, correctAnswers) ||
                other.correctAnswers == correctAnswers) &&
            (identical(other.wrongAnswers, wrongAnswers) ||
                other.wrongAnswers == wrongAnswers) &&
            (identical(other.skipsUsed, skipsUsed) ||
                other.skipsUsed == skipsUsed));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, matchesPlayed, correctAnswers, wrongAnswers, skipsUsed);

  /// Create a copy of Analytics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalyticsImplCopyWith<_$AnalyticsImpl> get copyWith =>
      __$$AnalyticsImplCopyWithImpl<_$AnalyticsImpl>(this, _$identity);
}

abstract class _Analytics implements Analytics {
  const factory _Analytics(
      {final int matchesPlayed,
      final int correctAnswers,
      final int wrongAnswers,
      final int skipsUsed}) = _$AnalyticsImpl;

  @override
  int get matchesPlayed;
  @override
  int get correctAnswers;
  @override
  int get wrongAnswers;
  @override
  int get skipsUsed;

  /// Create a copy of Analytics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnalyticsImplCopyWith<_$AnalyticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
