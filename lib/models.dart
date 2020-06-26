import 'dart:collection';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

import 'repositories/exercise_repository/exercise_entity.dart';
import 'repositories/workouts_repository/activity_value.dart';
import 'repositories/workouts_repository/alarm_value.dart';
import 'repositories/workouts_repository/mutation_value.dart';
import 'repositories/workouts_repository/sound_value.dart';
import 'repositories/workouts_repository/workout_entity.dart';

class Exercise {
  final String id;
  final String name;

  final String muscleGroup;
  final List<String> primaryMuscles;
  final List<String> synergistMuscles;
  final List<String> dynamicStabilizerMuscles;
  final List<String> stabilizerMuscles;

  final String force;
  final String mechanic;
  final String utility;

  final String descriptionPreperation;
  final String descriptionExecution;

  final List<String> equipment;

  // Detailed information about the exercise
  final String detailVideoUrl;
  // max 3sec. video only one Repetition (without tone, etc..)
  final String repetitionVideoUrl;

  Exercise(
    this.id,
    this.name,
    this.muscleGroup,
    this.primaryMuscles,
    this.synergistMuscles,
    this.dynamicStabilizerMuscles,
    this.stabilizerMuscles,
    this.force,
    this.mechanic,
    this.utility,
    this.descriptionPreperation,
    this.descriptionExecution,
    this.equipment,
    this.detailVideoUrl,
    this.repetitionVideoUrl,
  );

  Exercise.empty({
    String id,
    @required this.name,
    @required this.muscleGroup,
    this.primaryMuscles = const [],
    this.synergistMuscles = const [],
    this.dynamicStabilizerMuscles = const [],
    this.stabilizerMuscles = const [],
    this.force = "",
    this.mechanic = "",
    this.utility = "",
    @required this.descriptionPreperation,
    @required this.descriptionExecution,
    @required this.equipment,
    this.detailVideoUrl = "",
    this.repetitionVideoUrl = "",
  })  : this.id = id ?? Uuid().v4(),
        assert(name != null && name.isNotEmpty);

  ExerciseEntity toEntity() {
    return ExerciseEntity(
      this.id,
      this.name,
      this.muscleGroup,
      this.primaryMuscles,
      this.synergistMuscles,
      this.dynamicStabilizerMuscles,
      this.stabilizerMuscles,
      this.force,
      this.mechanic,
      this.utility,
      this.descriptionPreperation,
      this.descriptionExecution,
      this.equipment,
      this.detailVideoUrl,
      this.repetitionVideoUrl,
    );
  }

  static Exercise fromEntity(ExerciseEntity entity) {
    return Exercise(
      entity.id,
      entity.name,
      entity.muscleGroup,
      entity.primaryMuscles,
      entity.synergistMuscles,
      entity.dynamicStabilizerMuscles,
      entity.stabilizerMuscles,
      entity.force,
      entity.mechanic,
      entity.utility,
      entity.descriptionPreperation,
      entity.descriptionExecution,
      entity.equipment,
      entity.detailVideoUrl,
      entity.repetitionVideoUrl,
    );
  }

  Exercise copy({
    String id,
    String name,
    String muscleGroup,
    List<String> primaryMuscles,
    List<String> synergistMuscles,
    List<String> dynamicStabilizerMuscles,
    List<String> stabilizerMuscles,
    String force,
    String mechanic,
    String utility,
    String descriptionPreperation,
    String descriptionExecution,
    List<String> equipment,
    String detailVideoUrl,
    String repetitionVideoUrl,
  }) {
    return Exercise(
      id ?? this.id,
      name ?? this.name,
      muscleGroup ?? this.muscleGroup,
      primaryMuscles ?? this.primaryMuscles,
      synergistMuscles ?? this.synergistMuscles,
      dynamicStabilizerMuscles ?? this.dynamicStabilizerMuscles,
      stabilizerMuscles ?? this.stabilizerMuscles,
      force ?? this.force,
      mechanic ?? this.mechanic,
      utility ?? this.utility,
      descriptionPreperation ?? this.descriptionPreperation,
      descriptionExecution ?? this.descriptionExecution,
      equipment ?? this.equipment,
      detailVideoUrl ?? this.detailVideoUrl,
      repetitionVideoUrl ?? this.repetitionVideoUrl,
    );
  }
}

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

class Activity {
  final int index;
  final int repetitions;
  final int intervall;
  final String groupId;
  final List<Alarm> _alarms;
  final List<Mutation> _mutations;
  final List<ExerciseTarget> _target;
  final ResistanceType resistanceType;
  final double resistanceWeight;
  final bool relativeResistanceWeight;
  final String referenceGroupId;
  final bool isGroup;
  final int rounds;
  final bool isPause;
  final String exerciseId;

  Activity(
    this.index,
    this.repetitions,
    this.intervall,
    this.groupId,
    this._mutations,
    this._alarms,
    this.referenceGroupId,
    this.isGroup,
    this.rounds,
    this.isPause,
    this.exerciseId,
    this._target,
    this.resistanceType,
    this.resistanceWeight,
    this.relativeResistanceWeight,
  );

  Activity.empty({
    this.index = 0,
    this.repetitions = 0,
    this.intervall = 0,
    this.groupId = "",
    List<Mutation> mutations = const [],
    final List<Alarm> alarms = const [],
    this.referenceGroupId = "",
    this.isGroup = false,
    this.rounds = 0,
    this.isPause = false,
    this.exerciseId = "",
    final List<ExerciseTarget> target,
    this.resistanceType,
    this.resistanceWeight = 0,
    this.relativeResistanceWeight = false,
  })  : this._mutations = mutations,
        this._alarms = alarms,
        this._target = target;

