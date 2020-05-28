import 'dart:async';

import 'package:flutter/material.dart';

import '../models.dart';

class ClockProvider extends ChangeNotifier {
  static const duration = const Duration(seconds: 1);

  int pausedTime = 0;
  Map<WorkoutLevel, bool> _finished;
  Map<WorkoutLevel, int> position;
  Timer _timer;
  Workout _workout;
  int _skippedSeconds = 0;

  ClockProvider({
    @required Workout workout,
    @required WorkoutLevel level1,
    WorkoutLevel level2,
  }) {
    _workout = workout;
    position = Map.fromEntries([
      MapEntry(level1, 0),
    ]);
    _finished = Map.fromEntries([
      MapEntry(level1, false),
    ]);
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
    _timer?.cancel();
    _timer = null;
    notifyListeners();
  }

  void move(WorkoutLevel level) {
    if (relativeElapsedSeconds(level) >= currentWorkoutpart(level).intervall) {
      next(level);
    }
  }

  void skip(WorkoutLevel level) {
    _skippedSeconds +=
        (currentWorkoutpart(level).intervall - relativeElapsedSeconds(level));
    next(level);
  }

  void next(WorkoutLevel level) {
    position[level] += 1;
    if (position[level] >= sequence(level).length) {
      _finished[level] = true;
    }
    notifyListeners();
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
}
