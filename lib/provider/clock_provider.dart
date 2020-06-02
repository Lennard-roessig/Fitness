import 'dart:async';

import 'package:fitness_workouts/util/sound_player.dart';
import 'package:flutter/material.dart';

import '../models.dart';

class ClockProvider extends ChangeNotifier {
  final Sound endSound = Sound("EndSound", "assets/sounds/air_horn.mp3", true);

  static const duration = const Duration(seconds: 1);
  SoundPlayer _soundplayer;
  int pausedTime = 0;
  Map<WorkoutLevel, bool> _finished;
  Map<WorkoutLevel, int> position;
  Timer _timer;
  Workout _workout;
  int _skippedSeconds = 0;
  Activity Function(String id) activityById;

  ClockProvider({
    @required Workout workout,
    @required WorkoutLevel level1,
    @required this.activityById,
    WorkoutLevel level2,
  }) {
    _workout = workout;
    position = Map.fromEntries([
      MapEntry(level1, 0),
    ]);
    _finished = Map.fromEntries([
      MapEntry(level1, false),
    ]);
    _soundplayer = _soundplayer = SoundPlayer();
  }

  int get elapsedSeconds => pausedTime + (_timer?.tick ?? 0);
  int relativeElapsedSeconds(WorkoutLevel level) =>
      (_skippedSeconds + elapsedSeconds) -
      (getAbsTime(level) - currentWorkoutpart(level).intervall);

  Workout get workout => _workout;
  WorkoutPart currentWorkoutpart(WorkoutLevel level) {
    return sequence(level)[position[level]];
  }

  void startTimer() {
    if (_timer != null && _timer.isActive) stopTimer();
    if (_soundplayer.isClosed) _soundplayer = SoundPlayer();
    _soundplayer.loadSounds([endSound]);
    _soundplayer.loadSounds(sounds);
    _timer = Timer.periodic(duration, (timer) {
      position.keys.forEach(move);
      notifyListeners();
    });
    notifyListeners();
  }

  void pauseTimer() {
    pausedTime += _timer.tick;
    stopTimer();
    notifyListeners();
  }

  void stopTimer() {
    _soundplayer?.close();
    _timer?.cancel();
    _timer = null;
    notifyListeners();
  }

  void move(WorkoutLevel level) {
    makeNoise(level);
    int timeToGo =
        currentWorkoutpart(level).intervall - relativeElapsedSeconds(level);
    if (timeToGo <= 4) speakNextActivity(level, timeToGo);
    if (timeToGo <= 0) next(level);
  }

  void skip(WorkoutLevel level) {
    _skippedSeconds +=
        (currentWorkoutpart(level).intervall - relativeElapsedSeconds(level));
    next(level);
  }

  // Todo - effizient
  void makeNoise(WorkoutLevel level) {
    currentWorkoutpart(level).alarms.forEach((element) {
      if (element.activ) {
        final timestamp = element.timestamp != 0
            ? element.timestamp
            : (element.relativeTimestamp * currentWorkoutpart(level).intervall)
                .toInt();
        if (timestamp == relativeElapsedSeconds(level))
          _soundplayer.playSound(element.sound);
      }
    });
  }

  void next(WorkoutLevel level) {
    if (position[level] + 1 >= sequence(level).length) {
      _finished[level] = true;
      stopTimer();
      _soundplayer.speak("Workout Finished");
      return;
    }
    position[level] += 1;
    _soundplayer.loadSounds(sounds);
    notifyListeners();
  }

  void speakNextActivity(WorkoutLevel level, int time) {
    if (position[level] + 1 >= sequence(level).length) return;
    final nextWorkoutPart = sequence(level)[position[level] + 1];

    if (nextWorkoutPart.isPause && time == 4)
      _soundplayer.speak("Pause in");
    else if (time == 4) {
      final text = activityById(nextWorkoutPart.activityId).name + " in";
      _soundplayer.speak(text);
    } else {
      final text = time == 0 ? "GO" : time.toString();
      _soundplayer.speak(text);
    }
  }

  void previous(WorkoutLevel level) {
    int time = relativeElapsedSeconds(level);
    position[level] -= 1;
    _skippedSeconds -= (time + currentWorkoutpart(level).intervall);
    notifyListeners();
  }

  List<WorkoutPart> sequence(WorkoutLevel level) {
    return _workout.sequence(level).expand((element) {
      if (element.isGroup) {
        return List.generate(
                element.rounds,
                (index) => _workout
                    .sequence(level)
                    .where((x) => x.groupId == element.referenceGroupId))
            .expand((element) => element);
      }
      return [element];
    }).toList();
  }

  List<WorkoutPart> nextParts(WorkoutLevel level, {int amount = 4}) {
    int start = position[level] + 1 > sequence(level).length
        ? position[level]
        : position[level] + 1;
    int end = (position[level] + amount + 1) > sequence(level).length
        ? sequence(level).length
        : (position[level] + amount + 1);

    return sequence(level).sublist(start, end).toList();
  }

  int getAbsTime(WorkoutLevel level) {
    int sec = 0;
    for (final x in sequence(level).sublist(0, position[level] + 1)) {
      sec += x.intervall;
    }
    return sec;
  }

  bool get isRunning {
    return _timer != null ? _timer.isActive : false;
  }

  bool finished(WorkoutLevel level) {
    return _finished[level];
  }

  List<Sound> get sounds {
    List<Sound> toReturn = [];
    for (final level in position.keys) {
      toReturn = [
        ...toReturn,
        ...currentWorkoutpart(level).alarms.map((e) => e.sound)
      ];
    }
    return toReturn;
  }
}
