import 'dart:math';

import 'model/alarm_value.dart';
import 'model/workout_entity.dart';
import 'model/activity_entity.dart';
import 'model/mutation_value.dart';
import 'model/sound_value.dart';
import 'model/workout_part_value.dart';

class Activity {
  final String id;
  final String name;
  final String description;
  // Detailed information about the exercise
  final String detailVideoUrl;
  // max 3sec. video only one Repetition (without tone, etc..)
  final String repetitionVideoUrl;
  final ExerciseDifficulty difficulty;
  final List<ExerciseMuscleTarget> primary;
  final List<ExerciseMuscleTarget> supporting;
  final List<Equipment> equipment;

  // for search selection
  final bool selected;

  Activity(
    this.id,
    this.name,
    this.description,
    this.detailVideoUrl,
    this.repetitionVideoUrl,
    this.difficulty,
    this.primary,
    this.supporting,
    this.equipment, {
    this.selected = false,
  });

  @override
  String toString() {
    return 'Activity{id: $id, name: $name, description: $description, detailVideoUrl: $detailVideoUrl, repetitionVideoUrl: $repetitionVideoUrl, difficulty: $difficulty, primary: $primary, supporting: $supporting, equipment: $equipment}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          detailVideoUrl == other.detailVideoUrl &&
          repetitionVideoUrl == other.repetitionVideoUrl &&
          difficulty == other.difficulty &&
          primary == other.primary &&
          supporting == other.supporting &&
          equipment == other.equipment;

  ActivityEntity toEntity() {
    return ActivityEntity(
      this.id,
      this.name,
      this.description,
      this.detailVideoUrl,
      this.repetitionVideoUrl,
      this.difficulty,
      this.primary,
      this.supporting,
      this.equipment,
    );
  }

  static Activity fromEntity(ActivityEntity entity) {
    return Activity(
      entity.id,
      entity.name,
      entity.description,
      entity.detailVideoUrl,
      entity.repetitionVideoUrl,
      entity.difficulty,
      entity.primary,
      entity.supporting,
      entity.equipment,
    );
  }

  Activity copy({
    String id,
    String name,
    String description,
    String detailVideoUrl,
    String repetitionVideoUrl,
    ExerciseDifficulty difficulty,
    List<ExerciseMuscleTarget> primary,
    List<ExerciseMuscleTarget> supporting,
    List<Equipment> equipment,
    bool selected,
  }) {
    return Activity(
      id ?? this.id,
      name ?? this.name,
      description ?? this.description,
      detailVideoUrl ?? this.detailVideoUrl,
      repetitionVideoUrl ?? this.repetitionVideoUrl,
      difficulty ?? this.difficulty,
      primary ?? this.primary,
      supporting ?? this.supporting,
      equipment ?? this.equipment,
      selected: selected ?? this.selected,
    );
  }
}

class Workout {
  final String id;
  final String name;
  final String description;
  final int sets;
  final List<WorkoutPart> sequence;

  Workout(
    this.id,
    this.name,
    this.description,
    this.sets,
    this.sequence,
  );

  Workout.empty(
    this.id, {
    this.name = "",
    this.description = "",
    this.sets = 0,
    this.sequence = const [],
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
          sequence == other.sequence &&
          sets == other.sets;

  WorkoutEntity toEntity() {
    return WorkoutEntity(
      this.id,
      this.name,
      this.description,
      this.sets,
      this.sequence.map((e) => e.toEntity()).toList(),
    );
  }

  static Workout fromEntity(WorkoutEntity entity) {
    return Workout(
      entity.id,
      entity.name,
      entity.description,
      entity.sets,
      entity.sequence.map((e) => WorkoutPart.fromEntity(e)).toList(),
    );
  }

  Workout copy({
    String id,
    String name,
    String description,
    int sets,
    List<WorkoutPart> sequence,
  }) {
    return Workout(
      id ?? this.id,
      name ?? this.name,
      description ?? this.description,
      sets ?? this.sets,
      sequence ?? this.sequence,
    );
  }
}

class WorkoutPart {
  final int index;
  final int repetitions;
  final int intervall;
  final String groupId;
  final List<Alarm> alarms;
  final List<Mutation> mutations;
  final List<ExerciseTarget> target;
  final ResistanceType resistanceType;
  final double resistanceWeight;
  final bool relativeResistanceWeight;
  final String referenceGroupId;
  final bool isGroup;
  final int rounds;
  final bool isPause;
  final String activityId;

  WorkoutPart(
    this.index,
    this.repetitions,
    this.intervall,
    this.groupId,
    this.mutations,
    this.alarms,
    this.referenceGroupId,
    this.isGroup,
    this.rounds,
    this.isPause,
    this.activityId,
    this.target,
    this.resistanceType,
    this.resistanceWeight,
    this.relativeResistanceWeight,
  );

  WorkoutPart.empty({
    this.index = 0,
    this.repetitions = 0,
    this.intervall = 0,
    this.groupId = "",
    this.mutations = const [],
    this.alarms = const [],
    this.referenceGroupId = "",
    this.isGroup = false,
    this.rounds = 0,
    this.isPause = false,
    this.activityId = "",
    this.target,
    this.resistanceType,
    this.resistanceWeight = 0,
    this.relativeResistanceWeight = false,
  });

  WorkoutPartValue toEntity() {
    return WorkoutPartValue(
      this.index,
      this.repetitions,
      this.intervall,
      this.groupId,
      this.mutations.map((e) => e.toEntity()).toList(),
      this.alarms.map((e) => e.toEntity()).toList(),
      this.referenceGroupId,
      this.isGroup,
      this.rounds,
      this.isPause,
      this.activityId,
      this.target,
      this.resistanceType,
      this.resistanceWeight,
      this.relativeResistanceWeight,
    );
  }

  static WorkoutPart fromEntity(WorkoutPartValue entity) {
    return WorkoutPart(
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
      entity.activityId,
      entity.target,
      entity.resistanceType,
      entity.resistanceWeight,
      entity.relativeResistanceWeight,
    );
  }

  WorkoutPart copy({
    int index,
    int repetitions,
    int intervall,
    String groupId,
    List<Alarm> mutations,
    List<Mutation> alarms,
    List<ExerciseTarget> target,
    ResistanceType resistanceType,
    double resistanceWeight,
    bool relativeResistanceWeight,
    String referenceGroupId,
    bool isGroup,
    int rounds,
    bool isPause,
    String activityId,
  }) {
    return WorkoutPart(
      index ?? this.index,
      repetitions ?? this.repetitions,
      intervall ?? this.intervall,
      groupId ?? this.groupId,
      mutations ?? this.mutations,
      alarms ?? this.alarms,
      referenceGroupId ?? this.referenceGroupId,
      isGroup ?? this.isGroup,
      rounds ?? this.rounds,
      isPause ?? this.isPause,
      activityId ?? this.activityId,
      target ?? this.target,
      resistanceType ?? this.resistanceType,
      resistanceWeight ?? this.resistanceWeight,
      relativeResistanceWeight ?? this.relativeResistanceWeight,
    );
  }
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
