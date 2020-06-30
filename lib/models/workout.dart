import 'dart:collection';

import 'package:fitness_workouts/repositories/workouts_repository/workout_entity.dart';

import 'activity.dart';

enum WorkoutLevel { Beginner, Advanced, Professional }

class Workout {
  final String id;
  final String name;
  final String description;
  final int sets;
  final Map<WorkoutLevel, List<Activity>> _sequences;

  Workout(
    this.id,
    this.name,
    this.description,
    this.sets,
    this._sequences,
  );

  Workout.empty({
    this.id,
    this.name = "",
    this.description = "",
    this.sets = 0,
    Map<WorkoutLevel, List<Activity>> sequence,
  }) : _sequences = sequence != null
            ? HashMap.from({
                WorkoutLevel.Beginner: List<Activity>(),
                WorkoutLevel.Advanced: List<Activity>(),
                WorkoutLevel.Professional: List<Activity>(),
                ...sequence
              })
            : HashMap.from({
                WorkoutLevel.Beginner: List<Activity>(),
                WorkoutLevel.Advanced: List<Activity>(),
                WorkoutLevel.Professional: List<Activity>(),
              });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Workout &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          description == other.description &&
          _sequences == other._sequences &&
          sets == other.sets;

  WorkoutEntity toEntity() {
    return WorkoutEntity(
      this.id,
      this.name,
      this.description,
      this.sets,
      this._sequences[WorkoutLevel.Beginner].map((e) => e.toEntity()).toList(),
      this._sequences[WorkoutLevel.Advanced].map((e) => e.toEntity()).toList(),
      this
          ._sequences[WorkoutLevel.Professional]
          .map((e) => e.toEntity())
          .toList(),
    );
  }

  static Workout fromEntity(WorkoutEntity entity) {
    final map = {
      WorkoutLevel.Beginner:
          entity.beginnerSequence.map((e) => Activity.fromEntity(e)).toList(),
      WorkoutLevel.Advanced:
          entity.advancedSequence.map((e) => Activity.fromEntity(e)).toList(),
      WorkoutLevel.Professional: entity.professionalSequence
          .map((e) => Activity.fromEntity(e))
          .toList(),
    };

    return Workout(
      entity.id,
      entity.name,
      entity.description,
      entity.sets,
      map,
    );
  }

  Workout copy({
    String id,
    String name,
    String description,
    int sets,
    Map<WorkoutLevel, List<Activity>> sequence,
  }) {
    return Workout(
      id ?? this.id,
      name ?? this.name,
      description ?? this.description,
      sets ?? this.sets,
      sequence ?? this._sequences,
    );
  }

  UnmodifiableListView<Activity> sequence(WorkoutLevel level) =>
      UnmodifiableListView(
          _sequences.containsKey(level) ? _sequences[level] : const []);

  UnmodifiableMapView<WorkoutLevel, List<Activity>> get sequenceMap =>
      UnmodifiableMapView(_sequences);
}
