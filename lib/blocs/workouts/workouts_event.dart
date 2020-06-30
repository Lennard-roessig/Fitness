import 'package:equatable/equatable.dart';
import 'package:fitness_workouts/models/workout.dart';

abstract class WorkoutsEvent extends Equatable {
  const WorkoutsEvent();

  @override
  List<Object> get props => [];
}

class LoadWorkouts extends WorkoutsEvent {}

class AddWorkout extends WorkoutsEvent {
  final Workout workout;
  const AddWorkout(this.workout);
  @override
  List<Object> get props => [workout];
  @override
  String toString() {
    return 'AddWorkout { workout: $workout }';
  }
}

class UpdateWorkout extends WorkoutsEvent {
  final Workout workout;
  const UpdateWorkout(this.workout);
  @override
  List<Object> get props => [workout];
  @override
  String toString() {
    return 'UpdateWorkout { workout: $workout }';
  }
}

class UpdatedWorkouts extends WorkoutsEvent {
  final List<Workout> workouts;
  const UpdatedWorkouts(this.workouts);
  @override
  List<Object> get props => [workouts];
  @override
  String toString() {
    return 'UpdatedWorkouts { workouts: $workouts }';
  }
}
