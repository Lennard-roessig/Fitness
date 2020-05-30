import 'package:fitness_workouts/models.dart';
import 'package:flutter/material.dart';

class WorkoutPartTilePause extends StatelessWidget {
  final WorkoutPart workoutPart;

  WorkoutPartTilePause({this.workoutPart});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SizedBox(
            width: 100,
            child: Text(
              "Pause",
              style: TextStyle(fontSize: 16),
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
          )
        ],
      ),
    );
  }
}
