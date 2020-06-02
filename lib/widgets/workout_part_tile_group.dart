import 'package:fitness_workouts/provider/activity_provider.dart';
import 'package:fitness_workouts/provider/workout_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models.dart';

class WorkoutPartTileGroup extends StatelessWidget {
  final WorkoutPart workoutPart;

  WorkoutPartTileGroup({this.workoutPart});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom:
                  BorderSide(color: Theme.of(context).accentColor, width: 0.5),
            ),
          ),
          child: Row(
            children: <Widget>[
              Spacer(),
              Icon(
                Icons.replay,
                size: 16,
              ),
              SizedBox(width: 8),
              Text(
                '${workoutPart.rounds} Rounds',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget renderGroupMember(
      ActivityProvider activityProvider, WorkoutPart member, bool isLast) {
    String text = isLast ? "" : "-> ";
    if (member.isPause)
      text = 'Pause $text';
    else
      text =
          '${activityProvider.activityById(member.activityId)?.name ?? ""} $text';

    return Text(
      text,
      style: TextStyle(fontSize: 11),
    );
  }
}
