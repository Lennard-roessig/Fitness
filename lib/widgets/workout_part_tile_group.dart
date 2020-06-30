import 'package:fitness_workouts/models/activity.dart';
import 'package:flutter/material.dart';

class WorkoutPartTileGroup extends StatelessWidget {
  final Activity activity;

  WorkoutPartTileGroup({this.activity});

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
                '${activity.rounds} Rounds',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget renderGroupMember(Activity member, bool isLast) {
    String text = isLast ? "" : "-> ";
    if (member.isPause)
      text = 'Pause $text';
    else
      text = "";
    //'${ActivityStreamProvider.activityById(member.activityId)?.name ?? ""} $text';

    return Text(
      text,
      style: TextStyle(fontSize: 11),
    );
  }
}
