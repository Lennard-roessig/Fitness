import 'package:cloud_firestore/cloud_firestore.dart';

class ExerciseEntity {
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

  ExerciseEntity(
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

  Map<String, Object> toJson() {
    return {
      'id': id,
      'name': name,
      'muscleGroup': muscleGroup,
      'primaryMuscles': primaryMuscles,
      'synergistMuscles': synergistMuscles,
      'dynamicStabilizerMuscles': dynamicStabilizerMuscles,
      'force': force,
      'mechanic': mechanic,
      'utility': utility,
      'descriptionPreperation': descriptionPreperation,
      'descriptionExecution': descriptionExecution,
      'equipment': equipment,
      'detailVideoUrl': detailVideoUrl,
      'repetitionVideoUrl': repetitionVideoUrl,
    };
  }

  static ExerciseEntity fromJson(Map<String, Object> json) {
    return ExerciseEntity(
      json['id'] as String,
      json['name'] as String,
      json['muscleGroup'] as String,
      List.from(json['primaryMuscles']),
      List.from(json['synergistMuscles']),
      List.from(json['dynamicStabilizerMuscles']),
      List.from(json['stabilizerMuscles']),
      json['force'] as String,
      json['mechanic'] as String,
      json['utility'] as String,
      json['descriptionPreperation'] as String,
      json['descriptionExecution'] as String,
      List.from(json['equipment']),
      json['detailVideoUrl'] as String,
      json['repetitionVideoUrl'] as String,
    );
  }
}
