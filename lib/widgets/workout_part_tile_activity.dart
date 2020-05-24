import 'package:fitness_workouts/models.dart';
import 'package:fitness_workouts/provider/activity_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkoutPartTileActivity extends StatelessWidget {
  final WorkoutPart workoutPart;

  WorkoutPartTileActivity({this.workoutPart});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Selector<ActivityProvider, String>(
          selector: (_, provider) =>
              provider.activityById(workoutPart.activityId)?.name ??
              "Missing Exericse",
          builder: (_, activityName, __) => SizedBox(
            width: 100,
            child: Text(
              activityName,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        SizedBox(
          width: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Icon(
                Icons.access_time,
                size: 14,
              ),
              Text(workoutPart.intervall.toString()),
            ],
          ),
        ),
        SizedBox(
          width: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Icon(
                Icons.repeat,
                size: 14,
              ),
              Text(
                workoutPart.repetitions.toString(),
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
