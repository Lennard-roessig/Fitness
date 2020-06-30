import 'package:equatable/equatable.dart';
import 'package:fitness_workouts/models/workout.dart';

abstract class WorkoutsState extends Equatable {
  const WorkoutsState();

  @override
  List<Object> get props => [];
}

class WorkoutsLoading extends WorkoutsState {}

class WorkoutsNotLoaded extends WorkoutsState {}

class WorkoutsLoaded extends WorkoutsState {
  final List<Workout> workouts;

  const WorkoutsLoaded([this.workouts = const []]);

  @override
  List<Object> get props => [workouts];

  @override
  String toString() {
    return 'WorkoutsLoaded { workouts $workouts }';
  }
}
