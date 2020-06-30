import 'dart:collection';

import 'package:fitness_workouts/repositories/workouts_repository/activity_value.dart';
import 'package:uuid/uuid.dart';

import 'alarm.dart';
import 'mutation.dart';

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
