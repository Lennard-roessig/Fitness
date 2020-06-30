import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fitness_workouts/models/sound.dart';
import 'package:fitness_workouts/util/sound_player.dart';

part 'sounds_event.dart';
part 'sounds_state.dart';

class SoundsBloc extends Bloc<SoundsEvent, SoundsState> {
  final SoundPlayer soundPlayer = SoundPlayer();
  final defaultSound =
      Sound("Sound 1", "assets/sounds/service-bell_daniel_simion.mp3", true);

  @override
  SoundsState get initialState => SoundsLoading();

  @override
  Future<void> close() {
    soundPlayer.close();
    return super.close();
  }

  @override
  Stream<SoundsState> mapEventToState(SoundsEvent event) async* {
    switch (event.runtimeType) {
      case LoadSounds:
        yield* _mapLoadSoundsToState();
        break;
      case UpdatedSounds:
        yield* _mapSoundsUpdateToState(event);
        break;
      case PlayTTS:
        yield* _mapPlayTTSToState(event);
        break;
      case PlaySound:
        yield* _mapPlaySoundToState(event);
        break;
      case PrepareSounds:
        yield* _mapPrepateSoundsToState(event);
        break;
      case PlayDefaultSound:
        soundPlayer.playSound(defaultSound);
        yield state;
        break;
    }
  }

  Stream<SoundsState> _mapPrepateSoundsToState(PrepareSounds event) async* {
    soundPlayer.loadSounds([
      ...event.sounds,
      defaultSound,
    ]);
    yield state;
  }

  Stream<SoundsState> _mapPlayTTSToState(PlayTTS event) async* {
    soundPlayer.speak(event.text);
    yield state;
  }

  Stream<SoundsState> _mapPlaySoundToState(PlaySound event) async* {
    soundPlayer.playSound(event.sound);
    yield state;
  }

  Stream<SoundsState> _mapLoadSoundsToState() async* {
    add(UpdatedSounds([
      Sound("Sound 1", "assets/sounds/service-bell_daniel_simion.mp3", true),
      Sound("Sound 2", "assets/sounds/air_horn.mp3", true),
    ]));
    yield state;
  }

  Stream<SoundsState> _mapSoundsUpdateToState(UpdatedSounds event) async* {
    yield SoundsLoaded(event.sounds);
  }
}
