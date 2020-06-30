import 'package:fitness_workouts/models/activity.dart';
import 'package:flutter/material.dart';

class WorkoutPartTileActivity extends StatelessWidget {
  final Activity activity;
  final String name;

  WorkoutPartTileActivity({this.activity, this.name});

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
              name,
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Icon(
                  Icons.repeat,
                  size: 14,
                ),
                Text(
                  activity.repetitions.toString(),
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