  Activity.pause({
    this.index = 0,
    this.repetitions = 0,
    this.intervall = 0,
    this.groupId = "",
    List<Mutation> mutations = const [],
    final List<Alarm> alarms = const [],
    this.referenceGroupId = "",
    this.isGroup = false,
    this.rounds = 0,
    this.isPause = true,
    this.exerciseId = "",
    final List<ExerciseTarget> target,
    this.resistanceType,
    this.resistanceWeight = 0,
    this.relativeResistanceWeight = false,
  })  : this._mutations = mutations,
        this._alarms = alarms,
        this._target = target;

  Activity.group({
    this.index = 0,
    this.repetitions = 0,
    this.intervall = 0,
    this.groupId = "",
    List<Mutation> mutations = const [],
    final List<Alarm> alarms = const [],
    String referenceGroupId,
    this.isGroup = true,
    this.rounds = 1,
    this.isPause = false,
    this.exerciseId = "",
    final List<ExerciseTarget> target,
    this.resistanceType,
    this.resistanceWeight = 0,
    this.relativeResistanceWeight = false,
  })  : this._mutations = mutations,
        this._alarms = alarms,
        this._target = target,
        this.referenceGroupId = referenceGroupId ?? Uuid().v4();

  ActivityValue toEntity() {
    return ActivityValue(
      this.index,
      this.repetitions,
      this.intervall,
      this.groupId,
      this._mutations.map((e) => e.toEntity()).toList(),
      this._alarms.map((e) => e.toEntity()).toList(),
      this.referenceGroupId,
      this.isGroup,
      this.rounds,
      this.isPause,
      this.exerciseId,
      this._target,
      this.resistanceType,
      this.resistanceWeight,
      this.relativeResistanceWeight,
    );
  }

  static Activity fromEntity(ActivityValue entity) {
    return Activity(
      entity.index,
      entity.repetitions,
      entity.intervall,
      entity.groupId,
      entity.mutations.map((e) => Mutation.fromEntity(e)).toList(),
      entity.alarms.map((e) => Alarm.fromEntity(e)).toList(),
      entity.referenceGroupId,
      entity.isGroup,
      entity.rounds,
      entity.isPause,
      entity.exerciseId,
      entity.target,
      entity.resistanceType,
      entity.resistanceWeight,
      entity.relativeResistanceWeight,
    );
  }

  Activity copy({
    int index,
    int repetitions,
    int intervall,
    String groupId,
    List<Mutation> mutations,
    List<Alarm> alarms,
    List<ExerciseTarget> target,
    ResistanceType resistanceType,
    double resistanceWeight,
    bool relativeResistanceWeight,
    String referenceGroupId,
    bool isGroup,
    int rounds,
    bool isPause,
    String exerciseId,
  }) {
    return Activity(
      index ?? this.index,
      repetitions ?? this.repetitions,
      intervall ?? this.intervall,
      groupId ?? this.groupId,
      mutations ?? this._mutations,
      alarms ?? this._alarms,
      referenceGroupId ?? this.referenceGroupId,
      isGroup ?? this.isGroup,
      rounds ?? this.rounds,
      isPause ?? this.isPause,
      exerciseId ?? this.exerciseId,
      target ?? this._target,
      resistanceType ?? this.resistanceType,
      resistanceWeight ?? this.resistanceWeight,
      relativeResistanceWeight ?? this.relativeResistanceWeight,
    );
  }

  UnmodifiableListView<Alarm> get alarms => UnmodifiableListView(this._alarms);
  UnmodifiableListView<Mutation> get mutations =>
      UnmodifiableListView(this._mutations);
  UnmodifiableListView<ExerciseTarget> get target =>
      UnmodifiableListView(this._target);
}

class Alarm {
  final String label;
  final bool activ;
  final Sound sound;
  final int timestamp;
  final double relativeTimestamp;

  Alarm(
    this.label,
    this.activ,
    this.sound,
    this.timestamp,
    this.relativeTimestamp,
  );

  Alarm copy({
    String label,
    bool activ,
    Sound sound,
    int timestamp,
    double relativeTimestamp,
  }) {
    return Alarm(
      label ?? this.label,
      activ ?? this.activ,
      sound ?? this.sound,
      timestamp ?? this.timestamp,
      relativeTimestamp ?? this.relativeTimestamp,
    );
  }

  AlarmValue toEntity() {
    return AlarmValue(this.label, this.activ, this.sound.toEntity(),
        this.timestamp, this.relativeTimestamp);
  }

  static Alarm fromEntity(AlarmValue entity) {
    return Alarm(entity.label, entity.activ, Sound.fromEntity(entity.sound),
        entity.timestamp, entity.relativeTimestamp);
  }
}

class Mutation {
  final MutationType type;
  final MutationTarget mutationTarget;
  final int max;
  final int min;
  final List<Point<int>> points;

  Mutation(
    this.type,
    this.mutationTarget,
    this.max,
    this.min,
    this.points,
  );

  MutationValue toEntity() {
    return MutationValue(
      this.type,
      this.mutationTarget,
      this.max,
      this.min,
      this.points,
    );
  }

  static Mutation fromEntity(MutationValue entity) {
    return Mutation(
      entity.type,
      entity.mutationTarget,
      entity.max,
      entity.min,
      entity.points,
    );
  }
}

class Sound {
  final String name;
  final String path;
  final bool local;

  Sound(
    this.name,
    this.path,
    this.local,
  );

  SoundValue toEntity() {
    return SoundValue(
      this.name,
      this.path,
      this.local,
    );
  }

  static Sound fromEntity(SoundValue entity) {
    return Sound(
      entity.name,
      entity.path,
      entity.local,
    );
  }
}
