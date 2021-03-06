import 'package:fitness_workouts/models/activity.dart';
import 'package:fitness_workouts/models/alarm.dart';
import 'package:fitness_workouts/screens/workout/workout_timeline_view.dart';
import 'package:fitness_workouts/widgets/dialogs/alarm_dialog.dart';
import 'package:fitness_workouts/widgets/time_text.dart';

import 'package:flutter/material.dart';

import '../inputs/exercise/activity_search_delegate.dart';
import '../dialogs/number_input_dialog.dart';
import '../inputs/menu_icon_button.dart';
import 'workout_part_tile_group.dart';
import 'workout_part_tile_pause.dart';
import 'workout_part_tile_activity.dart';

class WorkoutPartTile extends StatelessWidget {
  final void Function(Activity oldPart, Activity newPart) update;
  final void Function(Activity part) add;
  final void Function(Activity part) delete;
  final void Function(Activity part) tab;

  static const double height = 50;
  static const double width = 30;

  final Activity activity;
  final String name;
  final int time;
  final bool isActiv;

  const WorkoutPartTile({
    Key key,
    this.activity,
    this.name,
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
                child: Container(
                  decoration: BoxDecoration(
                    border: activity.isGroup || activity.groupId.isNotEmpty
                        ? Border(
                            left: BorderSide(
                                color: Theme.of(context).accentColor,
                                width: 0.5),
                          )
                        : Border(),
                  ),
                  child: GestureDetector(
                    onTap: () => onTab(context),
                    child: Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) => delete(activity),
                      child: showPart,
                    ),
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
              ],
            ),
        ],
      ),
    );
  }

  bool get activ {
    return isActiv && !activity.isGroup;
  }

  Widget get showPart {
    if (activity.isPause) return WorkoutPartTilePause(activity: activity);
    if (activity.isGroup) return WorkoutPartTileGroup(activity: activity);
    return WorkoutPartTileActivity(activity: activity, name: name);
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
        child: TimeText(
          seconds: time,
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
              add(activity.copy());
            },
          ),
          MenuItem(
            Icons.timer,
            actionTarget: MenuItemActionTarget.PauseAndActivity,
            action: () async {
              final listOfAlarms = await showDialog<List<Alarm>>(
                context: context,
                builder: (_) => AlarmDialog(
                  alarms: activity.alarms,
                ),
              );

              if (listOfAlarms != null) {
                final newPart = activity.copy(alarms: listOfAlarms);
                update(activity, newPart);
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
              final choosenActivity = await showSearch(
                context: context,
                delegate: ExerciseSearch(
                  mode: ExerciseSearchSelectMode.Single,
                  selected: [],
                ),
              );
              if (choosenActivity == null) return;
              final newPart = activity.copy(exerciseId: choosenActivity.id);
              update(activity, newPart);
            },
          ),
          MenuItem(
            Icons.replay,
            actionTarget: MenuItemActionTarget.Group,
            action: () async {
              double newValue = await showDialog<double>(
                context: context,
                builder: (_) => NumberInputDialog(
                  title: 'Rounds',
                  initialValue: activity.rounds.toDouble(),
                  suffix: 'rounds',
                ),
              );

              if (newValue == null) return;
              final newPart = activity.copy(rounds: newValue.toInt());
              update(activity, newPart);
            },
          ),
          MenuItem(
            Icons.access_time,
            actionTarget: MenuItemActionTarget.PauseAndActivity,
            action: () async {
              double newValue = await showDialog<double>(
                context: context,
                builder: (_) => NumberInputDialog(
                  title: 'Intervall',
                  initialValue: activity.intervall.toDouble(),
                  suffix: 'sec',
                ),
              );

              if (newValue == null) return;
              final newPart = activity.copy(intervall: newValue.toInt());
              update(activity, newPart);
            },
          ),
          MenuItem(
            Icons.repeat,
            actionTarget: MenuItemActionTarget.Activity,
            action: () async {
              double newValue = await showDialog<double>(
                context: context,
                builder: (_) => NumberInputDialog(
                  title: 'Repetition',
                  initialValue: activity.repetitions.toDouble(),
                  suffix: 'reps',
                ),
              );
              if (newValue == null) return;
              final newPart = activity.copy(repetitions: newValue.toInt());
              update(activity, newPart);
            },
          ),
        ]
            .where((element) {
              switch (element.actionTarget) {
                case MenuItemActionTarget.Activity:
                  return !activity.isGroup && !activity.isPause;
                  break;
                case MenuItemActionTarget.Group:
                  return activity.isGroup;
                  break;
                case MenuItemActionTarget.Pause:
                  return activity.isPause;
                  break;
                case MenuItemActionTarget.PauseAndActivity:
                  return activity.isPause || !activity.isGroup;
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
    if (activity.isGroup) {
      double newValue = await showDialog<double>(
        context: context,
        builder: (context) => NumberInputDialog(
          title: 'Rounds',
          initialValue: 0,
          suffix: '',
        ),
      );

      if (newValue == null) return;
      final newPart = activity.copy(rounds: newValue.toInt());
      update(activity, newPart);
      return;
    }
    tab(activity);
  }
}
