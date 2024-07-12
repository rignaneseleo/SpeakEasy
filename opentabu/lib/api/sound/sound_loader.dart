import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';

Soundpool _soundpool = Soundpool(streamType: StreamType.music,maxStreams: 3);
late int _correctSoundId, _wrongSoundId, _skipSoundId, _timeoutId, _tickId;

Future loadSounds() async {
  _correctSoundId = await _soundpool
      .load(await rootBundle.load("assets/sounds/correct_answer.mp3"));
  _wrongSoundId = await _soundpool
      .load(await rootBundle.load("assets/sounds/wrong_answer.mp3"));
  _skipSoundId = await _soundpool
      .load(await rootBundle.load("assets/sounds/skip_sound.mp3"));
  _timeoutId = await _soundpool
      .load(await rootBundle.load("assets/sounds/timeover.mp3"));
  _tickId =
      await _soundpool.load(await rootBundle.load("assets/sounds/tick.mp3"));
}

playCorrectAnswerSound() async {
  await _soundpool.play(_correctSoundId);
}

playWrongAnswerSound() async {
  await _soundpool.play(_wrongSoundId);
}

playSkipSound() async {
  await _soundpool.play(_skipSoundId);
}

playTimeoutSound() async {
  await _soundpool.play(_timeoutId);
}

playTick() async {
  await _soundpool.play(_tickId);
}
