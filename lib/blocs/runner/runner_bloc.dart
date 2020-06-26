import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fitness_workouts/blocs/timer/timer_bloc.dart';
import 'package:flutter/material.dart';

import '../../models.dart';

part 'runner_event.dart';
part 'runner_state.dart';

class RunnerBloc extends Bloc<RunnerEvent, RunnerState> {
  final TimerBloc timerBloc;
  StreamSubscription _timerBlocSubsciption;
  final List<Activity> activities;

  RunnerBloc({
    @required this.timerBloc,
    @required this.activities,
  })  : assert(timerBloc != null),
        assert(activities != null && activities.length > 0) {
    _timerBlocSubsciption = timerBloc.listen((state) {
      add(UpdateTimeRunner(state.seconds, state.delay));
    });
  }

  @override
  RunnerState get initialState =>
      RunnerWaiting.initial(activity: activities[0]);

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
      yield* _next();
    }

    if (event is BackRunner) {
      yield* _back();
    }

    if (event is FinishedRepetitionRunner) {
      yield* _next();
    }
  }

  Stream<RunnerState> _mapUpdateTimeToState(UpdateTimeRunner event) async* {
    if (state is RunnerRunning) {
      if (state.time + event.delay > state.activity.intervall) {
        yield* _next();
      }
    }
    yield state;
  }

  Stream<RunnerState> _next({int skip}) async* {
    final nextActivity = activities[state.index + 1 + skip];
    if (nextActivity == null) yield RunnerFinished();

    if (nextActivity.isGroup) {
      if (nextActivity.rounds < state.round) {
        final indexOfFirstInGroup = activities.indexWhere(
            (element) => element.groupId == nextActivity.referenceGroupId);

        yield _mapNewActivityToState(
          index: indexOfFirstInGroup,
          activity: activities[indexOfFirstInGroup],
          time: 0,
          round: state.round + 1,
        );
      } else {
        yield* _next(skip: skip + 1);
      }
    } else {
      yield _mapNewActivityToState(
        index: state.index + 1 + skip,
        activity: nextActivity,
        time: 0,
        round: skip != null ? 0 : state.round,
      );
    }
  }

  Stream<RunnerState> _back({int skip}) async* {
    var previousActivity =
        state.index == 0 ? null : activities[state.index - 1];

    if (previousActivity == null && state.round == 0) yield state;

    if (previousActivity.isGroup || previousActivity == null) {
      if (state.round > 0) {
        final groupId = previousActivity == null
            ? state.activity.groupId
            : previousActivity.referenceGroupId;
        final indexOfLastInGroup = activities.reversed
            .toList()
            .indexWhere((element) => element.groupId == groupId);

        yield _mapNewActivityToState(
          index: activities.length - indexOfLastInGroup,
          activity: activities[activities.length - indexOfLastInGroup],
          time: 0,
          round: state.round - 1,
        );
      } else {
        yield* _back(skip: 1);
      }
    } else {
      _mapNewActivityToState(
        index: state.index - 1 - skip,
        activity: previousActivity,
        time: 0,
        round: skip != null ? activities[state.index - skip] : state.round,
      );
    }
  }

  RunnerState _mapNewActivityToState({
    int skipOrRewindTime = 0,
    int round = 0,
    int time = 0,
    Activity activity,
    int index = 0,
  }) {
    if (activity.intervall > 0 && activity.repetitions > 0)
      return RunnerRunningAndWaiting(
        index: state.index + 1,
        activity: activity,
        time: 0,
        round: skip != null ? 0 : state.round,
      );
    if (activity.intervall > 0)
      return RunnerRunning(
        index: state.index + 1,
        activity: activity,
        time: 0,
        round: skip != null ? 0 : state.round,
      );

    return RunnerRunningAndWaiting(
      index: state.index + 1,
      activity: activity,
      time: 0,
      round: skip != null ? 0 : state.round,
    );
  }
}
