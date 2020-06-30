import 'package:fitness_workouts/repositories/exercise_repository/exercise_entity.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

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
