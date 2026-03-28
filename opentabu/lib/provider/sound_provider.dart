import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:soundpool/soundpool.dart';

part 'sound_provider.g.dart';

@Riverpod(keepAlive: true)
class SoundService extends _$SoundService {
  late final Soundpool _soundpool;
  late final int _correctId;
  late final int _wrongId;
  late final int _skipId;
  late final int _timeoutId;
  late final int _tickId;
  bool _initialized = false;

  @override
  void build() {}

  Future<void> initialize() async {
    if (_initialized) return;
    _soundpool = Soundpool.fromOptions(
      options: const SoundpoolOptions(
        streamType: StreamType.music,
        maxStreams: 3,
      ),
    );
    _correctId = await _soundpool
        .load(await rootBundle.load('assets/sounds/correct_answer.mp3'));
    _wrongId = await _soundpool
        .load(await rootBundle.load('assets/sounds/wrong_answer.mp3'));
    _skipId = await _soundpool
        .load(await rootBundle.load('assets/sounds/skip_sound.mp3'));
    _timeoutId = await _soundpool
        .load(await rootBundle.load('assets/sounds/timeover.mp3'));
    _tickId = await _soundpool
        .load(await rootBundle.load('assets/sounds/tick.mp3'));
    _initialized = true;
  }

  void playCorrect() => _soundpool.play(_correctId);
  void playWrong() => _soundpool.play(_wrongId);
  void playSkip() => _soundpool.play(_skipId);
  void playTimeout() => _soundpool.play(_timeoutId);
  void playTick() => _soundpool.play(_tickId);
}
