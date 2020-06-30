import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fitness_workouts/blocs/sounds/sounds_bloc.dart';
import 'package:fitness_workouts/blocs/timer/timer_bloc.dart';
import 'package:flutter/material.dart';

import '../../models.dart';

part 'runner_event.dart';
part 'runner_state.dart';

class RunnerBloc extends Bloc<RunnerEvent, RunnerState> {
  final TimerBloc timerBloc;
  StreamSubscription _timerBlocSubsciption;
  final List<Activity> activities;
  final SoundsBloc soundsBloc;

  RunnerBloc({
    @required this.timerBloc,
    @required this.activities,
    @required this.soundsBloc,
  })  : assert(timerBloc != null),
        assert(soundsBloc != null),
        assert(activities != null && activities.length > 0) {
    _timerBlocSubsciption = timerBloc.listen((state) {
      add(UpdateTimeRunner(state.seconds, state.delay));
    });
  }

  @override
  RunnerState get initialState =>
      RunnerRunning(activity: activities[0], time: 0, round: 0, index: 0);

  @override
  Future<void> close() {
    _timerBlocSubsciption?.cancel();
    return super.close();
  }

  @override
  Stream<RunnerState> mapEventToState(RunnerEvent event) async* {
    if (event is UpdateTimeRunner) {
      yield* _mapUpdateTimeToState(event);
    }

    if (event is SkipRunner) {
      yield _next();
    }

    if (event is BackRunner) {
      yield _back();
    }

    if (event is FinishedRepetitionRunner) {
      yield _next();
    }

    if (event is FinishRunner) {
      yield _mapFinishToState();
    }

    if (event is RepeatRunner) {
      yield _mapRepeatToState();
    }
  }

  RunnerState _mapRepeatToState() {
    timerBloc.add(ResetTimer());
    timerBloc.add(StartTimer());
    return initialState;
  }

  void _playAlarm(UpdateTimeRunner event) {
    state.activity.alarms.where((element) => element.activ).forEach((element) {
      final timestamp = element.relativeTimestamp != 0
          ? (element.relativeTimestamp * state.activity.intervall)
              .roundToDouble()
              .toInt()
          : element.timestamp;
      if (timestamp == state.time) soundsBloc.add(PlaySound(element.sound));
    });
  }

  Stream<RunnerState> _mapUpdateTimeToState(UpdateTimeRunner event) async* {
    if (state is RunnerRunning || state is RunnerRunningAndWaiting) {
      _playAlarm(event);
      if (state.time + event.delay >= state.activity.intervall) {
        yield _next();
      } else {
        yield state is RunnerRunning
            ? RunnerRunning(
                activity: state.activity,
                time: state.time + event.delay,
                round: state.round,
                index: state.index,
              )
            : RunnerRunningAndWaiting(
                activity: state.activity,
                time: state.time + event.delay,
                round: state.round,
                index: state.index,
              );
      }
    } else {
      yield state;
    }
  }

  RunnerFinished _mapFinishToState() {
    timerBloc.add(StopTimer());
    return RunnerFinished(
      round: state.round,
      time: state.time,
      index: state.index,
    );
  }

  RunnerState _next({int skip = 0}) {
    if (activities.length <= state.index + 1 + skip) {
      add(FinishRunner());
      return state;
    }

    final nextActivity = activities[state.index + 1 + skip];

    if (nextActivity.isGroup) {
      if (state.round < nextActivity.rounds - 1) {
        final indexOfFirstInGroup = activities.indexWhere(
            (element) => element.groupId == nextActivity.referenceGroupId);

        return _mapNewActivityToState(
          index: indexOfFirstInGroup,
          activity: activities[indexOfFirstInGroup],
          time: 0,
          round: state.round + 1,
        );
      } else {
        return _next(skip: skip + 1);
      }
    } else {
      return _mapNewActivityToState(
        index: state.index + 1 + skip,
        activity: nextActivity,
        time: 0,
        round: skip != 0 ? 0 : state.round,
      );
    }
  }

  RunnerState _back({int skip = 0}) {
    if (state.index - 1 - skip < 0 && state.round == 0) return state;
    var previousActivity =
        state.index == 0 ? null : activities[state.index - 1 - skip];

    if (previousActivity.isGroup || previousActivity == null) {
      if (state.round > 0) {
        final groupId = previousActivity == null
            ? state.activity.groupId
            : previousActivity.referenceGroupId;
        final indexOfLastInGroup = activities.reversed
            .toList()
            .indexWhere((element) => element.groupId == groupId);

        return _mapNewActivityToState(
          index: activities.length - indexOfLastInGroup,
          activity: activities[activities.length - indexOfLastInGroup],
          time: 0,
          round: state.round - 1,
        );
      } else {
        return _back(skip: 1);
      }
    } else {
      return _mapNewActivityToState(
        index: state.index - 1 - skip,
        activity: previousActivity,
        time: 0,
        round: skip != 0 ? activities[state.index - skip] : state.round,
      );
    }
  }

  RunnerState _mapNewActivityToState({
    int round = 0,
    int time = 0,
    Activity activity,
    int index = 0,
  }) {
    this.soundsBloc.add(PlayDefaultSound());
    if (activity.intervall > 0 && activity.repetitions > 0)
      return RunnerRunningAndWaiting(
        index: index,
        activity: activity,
        time: time,
        round: round,
      );
    if (activity.repetitions > 0)
      return RunnerWaiting(
        index: index,
        activity: activity,
        time: time,
        round: round,
      );

    return RunnerRunning(
      index: index,
      activity: activity,
      time: time,
      round: round,
    );
  }
}
