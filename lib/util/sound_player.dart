import 'package:fitness_workouts/models/sound.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:soundpool/soundpool.dart';

enum TtsState { playing, stopped }

class SoundPlayer {
  bool _closed;

  final Soundpool _soundpool;
  Map<Sound, Future<int>> _cache;
  int _alarmSoundStreamId;

  final FlutterTts _tts;
  dynamic state;
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;

  SoundPlayer({
    Soundpool soundpool,
    Map<Sound, Future<int>> cache,
    FlutterTts tts,
  })  : _soundpool = soundpool ?? Soundpool(),
        _cache = cache ?? Map(),
        _tts = tts ?? FlutterTts(),
        _closed = false;

  Future<void> playSound(Sound sound) async {
    var _alarmSound = await _cache[sound];
    _alarmSoundStreamId = await _soundpool.play(_alarmSound);
  }

  Future<void> stopSound() async {
    if (_alarmSoundStreamId != null) {
      await _soundpool.stop(_alarmSoundStreamId);
    }
  }

  void loadSounds(List<Sound> sounds) {
    // assert(sounds == null, 'Failed load sounds');
    final filtered =
        sounds.where((element) => !_cache.containsKey(element)).toList();
    _cache = {
      ..._cache,
      ...Map.fromIterable(filtered,
          key: (e) => e,
          value: (e) async {
            var asset = await rootBundle.load(e.path);
            return await _soundpool.load(asset);
          })
    };
  }

  bool get isClosed {
    return _soundpool == null || _closed;
  }

  void speak(String text) async {
    if (text.isEmpty) return;
    await _tts.setLanguage("en-US");
    await _tts.setVolume(volume);
    await _tts.setSpeechRate(rate);
    await _tts.setPitch(pitch);
    var result = await _tts.speak(text);
    if (result == 1) state = TtsState.stopped;
  }

  void close() {
    if (!isClosed) {
      _tts.stop();
      _soundpool.release();
      _soundpool.dispose();
      _closed = true;
    }
  }

  //  Future stop() async => await _tts.stop();
}
