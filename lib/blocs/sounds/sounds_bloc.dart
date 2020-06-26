import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fitness_workouts/models.dart';

part 'sounds_event.dart';
part 'sounds_state.dart';

class SoundsBloc extends Bloc<SoundsEvent, SoundsState> {
  @override
  SoundsState get initialState => SoundsLoading();

  @override
  Stream<SoundsState> mapEventToState(SoundsEvent event) async* {
    switch (event.runtimeType) {
      case LoadSounds:
        yield* _mapLoadActivitiesToState();
        break;
      case UpdatedSounds:
        yield* _mapActivitiesUpdateToState(event);
        break;
    }
  }

  Stream<SoundsState> _mapLoadActivitiesToState() async* {
    add(UpdatedSounds([
      Sound("Sound 1", "assets/service-bell_daniel_simion.mp3", true),
      Sound("Sound 2", "assets/service-bell_daniel_simion.mp3", true),
      Sound("Sound 3", "assets/service-bell_daniel_simion.mp3", true),
    ]));
  }

  Stream<SoundsState> _mapActivitiesUpdateToState(UpdatedSounds event) async* {
    yield SoundsLoaded(event.sounds);
  }
}
