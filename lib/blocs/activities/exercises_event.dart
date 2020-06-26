import 'package:equatable/equatable.dart';

import '../../models.dart';

abstract class ExercisesEvent extends Equatable {
  const ExercisesEvent();

  @override
  List<Object> get props => [];
}

class LoadExercises extends ExercisesEvent {}

class AddExercise extends ExercisesEvent {
  final Exercise exercise;
  const AddExercise(this.exercise);
  @override
  List<Object> get props => [exercise];
  @override
  String toString() {
    return 'AddExercise { Exercise: $exercise }';
  }
}

class UpdatedExercises extends ExercisesEvent {
  final List<Exercise> exercises;
  const UpdatedExercises(this.exercises);
  @override
  List<Object> get props => [exercises];
  @override
  String toString() {
    return 'UpdatedExercises { Exercises: $exercises }';
  }
}
