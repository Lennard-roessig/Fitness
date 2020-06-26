import 'package:equatable/equatable.dart';

import '../../models.dart';

abstract class ExercisesState extends Equatable {
  const ExercisesState();

  @override
  List<Object> get props => [];
}

class ExercisesLoading extends ExercisesState {}

class ExercisesLoaded extends ExercisesState {
  final List<Exercise> exercises;

  const ExercisesLoaded([this.exercises = const []]);

  @override
  List<Object> get props => [exercises];

  @override
  String toString() {
    return 'ExercisesLoaded { exercises $exercises }';
  }

  Exercise exerciseById(String id) =>
      exercises.singleWhere((element) => element.id == id, orElse: () => null);
}

class ExercisesLoadingFailed extends ExercisesState {}
