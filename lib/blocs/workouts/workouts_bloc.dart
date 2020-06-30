import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fitness_workouts/blocs/workouts/workouts.dart';
import 'package:fitness_workouts/models/workout.dart';
import 'package:fitness_workouts/repositories/workouts_repository/reactive_workout_repository.dart';
import 'package:flutter/material.dart';

class WorkoutsBloc extends Bloc<WorkoutsEvent, WorkoutsState> {
  final ReactivWorkoutRepository _workoutsRepository;
  StreamSubscription _workoutsSubscription;

  WorkoutsBloc({@required ReactivWorkoutRepository workoutsRepository})
      : assert(workoutsRepository != null),
        _workoutsRepository = workoutsRepository;

  @override
  WorkoutsState get initialState => WorkoutsLoading();

  @override
  Stream<WorkoutsState> mapEventToState(WorkoutsEvent event) async* {
    switch (event.runtimeType) {
      case LoadWorkouts:
        yield* _mapLoadWorkoutsToState();
        break;
      case AddWorkout:
        yield* _mapAddWorkoutToState(event);
        break;
      case UpdateWorkout:
        yield* _mapUpdateWorkoutToState(event);
        break;
      case UpdatedWorkouts:
        yield* _mapWorkoutsUpdateToState(event);
        break;
    }
  }

  Stream<WorkoutsState> _mapLoadWorkoutsToState() async* {
    _workoutsSubscription?.cancel();
    _workoutsSubscription = _workoutsRepository.workouts().listen((workouts) =>
        add(UpdatedWorkouts(workouts.map(Workout.fromEntity).toList())));
  }

  Stream<WorkoutsState> _mapWorkoutsUpdateToState(
      UpdatedWorkouts event) async* {
    yield WorkoutsLoaded(event.workouts);
  }

  Stream<WorkoutsState> _mapAddWorkoutToState(AddWorkout event) async* {
    _workoutsRepository.addNewWorkout(event.workout.toEntity());
  }

  Stream<WorkoutsState> _mapUpdateWorkoutToState(UpdateWorkout event) async* {
    _workoutsRepository.updateWorkout(event.workout.toEntity());
  }
}
