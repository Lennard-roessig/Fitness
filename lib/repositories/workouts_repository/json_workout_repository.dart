import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';

import 'workout_entity.dart';
import 'workout_repository.dart';

class JsonWorkoutRepository extends WorkoutRepository {
  @override
  Future<List<WorkoutEntity>> loadWorkouts() async {
    // final file = await _getLocalFile();
    // final string = await file.readAsString();
    // final json = JsonDecoder().convert(string);
    final string = await loadAsset();
    final jsonReponse = json.decode(string);
    final workouts = jsonReponse
        .map<WorkoutEntity>((value) => WorkoutEntity.fromJson(value))
        .toList();
    return workouts;
  }

  @override
  Future saveWorkouts(List<WorkoutEntity> workouts) async {
    final file = await _getLocalFile();

    return file.writeAsString(JsonEncoder().convert(
      workouts.map((workout) => workout.toJson()).toList(),
    ));
  }

  Future<File> _getLocalFile() async {
    return File("assets/data/activites.json");
  }

  Future<String> loadAsset() async {
    return await rootBundle.loadString('assets/data/workouts.json');
  }
}
