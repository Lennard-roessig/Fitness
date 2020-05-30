import 'package:fitness_workouts/provider/activity_provider.dart';
import 'package:fitness_workouts/provider/workout_provider.dart';
import 'package:fitness_workouts/screens/workout_timeline_view.dart';
import 'package:fitness_workouts/util/dialogs.dart';
import 'package:fitness_workouts/util/time_format.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models.dart';
import 'activity_search_delegate.dart';
import 'menu_icon_button.dart';
import 'workout_part_tile_group.dart';
import 'workout_part_tile_pause.dart';
import 'workout_part_tile_activity.dart';

class WorkoutPartTile extends StatelessWidget {
  final void Function(WorkoutPart oldPart, WorkoutPart newPart) update;
  final void Function(WorkoutPart part) add;
  final void Function(WorkoutPart part) delete;
  final void Function(WorkoutPart part) tab;

  static const double height = 50;
  static const double width = 30;

  final WorkoutPart workoutpart;
  final int time;
  final bool isActiv;

  const WorkoutPartTile({
    Key key,
    this.workoutpart,
    this.time,
    this.isActiv,
    this.update,
    this.add,
    this.delete,
    this.tab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  onTap: () => onTab(context),
                  child: Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) => delete(workoutpart),
                    child: showPart,
                  ),
                ),
              ),
              timeDot(context),
              timeLabel(context),
            ],
          ),
          if (activ)
            Row(
              children: <Widget>[
                Expanded(
                  child: menu(context),
                ),
                SizedBox(width: 64)
                // ...timelineMenu(
                //     context,
                //     workoutpart.groupId.isNotEmpty &&
                //         provider.groupPositionOfWorkout(workoutpart) !=
                //             GroupPosition.Tail),
              ],
            ),
        ],
      ),
    );
  }

  bool get activ {
    return isActiv && !workoutpart.isGroup;
  }

  Widget get showPart {
    if (workoutpart.isPause)
      return WorkoutPartTilePause(workoutPart: workoutpart);
    if (workoutpart.isGroup)
      return WorkoutPartTileGroup(workoutPart: workoutpart);
    return WorkoutPartTileActivity(workoutPart: workoutpart);
  }

  Widget timeDot(BuildContext context) {
    return Container(
      height: 15,
      width: 15,
      margin: EdgeInsets.only(left: 15, right: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).accentColor),
    );
  }

  Widget timeLabel(BuildContext context) {
    return SizedBox(
      width: 24,
      child: FittedBox(
        child: Text(
          formatSecondsIntoMin(time),
          style: TextStyle(
            color: Theme.of(context).secondaryHeaderColor,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  List<Widget> timelineMenu(BuildContext context, bool isInGroup) {
    return [
      Container(
        margin: EdgeInsets.only(left: 10),
        width: width,
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            if (isInGroup)
              Container(
                height: height,
                width: width,
                decoration: BoxDecoration(
                  border: Border.symmetric(
                    horizontal: BorderSide(
                      color: Theme.of(context).accentColor,
                      width: 0.5,
                    ),
                  ),
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
        width: 35,
      )
    ];
  }

  Widget menu(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MenuItem(
            Icons.control_point_duplicate,
            actionTarget: MenuItemActionTarget.PauseAndActivity,
            action: () {
              add(workoutpart.copy());
            },
          ),
          MenuItem(
            Icons.timer,
            actionTarget: MenuItemActionTarget.PauseAndActivity,
            action: () async {
              final listOfAlarms =
                  await openAlarmDialog(context, workoutpart.alarms);
              if (listOfAlarms != null) {
                final newPart = workoutpart.copy(alarms: listOfAlarms);
                update(workoutpart, newPart);
              }
            },
          ),
          MenuItem(
            Icons.show_chart,
            actionTarget: MenuItemActionTarget.Activity,
          ),
          MenuItem(
            Icons.directions_run,
            actionTarget: MenuItemActionTarget.Activity,
            action: () async {
              final activityProvider =
                  Provider.of<ActivityProvider>(context, listen: false);
              final choosenActivity = await showSearch(
                context: context,
                delegate: ActivitySearch(
                  mode: ActivitySearchSelectMode.Single,
                  selected: workoutpart.activityId.isNotEmpty
                      ? [activityProvider.activityById(workoutpart.activityId)]
                      : [],
                ),
              );
              if (choosenActivity == null) return;
              final newPart = workoutpart.copy(activityId: choosenActivity.id);
              update(workoutpart, newPart);
            },
          ),
          MenuItem(
            Icons.replay,
            actionTarget: MenuItemActionTarget.Group,
            action: () async {
              double newValue = await numberInputDialog(
                context,
                'Rounds',
                workoutpart.rounds.toDouble(),
                'rounds',
              );
              if (newValue == null) return;
              final newPart = workoutpart.copy(rounds: newValue.toInt());
              update(workoutpart, newPart);
            },
          ),
          MenuItem(
            Icons.access_time,
            actionTarget: MenuItemActionTarget.PauseAndActivity,
            action: () async {
              double newValue = await numberInputDialog(
                context,
                'Intervall',
                workoutpart.intervall.toDouble(),
                'sec',
              );
              if (newValue == null) return;
              final newPart = workoutpart.copy(intervall: newValue.toInt());
              update(workoutpart, newPart);
            },
          ),
          MenuItem(
            Icons.repeat,
            actionTarget: MenuItemActionTarget.Activity,
            action: () async {
              double newValue = await numberInputDialog(
                context,
                'Repetition',
                workoutpart.repetitions.toDouble(),
                'reps',
              );
              if (newValue == null) return;
              final newPart = workoutpart.copy(repetitions: newValue.toInt());
              update(workoutpart, newPart);
            },
          ),
          // MenuItem(
          //   Icons.delete_outline,
          //   actionTarget: MenuItemActionTarget.All,
          //   action: () async {
          //     bool confirmed = await confirmationDialog(
          //         context, 'Delete?', 'You want permantly delete this part?');
          //     if (confirmed != null && confirmed) delete(workoutpart);
          //   },
          // ),
        ]
            .where((element) {
              switch (element.actionTarget) {
                case MenuItemActionTarget.Activity:
                  return !workoutpart.isGroup && !workoutpart.isPause;
                  break;
                case MenuItemActionTarget.Group:
                  return workoutpart.isGroup;
                  break;
                case MenuItemActionTarget.Pause:
                  return workoutpart.isPause;
                  break;
                case MenuItemActionTarget.PauseAndActivity:
                  return workoutpart.isPause || !workoutpart.isGroup;
                  break;
                case MenuItemActionTarget.All:
                default:
                  return true;
                  break;
              }
            })
            .map((e) => MenuIconButton(
                  action: e.action,
                  icon: e.icon,
                ))
            .toList(),
      ),
    );
  }

  void onTab(BuildContext context) async {
    if (workoutpart.isGroup) {
      print(workoutpart.rounds);
      double newValue = await numberInputDialog(
        context,
        'Rounds',
        workoutpart.rounds.toDouble(),
        '',
      );
      if (newValue == null) return;
      final newPart = workoutpart.copy(rounds: newValue.toInt());
      update(workoutpart, newPart);
      return;
    }
    tab(workoutpart);
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
