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
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            SizedBox(
              width: 100,
              child: Text(
                "Round",
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(
              width: 40,
            ),
            SizedBox(
              width: 60,
              child: Text('${workoutPart.rounds} times'),
            )
          ],
        ),
        Selector<WorkoutProvider, List<WorkoutPart>>(
          selector: (_, provider) =>
              provider.getGroupMembers(workoutPart.referenceGroupId) ?? [],
          builder: (_, groupMembers, __) => Consumer<ActivityProvider>(
            builder: (_, activityProvider, __) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Wrap(
                children: groupMembers
                    .map((e) => renderGroupMember(
                        activityProvider, e, e == groupMembers.last))
                    .toList(),
              ),
            ),
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
