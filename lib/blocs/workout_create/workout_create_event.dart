part of 'workout_create_bloc.dart';

abstract class WorkoutCreateEvent extends Equatable {
  const WorkoutCreateEvent();
  @override
  List<Object> get props => const [];
}

class InitializeWorkout extends WorkoutCreateEvent {
  final String workoutId;
  InitializeWorkout({String workoutId}) : this.workoutId = workoutId ?? "";

  @override
  List<Object> get props => [workoutId];

  @override
  String toString() {
    return 'InitializeWorkout {workoutId: $workoutId }';
  }
}

class UpdateWorkoutPart extends WorkoutCreateEvent {
  final Activity oldPart;
  final Activity newPart;

  UpdateWorkoutPart({
    this.oldPart,
    this.newPart,
  });

  @override
  List<Object> get props => [oldPart, newPart];

  @override
  String toString() {
    return 'UpdateWorkoutPart {oldPart: $oldPart, newPart: $newPart }';
  }
}

class ReorderWorkoutPart extends WorkoutCreateEvent {
  final int oldIndex;
  final int newIndex;

  ReorderWorkoutPart({
    this.oldIndex,
    this.newIndex,
  });

  @override
  List<Object> get props => [oldIndex, newIndex];

  @override
  String toString() {
    return 'ReorderWorkoutPart {oldIndex: $oldIndex, newIndex: $newIndex }';
  }
}

class RemoveWorkoutPart extends WorkoutCreateEvent {
  final Activity workoutPart;

  RemoveWorkoutPart({this.workoutPart});

  @override
  List<Object> get props => [workoutPart];

  @override
  String toString() {
    return 'RemoveWorkoutPart {workoutpart: $workoutPart }';
  }
}

class AddWorkoutPart extends WorkoutCreateEvent {
  final Activity workoutPart;

  AddWorkoutPart({this.workoutPart});

  @override
  List<Object> get props => [workoutPart];

  @override
  String toString() {
    return 'AddWorkoutPart {workoutPart: $workoutPart }';
  }
}

class SelectWorkoutPart extends WorkoutCreateEvent {
  final Activity workoutPart;

  SelectWorkoutPart({this.workoutPart});

  @override
  List<Object> get props => [workoutPart];

  @override
  String toString() {
    return 'SelectWorkoutPart {workoutPart: $workoutPart}';
  }
}

class CopyWorkoutSequence extends WorkoutCreateEvent {
  final WorkoutLevel from;
  final WorkoutLevel to;

  CopyWorkoutSequence({this.from, this.to});

  @override
  List<Object> get props => [from, to];

  @override
  String toString() {
    return 'CopyWorkoutSequence {from: $from, to: $to }';
  }
}

class SwitchLevel extends WorkoutCreateEvent {
  final WorkoutLevel to;
  SwitchLevel({this.to});

  @override
  List<Object> get props => [to];

  @override
  String toString() {
    return 'SwitchLevel {to: $to }';
  }
}

class SetInformation extends WorkoutCreateEvent {
  final String name;
  final String description;

  SetInformation({this.name, this.description});
  @override
  List<Object> get props => [name, description];

  @override
  String toString() {
    return 'SetInformation {name: $name, description: $description }';
  }
}

class Save extends WorkoutCreateEvent {}

enum PausePositions { AfterEveryExercise, AfterEveryRound }

class Generate extends WorkoutCreateEvent {
  final int intervalls;
  final int repetitions;
  final int pause;
  final int rounds;
  final PausePositions pausePosition;
  final List<Exercise> exercises;

  Generate(this.intervalls, this.repetitions, this.pause, this.rounds,
      this.pausePosition, this.exercises);

  @override
  List<Object> get props =>
      [intervalls, repetitions, pause, rounds, pausePosition, exercises];

  @override
  String toString() {
    return 'SwitchLevel {intervalls: $intervalls, repetitions: $repetitions,pause: $pause,rounds: $rounds,pausePosition: $pausePosition, exercises: $exercises}';
  }
}
