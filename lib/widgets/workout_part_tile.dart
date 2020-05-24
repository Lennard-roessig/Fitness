import 'package:fitness_workouts/provider/workout_provider.dart';
import 'package:fitness_workouts/util/time_format.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models.dart';
import 'workout_part_tile_group.dart';
import 'workout_part_tile_pause.dart';
import 'workout_part_tile_activity.dart';

class WorkoutPartTile extends StatelessWidget {
  final WorkoutPart workoutpart;
  final int time;
  final Widget menu;
  final Function(WorkoutPart) onTap;

  const WorkoutPartTile({
    Key key,
    this.workoutpart,
    this.time,
    this.menu,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<WorkoutProvider, GroupPosition Function(WorkoutPart)>(
      selector: (_, provider) => provider.groupPositionOfWorkout,
      builder: (_, fnc, child) => Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                child,
                ...timeline(context, groupPosition: fnc(workoutpart)),
              ],
            ),
            if (menu != null)
              Row(
                children: <Widget>[
                  Expanded(child: menu),
                  ...timeline(context,
                      menu: true, groupPosition: fnc(workoutpart)),
                ],
              ),
          ],
        ),
      ),
      child: Expanded(
        child: GestureDetector(
          onTap: () => onTap(workoutpart),
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(15)),
            child: showPart,
          ),
        ),
      ),
    );
  }

  Widget get showPart {
    if (workoutpart.isPause)
      return WorkoutPartTilePause(workoutPart: workoutpart);
    if (workoutpart.isGroup)
      return WorkoutPartTileGroup(workoutPart: workoutpart);
    return WorkoutPartTileActivity(workoutPart: workoutpart);
  }

  List<Widget> timeline(BuildContext context,
      {bool menu = false, groupPosition = GroupPosition.None}) {
    const double height = 65;
    const double width = 30;
    return [
      Container(
        margin: EdgeInsets.only(left: 10),
        width: width,
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            if ((workoutpart.groupId.isNotEmpty ||
                    workoutpart.referenceGroupId.isNotEmpty) &&
                (!menu || groupPosition != GroupPosition.Tail))
              Container(
                height: height,
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                        groupPosition == GroupPosition.Head ? 15 : 0),
                    topRight: Radius.circular(
                        groupPosition == GroupPosition.Head ? 15 : 0),
                    bottomRight: Radius.circular(
                        groupPosition == GroupPosition.Tail ? 15 : 0),
                    bottomLeft: Radius.circular(
                        groupPosition == GroupPosition.Tail ? 15 : 0),
                  ),
                  color: Theme.of(context).accentColor,
                ),
              ),
            if ((workoutpart.groupId.isNotEmpty ||
                    workoutpart.referenceGroupId.isNotEmpty) &&
                (!menu || groupPosition != GroupPosition.Tail))
              Container(
                height: groupPosition == GroupPosition.Head ||
                        groupPosition == GroupPosition.Tail
                    ? height - 0.5
                    : height,
                margin: EdgeInsets.only(
                  top: groupPosition == GroupPosition.Head ? 0.5 : 0,
                  bottom: groupPosition == GroupPosition.Tail ? 0.5 : 0,
                ),
                width: (workoutpart.groupId.isNotEmpty ||
                        workoutpart.referenceGroupId.isNotEmpty)
                    ? width - 1
                    : width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                        groupPosition == GroupPosition.Head ? 15 : 0),
                    topRight: Radius.circular(
                        groupPosition == GroupPosition.Head ? 15 : 0),
                    bottomRight: Radius.circular(
                        groupPosition == GroupPosition.Tail ? 15 : 0),
                    bottomLeft: Radius.circular(
                        groupPosition == GroupPosition.Tail ? 15 : 0),
                  ),
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
            if (!menu)
              Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Theme.of(context).accentColor,
                ),
              ),
            Container(
              height: height,
              width: 1,
              color: Theme.of(context).accentColor,
            ),
          ],
        ),
      ),
      SizedBox(
        width: 5,
      ),
      SizedBox(
        width: 30,
        child: Text(
          menu ? "" : formatSecondsIntoMin(time),
          style: TextStyle(fontSize: 11),
        ),
      )
    ];
  }
}

// margin: EdgeInsets.only(
//       left: 10,
//     ),
//     decoration: BoxDecoration(
//       border: Border.all(
//         width: 0.5,
//         color: Theme.of(context).accentColor,
//       ),
//       borderRadius: BorderRadius.only(
//         topLeft: Radius.circular(15),
//         topRight: Radius.circular(15),
//       ),
//     ),
