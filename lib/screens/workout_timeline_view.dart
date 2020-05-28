import 'package:fitness_workouts/provider/activity_provider.dart';
import 'package:fitness_workouts/provider/workout_provider.dart';
import 'package:fitness_workouts/util/dialogs.dart';
import 'package:fitness_workouts/widgets/activity_search_delegate.dart';
import 'package:fitness_workouts/widgets/inverted_flat_button.dart';
import 'package:fitness_workouts/widgets/menu_icon_button.dart';
import 'package:fitness_workouts/widgets/number_input.dart';
import 'package:fitness_workouts/widgets/sound_field.dart';
import 'package:fitness_workouts/widgets/styled_alert_dialog.dart';
import 'package:fitness_workouts/widgets/styled_text_field.dart';
import 'package:fitness_workouts/widgets/switch_input.dart';
import 'package:fitness_workouts/widgets/workout_part_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models.dart';

class WorkoutTimelineView extends StatefulWidget {
  @override
  _WorkoutTimelineViewState createState() => _WorkoutTimelineViewState();
}

class _WorkoutTimelineViewState extends State<WorkoutTimelineView> {
  WorkoutPart selected;
  var newWorkoutPart;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Consumer<WorkoutProvider>(
        builder: (_, provider, __) => Stack(
          children: <Widget>[
            ReorderableListView(
              children: [
                for (final workoutpart in provider.sequence)
                  WorkoutPartTile(
                    key: ObjectKey(workoutpart),
                    workoutpart: workoutpart,
                    time: provider
                        .timeForIndex(provider.indexOfWorkoutPart(workoutpart)),
                    menu: selected == workoutpart
                        ? menu(context, workoutpart)
                        : null,
                    onTap: (part) => onWorkoutpartTab(context, part),
                  ),
              ],
              onReorder: provider.switchWorkoutpartPosition,
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Consumer<WorkoutProvider>(
                builder: (_, workoutProvider, __) => RaisedButton(
                  child: Icon(Icons.add),
                  onPressed: () async {
                    final result =
                        await workoutPartAddDialog(context, workoutProvider);
                    if (result == null) return;

                    if (workoutProvider.sequence.isEmpty)
                      workoutProvider.addNewWorkoutPart(result, null);
                    else {
                      showInfoFlushbar(context, 'Choose point to insert',
                          'Please choose an exercise after which the new exercise should be inserted');
                      setState(() {
                        selected = null;
                        newWorkoutPart = result;
                      });
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool get inAddMode {
    return newWorkoutPart != null;
  }

  Widget menu(BuildContext context, WorkoutPart part) {
    final workoutProvider =
        Provider.of<WorkoutProvider>(context, listen: false);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MenuItem(
            Icons.control_point_duplicate,
            actionTarget: MenuItemActionTarget.PauseAndActivity,
            action: () {
              workoutProvider.duplicateWorkoutPart(selected);
            },
          ),
          MenuItem(
            Icons.timer,
            actionTarget: MenuItemActionTarget.PauseAndActivity,
            action: () async {
              final listOfAlarms = await openAlarmDialog();
              if (listOfAlarms != null) {
                final newPart = selected.copy(alarms: listOfAlarms);
                workoutProvider.updateWorkoutPart(newPart, selected);
                selected = newPart;
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
                  selected: selected.activityId.isNotEmpty
                      ? [activityProvider.activityById(selected.activityId)]
                      : [],
                ),
              );
              if (choosenActivity == null) return;
              final newPart = selected.copy(activityId: choosenActivity.id);
              workoutProvider.updateWorkoutPart(newPart, selected);
              selected = newPart;
            },
          ),
          MenuItem(
            Icons.replay,
            actionTarget: MenuItemActionTarget.Group,
            action: () async {
              double newValue = await numberInputDialog(
                context,
                'Rounds',
                selected.rounds.toDouble(),
                'rounds',
              );
              if (newValue == null) return;
              final newPart = selected.copy(rounds: newValue.toInt());
              workoutProvider.updateWorkoutPart(newPart, selected);
              selected = newPart;
            },
          ),
          MenuItem(
            Icons.access_time,
            actionTarget: MenuItemActionTarget.PauseAndActivity,
            action: () async {
              double newValue = await numberInputDialog(
                context,
                'Intervall',
                selected.intervall.toDouble(),
                'sec',
              );
              if (newValue == null) return;
              final newPart = selected.copy(intervall: newValue.toInt());
              workoutProvider.updateWorkoutPart(newPart, selected);
              selected = newPart;
            },
          ),
          MenuItem(
            Icons.repeat,
            actionTarget: MenuItemActionTarget.Activity,
            action: () async {
              double newValue = await numberInputDialog(
                context,
                'Repetition',
                selected.repetitions.toDouble(),
                'reps',
              );
              if (newValue == null) return;
              final newPart = selected.copy(repetitions: newValue.toInt());
              workoutProvider.updateWorkoutPart(newPart, selected);
              selected = newPart;
            },
          ),
          MenuItem(
            Icons.delete_outline,
            actionTarget: MenuItemActionTarget.All,
            action: () async {
              bool confirmed = await confirmationDialog(
                  context, 'Delete?', 'You want permantly delete this part?');
              if (confirmed != null && confirmed)
                workoutProvider.deleteWorkoutPart(selected);
            },
          ),
        ]
            .where((element) {
              switch (element.actionTarget) {
                case MenuItemActionTarget.Activity:
                  return !part.isGroup && !part.isPause;
                  break;
                case MenuItemActionTarget.Group:
                  return part.isGroup;
                  break;
                case MenuItemActionTarget.Pause:
                  return part.isPause;
                  break;
                case MenuItemActionTarget.PauseAndActivity:
                  return part.isPause || !part.isGroup;
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

  void onWorkoutpartTab(BuildContext context, WorkoutPart part) {
    setState(() {
      if (selected == part)
        selected = null;
      else {
        if (inAddMode) {
          final workoutProvider =
              Provider.of<WorkoutProvider>(context, listen: false);
          workoutProvider.addNewWorkoutPart(newWorkoutPart, part);
          selected = newWorkoutPart;
          newWorkoutPart = null;
        } else
          selected = part;
      }
    });
  }

  Future<List<Alarm>> openAlarmDialog() {
    List<Alarm> activAlarms = selected.alarms.toList();

    return showDialog<List<Alarm>>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => StyledAlertDialog(
          title: Text('Alarm'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final alarm in activAlarms) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      alarm.label,
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      alarm.relativeTimestamp > 0
                          ? (alarm.relativeTimestamp * 100).toStringAsFixed(2) +
                              "%"
                          : alarm.timestamp.toString(),
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      alarm.sound.name,
                      style: TextStyle(fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: () => setState(() {
                        activAlarms = activAlarms
                            .map(
                                (e) => e == alarm ? e.copy(activ: !e.activ) : e)
                            .toList();
                      }),
                      child: Icon(
                        Icons.done,
                        color: alarm.activ
                            ? Theme.of(context).accentColor
                            : Theme.of(context).primaryColor,
                        size: 18,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
              ],
              InvertedFlatButton(
                child: Text('Custom'),
                onPressed: () async {
                  final newAlarm = await showCustomAlert(context);
                  if (newAlarm != null) {
                    setState(() {
                      activAlarms.add(newAlarm);
                    });
                  }
                },
              )
            ],
          ),
          onFinish: () => Navigator.of(context).pop(activAlarms),
        ),
      ),
    );
  }

  Future<Alarm> showCustomAlert(BuildContext context) {
    String name;
    Sound sound;
    double time;

    const options = const ['sec', '%'];
    String type = 'sec';

    return showDialog<Alarm>(
      context: context,
      builder: (context) => StyledAlertDialog(
        title: Text('Custom Dialog'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Name'),
            StyledTextField(
              expands: false,
              onChange: (newName) => name = newName,
            ),
            SizedBox(
              height: 10,
            ),
            Text('Sound'),
            SoundField(
              onChange: (newSound) => sound = newSound,
            ),
            SizedBox(
              height: 10,
            ),
            Text('Time (% or Sec.)'),
            SizedBox(
              height: 5,
            ),
            Flexible(
              child: FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 50,
                      height: 130,
                      child: NumberInput(
                        onChange: (value) => time = value,
                      ),
                    ),
                    SizedBox(width: 20),
                    Container(
                      width: 50,
                      height: 130,
                      child: SwitchInput(
                        options: options,
                        onChange: (index) => type = options[index],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        onCancel: () => Navigator.of(context).pop(),
        onFinish: () => Navigator.of(context).pop(
          Alarm(
            name,
            true,
            sound,
            type == "sec" ? time.toInt() : 0,
            type == "%" ? (time / 100) : 0,
          ),
        ),
      ),
    );
  }
}

enum MenuItemActionTarget { Activity, Group, Pause, PauseAndActivity, All }

class MenuItem {
  final IconData icon;
  final Function action;
  final MenuItemActionTarget actionTarget;

  MenuItem(
    this.icon, {
    this.action,
    this.actionTarget,
  });
}
