import 'dart:async';
import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fitness_workouts/blocs/workouts/workouts.dart';
import 'package:fitness_workouts/models/activity.dart';
import 'package:fitness_workouts/models/exercise.dart';
import 'package:fitness_workouts/models/workout.dart';
import 'package:flutter/material.dart';

part 'workout_create_event.dart';
part 'workout_create_state.dart';

class WorkoutCreateBloc extends Bloc<WorkoutCreateEvent, WorkoutCreateState> {
  final WorkoutsBloc _workoutsBloc;
  //final StreamSubscription _workoutSubscription;

  WorkoutCreateBloc({
    @required WorkoutsBloc workoutsBloc,
  })  : assert(workoutsBloc != null),
        _workoutsBloc = workoutsBloc;

  @override
  WorkoutCreateState get initialState => WorkoutCreateInitial();

  @override
  Stream<WorkoutCreateState> mapEventToState(WorkoutCreateEvent event) async* {
    print(event.toString());
    switch (event.runtimeType) {
      case InitializeWorkout:
        yield* _mapInitializeWorkoutToState(event);
        break;
      case SelectWorkoutPart:
        yield* _mapSelectWorkoutToState(event);
        break;
      case UpdateWorkoutPart:
        yield* _mapUpdateWorkoutToState(event);
        break;
      case ReorderWorkoutPart:
        yield* _mapReorderWorkoutToState(event);
        break;
      case RemoveWorkoutPart:
        yield* _mapRemoveWorkoutToState(event);
        break;
      case AddWorkoutPart:
        yield* _mapAddWorkoutToState(event);
        break;
      case CopyWorkoutSequence:
        yield* _mapCopyWorkoutToState(event);
        break;
      case SwitchLevel:
        yield (state as WorkoutCreateReady)
            .copy(level: (event as SwitchLevel).to);
        break;
      case Generate:
        yield* _mapGeneratorToState(event);
        break;
      case Save:
        yield* _mapSaveToState();
        break;
      case SetInformation:
        yield* _mapInformationToState(event);
        break;
    }
  }

  Stream<WorkoutCreateState> _mapInformationToState(
      SetInformation event) async* {
    final readyState = (state as WorkoutCreateReady);
    yield readyState.copy(
        workout: readyState.workout
            .copy(description: event.description, name: event.name));
  }

  Stream<WorkoutCreateState> _mapSelectWorkoutToState(
      SelectWorkoutPart event) async* {
    final readyState = (state as WorkoutCreateReady);
    yield readyState.copy(
        selected: readyState.selected == event.workoutPart
            ? null
            : event.workoutPart);
  }

  Stream<WorkoutCreateState> _mapGeneratorToState(Generate event) async* {
    var sequence = event.exercises
        .map((element) => Activity.empty().copy(
              exerciseId: element.id,
              intervall: event.intervalls,
              repetitions: event.repetitions,
            ))
        .expand((element) {
      if (event.pausePosition == PausePositions.AfterEveryExercise &&
          event.pause > 0)
        return [element, Activity.pause(intervall: event.pause)];

      return [element];
    });

    Activity group;
    if (event.rounds > 0) {
      if (event.pausePosition == PausePositions.AfterEveryRound &&
          event.pause > 0)
        sequence = [...sequence, Activity.pause(intervall: event.pause)];

      group = Activity.group(rounds: event.rounds);
      sequence = [...sequence, group];
    }

    final readyState = state as WorkoutCreateReady;
    final newSeq =
        _updateAllGroups([...readyState.currentSequence, ...sequence]);
    yield readyState.copy(
      workout: readyState.workout.copy(
        sequence: {
          ...readyState.workout.sequenceMap,
          readyState.level: newSeq,
        },
      ),
    );
  }

  Stream<WorkoutCreateState> _mapSaveToState() async* {
    final readyState = state as WorkoutCreateReady;
    if (readyState.workout.id == null || readyState.workout.id.isEmpty) {
      _workoutsBloc.add(AddWorkout(readyState.workout));
    } else {
      _workoutsBloc.add(UpdateWorkout(readyState.workout));
    }
  }

