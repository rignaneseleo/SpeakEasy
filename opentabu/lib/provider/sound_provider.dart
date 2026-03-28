import 'package:audioplayers/audioplayers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sound_provider.g.dart';

@Riverpod(keepAlive: true)
class SoundService extends _$SoundService {
  final _players = <String, AudioPlayer>{};

  @override
  void build() {}

  Future<void> initialize() async {
    const sounds = [
      'correct_answer',
      'wrong_answer',
      'skip_sound',
      'timeover',
      'tick',
    ];
    for (final name in sounds) {
      final player = AudioPlayer();
      await player.setSource(AssetSource('sounds/$name.mp3'));
      await player.setReleaseMode(ReleaseMode.stop);
      _players[name] = player;
    }
  }

  Future<void> _play(String name) async {
    final player = _players[name];
    if (player == null) return;
    await player.stop();
    await player.play(AssetSource('sounds/$name.mp3'));
  }

  void playCorrect() => _play('correct_answer');
  void playWrong() => _play('wrong_answer');
  void playSkip() => _play('skip_sound');
  void playTimeout() => _play('timeover');
  void playTick() => _play('tick');
}
