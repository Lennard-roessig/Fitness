import 'package:fitness_workouts/models/activity.dart';
import 'package:flutter/material.dart';

class WorkoutPartTilePause extends StatelessWidget {
  final Activity activity;

  WorkoutPartTilePause({this.activity});

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
                Text(activity.intervall.toString()),
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
