import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';

import 'exercise_entity.dart';
import 'exercise_repository.dart';

class JsonExerciseRepository extends ExerciseRepository {
  @override
  Future saveExercises(List<ExerciseEntity> exercises) async {
    final file = await _getLocalFile();

    return file.writeAsString(JsonEncoder().convert({
      'exercises': exercises.map((activity) => activity.toJson()).toList(),
    }));
  }

  @override
  Future<List<ExerciseEntity>> loadExercises() async {
    // final file = await _getLocalFile();
    // final string = await file.readAsString();
    //final json = JsonDecoder().convert(string);
    final string = await loadAsset();
    final jsonReponse = json.decode(string);
    final exercises = (jsonReponse['exercises'])
        .map<ExerciseEntity>((value) => ExerciseEntity.fromJson(value))
        .toList();

    return exercises;
  }

  Future<File> _getLocalFile() async {
    return File('assets/data/exercises.json');
  }

  Future<String> loadAsset() async {
    return await rootBundle.loadString('assets/data/exercises.json');
  }
}
