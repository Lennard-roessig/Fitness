import 'package:fitness_workouts/model/mutation_value.dart';

import 'alarm_value.dart';

enum ExerciseTarget {
  Endurance,
}

enum ResistanceType { None, Dumbell }

class WorkoutPartValue {
  final int index;
  final int repetitions;
  final int intervall;
  final String groupId;
  final List<MutationValue> mutations;
  final List<AlarmValue> alarms;
  final String referenceGroupId;
  final bool isGroup;
  final int rounds;
  final bool isPause;
  final String activityId;
  final List<ExerciseTarget> target;
  final ResistanceType resistanceType;
  final double resistanceWeight;
  final bool relativeResistanceWeight;

  WorkoutPartValue(
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

  @override
  String toString() {
    return 'WorkoutPartEntity{index: $index, repetitions: $repetitions, intervall: $intervall, groupId: $groupId, mutations: $mutations, alarms: $alarms, target: $target, resistanceType: $resistanceType, resistanceWeight: $resistanceWeight, relativeResistanceWeight: $relativeResistanceWeight, referenceGroupId: $referenceGroupId, isGroup: $isGroup, rounds: $rounds, isPause: $isPause, activityId: $activityId}';
  }

  Map<String, Object> toJson() {
    return {
      'index': index,
      'repetitions': repetitions,
      'groupId': groupId,
      'mutations': mutations.map((e) => e.toJson()).toList(),
      'alarms': alarms.map((e) => e.toJson()).toList(),
      'referenceGroupId': referenceGroupId,
      'isGroup': isGroup,
      'rounds': rounds,
      'isPause': isPause,
      'activityId': activityId,
      'target': target.toString(),
      'resistanceType': resistanceType.toString(),
      'resistanceWeight': resistanceWeight,
      'relativeResistanceWeight': relativeResistanceWeight,
    };
  }

  static WorkoutPartValue fromJson(Map<String, Object> json) {
    return WorkoutPartValue(
      json['index'] as int,
      json['repetitions'] as int,
      json['intervall'] as int,
      json['groupId'] as String,
      (json['mutations'] as List)
          .map((e) => MutationValue.fromJson(e))
          .toList(),
      (json['alarms'] as List).map((e) => AlarmValue.fromJson(e)).toList(),
      json['referenceGroupId'] as String,
      json['isGroup'] as bool,
      json['rounds'] as int,
      json['isPause'] as bool,
      json['activityId'] as String,
      (json['target'] as List)
          .map((e) => getExerciseTargetFromString(e))
          .toList(),
      getResistanceTypeFromString(json['resistanceType']),
      json['resistanceWeight'] as double,
      json['relativeResistanceWeight'] as bool,
    );
  }

  static ResistanceType getResistanceTypeFromString(
      String resistanceTypeString) {
    for (ResistanceType element in ResistanceType.values) {
      if (element.toString() == resistanceTypeString) {
        return element;
      }
    }
    return null;
  }

  static ExerciseTarget getExerciseTargetFromString(
      String exerciseTargetString) {
    for (ExerciseTarget element in ExerciseTarget.values) {
      if (element.toString() == exerciseTargetString) {
        return element;
      }
    }
    return null;
  }
}
