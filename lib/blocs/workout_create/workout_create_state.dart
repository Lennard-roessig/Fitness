part of 'workout_create_bloc.dart';

abstract class WorkoutCreateState extends Equatable {
  @override
  List<Object> get props => [];

  WorkoutCreateState copy();
}

class WorkoutCreateInitial extends WorkoutCreateState {
  @override
  WorkoutCreateInitial copy() => WorkoutCreateInitial();
}

class WorkoutCreateReady extends WorkoutCreateState {
  final Workout workout;
  final WorkoutLevel level;
  final Activity selected;

  WorkoutCreateReady({this.workout, this.level, this.selected});

  UnmodifiableListView<Activity> get currentSequence => workout.sequence(level);

  UnmodifiableListView<WorkoutLevel> get definedSequences =>
      UnmodifiableListView(workout.sequenceMap.keys
          .map((key) => (workout.sequenceMap[key] != null &&
                  workout.sequenceMap[key].isNotEmpty)
              ? key
              : null)
          .where((element) => element != null));

  UnmodifiableListView<WorkoutLevel> get keys =>
      UnmodifiableListView(workout.sequenceMap.keys);

  @override
  WorkoutCreateReady copy(
      {Workout workout, WorkoutLevel level, Activity selected}) {
    return WorkoutCreateReady(
      workout: workout ?? this.workout,
      level: level ?? this.level,
      selected: selected,
    );
  }

  @override
  List<Object> get props => [workout, level, selected];
}