  Stream<WorkoutCreateState> _mapCopyWorkoutToState(
      CopyWorkoutSequence event) async* {
    final readyState = state as WorkoutCreateReady;
    yield readyState.copy(
      workout: readyState.workout.copy(sequence: {
        ...readyState.workout.sequenceMap,
        event.to: [...readyState.workout.sequence(event.from)]
      }),
    );
  }

  Stream<WorkoutCreateState> _mapAddWorkoutToState(
      AddWorkoutPart event) async* {
    final sequence = (state as WorkoutCreateReady).currentSequence;
    final selected = (state as WorkoutCreateReady).selected;

    var index = -1;
    if (selected != null) {
      index = sequence.indexOf(selected);
    }
    final position = index >= 0 ? index : sequence.length;

    var newSeq = [
      ...sequence.sublist(0, position),
      event.workoutPart,
      ...(position != sequence.length
          ? sequence.sublist(position, sequence.length)
          : List<Activity>()),
    ];

    newSeq = _updateAllGroups(newSeq);

    final readyState = state as WorkoutCreateReady;
    yield readyState.copy(
      workout: readyState.workout.copy(sequence: {
        ...readyState.workout.sequenceMap,
        readyState.level: newSeq
      }),
      selected: newSeq[position],
    );
  }

  Stream<WorkoutCreateState> _mapRemoveWorkoutToState(
      RemoveWorkoutPart event) async* {
    final readyState = state as WorkoutCreateReady;
    var newSeq = readyState.currentSequence
        .where((element) => element != event.workoutPart)
        .toList();

    if (event.workoutPart.isGroup) {
      newSeq = _updateAllGroups(newSeq);
    }

    yield readyState.copy(
        workout: readyState.workout.copy(sequence: {
      ...readyState.workout.sequenceMap,
      readyState.level: newSeq
    }));
  }

  Stream<WorkoutCreateState> _mapReorderWorkoutToState(
      ReorderWorkoutPart event) async* {
    final readyState = state as WorkoutCreateReady;
    var newSeq = readyState.currentSequence
        .where((x) => x != readyState.currentSequence[event.oldIndex])
        .toList();
    newSeq = [
      ...newSeq.sublist(0, event.newIndex),
      readyState.currentSequence[event.oldIndex],
      ...newSeq.sublist(event.newIndex, newSeq.length)
    ];

    newSeq = _updateAllGroups(newSeq);
    yield readyState.copy(
      workout: readyState.workout.copy(sequence: {
        ...readyState.workout.sequenceMap,
        readyState.level: newSeq
      }),
      selected: newSeq[event.newIndex],
    );
  }

  Stream<WorkoutCreateState> _mapUpdateWorkoutToState(
      UpdateWorkoutPart event) async* {
    final readyState = state as WorkoutCreateReady;
    final newSeq = readyState.currentSequence
        .map((x) => x == event.oldPart ? event.newPart : x)
        .toList();

    yield readyState.copy(
        workout: readyState.workout.copy(sequence: {
      ...readyState.workout.sequenceMap,
      readyState.level: newSeq
    }));
  }

  Stream<WorkoutCreateState> _mapInitializeWorkoutToState(
      InitializeWorkout event) async* {
    if (event.workoutId != null && event.workoutId.isNotEmpty) {
      final workout = (_workoutsBloc.state as WorkoutsLoaded)
          .workouts
          .singleWhere((element) => element.id == event.workoutId);

      yield WorkoutCreateReady(
        workout: workout,
        level: WorkoutLevel.Beginner,
      );
    } else
      yield WorkoutCreateReady(
        workout: Workout.empty(),
        level: WorkoutLevel.Beginner,
      );
  }

  List<Activity> _updateAllGroups(List<Activity> list) {
    var groupId = "";

    return list.reversed
        .map((part) {
          if (part.isGroup) {
            groupId = part.referenceGroupId;
          } else if (part.groupId != groupId) {
            return part.copy(groupId: groupId);
          }
          return part;
        })
        .toList()
        .reversed
        .toList();
  }
}
