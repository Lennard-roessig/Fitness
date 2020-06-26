import 'dart:async';

import 'package:fitness_workouts/repositories/exercise_repository/reactive_exercise_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models.dart';
import 'exercises_event.dart';
import 'exercises_state.dart';

class ExercisesBloc extends Bloc<ExercisesEvent, ExercisesState> {
  final ReactiveExerciseRepository _exercisesRepository;
  StreamSubscription _exercisesSubscription;

  ExercisesBloc({@required ReactiveExerciseRepository exercisesRepository})
      : assert(exercisesRepository != null),
        _exercisesRepository = exercisesRepository;

  @override
  ExercisesState get initialState => ExercisesLoading();

  @override
  Stream<ExercisesState> mapEventToState(ExercisesEvent event) async* {
    switch (event.runtimeType) {
      case LoadExercises:
        yield* _mapLoadExercisesToState();
        break;
      case AddExercise:
        yield* _mapAddExerciseToState(event);
        break;
      case UpdatedExercises:
        yield* _mapExercisesUpdateToState(event);
        break;
    }
  }

  Stream<ExercisesState> _mapLoadExercisesToState() async* {
    _exercisesSubscription?.cancel();
    _exercisesSubscription =
        _exercisesRepository.exercises().listen((exercises) => add(
              UpdatedExercises(exercises.map(Exercise.fromEntity).toList()),
            ));
  }

  Stream<ExercisesState> _mapExercisesUpdateToState(
      UpdatedExercises event) async* {
    yield ExercisesLoaded(event.exercises);
  }

  Stream<ExercisesState> _mapAddExerciseToState(AddExercise event) async* {
    _exercisesRepository.addNewExercise(event.exercise.toEntity());
  }
}
