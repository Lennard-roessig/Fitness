import 'dart:convert';
import 'dart:io';

import 'package:fitness_workouts/model/activities_repository.dart';
import 'package:fitness_workouts/model/activity_entity.dart';
import 'package:flutter/services.dart';

class JsonActivityRepository extends ActivitiesRepository {
  @override
  Future saveActivities(List<ActivityEntity> activities) async {
    final file = await _getLocalFile();

    return file.writeAsString(JsonEncoder().convert({
      'activities': activities.map((activity) => activity.toJson()).toList(),
    }));
  }

  @override
  Future<List<ActivityEntity>> loadActivities() async {
    // final file = await _getLocalFile();
    // final string = await file.readAsString();
    //final json = JsonDecoder().convert(string);
    final string = await loadAsset();
    final jsonReponse = json.decode(string);
    final activities = (jsonReponse['activities'])
        .map<ActivityEntity>((value) => ActivityEntity.fromJson(value))
        .toList();

    return activities;
  }

  Future<File> _getLocalFile() async {
    return File('assets/data/activites.json');
  }

  Future<String> loadAsset() async {
    return await rootBundle.loadString('assets/data/activites.json');
  }
}
