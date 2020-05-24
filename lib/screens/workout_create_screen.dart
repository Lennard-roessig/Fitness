import 'package:fitness_workouts/provider/activity_provider.dart';
import 'package:fitness_workouts/provider/workout_provider.dart';
import 'package:fitness_workouts/widgets/activity_search_delegate.dart';
import 'package:fitness_workouts/widgets/inverted_flat_button.dart';
import 'package:fitness_workouts/widgets/number_input.dart';
import 'package:fitness_workouts/widgets/styled_alert_dialog.dart';
import 'package:fitness_workouts/widgets/workout_part_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flushbar/flushbar.dart';

import '../models.dart';

class WorkoutCreateScreen extends StatefulWidget {
  static const String route = '/workout/create';

  @override
  _WorkoutCreateScreenState createState() => _WorkoutCreateScreenState();
}

class _WorkoutCreateScreenState extends State<WorkoutCreateScreen> {
  WorkoutPart selected;
  var newWorkoutPart;

  GlobalKey<AnimatedListState> animatedList = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Workoute Create'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final result = await openAddDialog(context);
              if (result == null) return;
              showInfoFlushbar(context, 'Choose point to insert',
                  'Please choose an exercise after which the new exercise should be inserted');
              setState(() {
                selected = null;
                newWorkoutPart = result;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Stack(
          children: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: <Widget>[
            //     Container(
            //       margin: EdgeInsets.only(right: 40),
            //       width: 15,
            //       alignment: Alignment.center,
            //       child: Container(
            //         height: double.infinity,
            //         width: 1,
            //         color: Theme.of(context).accentColor,
            //       ),
            //     ),
            //   ],
            // ),
            Consumer<WorkoutProvider>(
              builder: (_, provider, __) => AnimatedList(
                key: animatedList,
                initialItemCount: provider.workout.sequence.length,
                itemBuilder: (_, index, animation) => SizeTransition(
                  sizeFactor: animation,
                  child: Dismissible(
                    key: ValueKey(provider.workout.sequence[index]),
                    // background: Container(color: Colors.red),
                    onDismissed: (direction) {
                      provider
                          .deleteWorkoutPart(provider.workout.sequence[index]);
                      animatedList.currentState.removeItem(
                          index, (context, animation) => SizedBox());
                    },
                    child: WorkoutPartTile(
                      workoutpart: provider.workout.sequence[index],
                      time: provider.timeForIndex(index),
                      menu: selected == provider.workout.sequence[index]
                          ? menu(context, provider.workout.sequence[index])
                          : null,
                      onTap: (part) => onWorkoutpartTab(context, part),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.navigate_next),
      ),
    );
  }

  bool get inAddMode {
    return newWorkoutPart != null;
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
          animatedList.currentState
              .insertItem(workoutProvider.indexOfWorkoutPart(part) + 1);
          selected = newWorkoutPart;
          newWorkoutPart = null;
        } else
          selected = part;
      }
    });
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
              animatedList.currentState
                  .insertItem(workoutProvider.indexOfWorkoutPart(selected) + 1);
            },
          ),
          MenuItem(Icons.timer,
              actionTarget: MenuItemActionTarget.PauseAndActivity, action: () {
            openAlarmDialog();
          }),
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
              Activity choosenActivity = await showSearch(
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
            Icons.repeat,
            actionTarget: MenuItemActionTarget.Activity,
            action: () async {
              double newValue = await openDialog(
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
            Icons.replay,
            actionTarget: MenuItemActionTarget.Group,
            action: () async {
              double newValue = await openDialog(
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
              double newValue = await openDialog(
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
            Icons.delete_outline,
            actionTarget: MenuItemActionTarget.All,
            action: () async {
              bool confirmed = await openConfirmationDialog(context);
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
            .map((e) => iconButton(context, e))
            .toList(),
      ),
    );
  }

  Widget iconButton(BuildContext context, MenuItem menuItem) {
    return Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: menuItem.action == null
            ? Colors.grey
            : Theme.of(context).accentColor,
      ),
      child: InkWell(
        onTap: menuItem.action,
        child: Icon(
          menuItem.icon,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Future<double> openDialog(
      BuildContext context, String title, double initialValue, String suffix,
      {double stepSize = 1}) {
    return showDialog<double>(
      context: context,
      builder: (context) => StyledAlertDialog(
        title: Text(
          title,
          textAlign: TextAlign.center,
        ),
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 110,
            minWidth: 50,
            maxWidth: 60,
          ),
          child: NumberInput(
            initialValue: initialValue,
            stepSize: stepSize,
            type: NumberType.Int,
            suffixLabel: suffix,
            onChange: (newValue) => initialValue = newValue,
          ),
        ),
        onFinish: () => Navigator.of(context).pop(initialValue),
      ),
    );
  }

  Future<bool> openConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => StyledAlertDialog(
        title: Text('Delete?'),
        content:
            Text('Are you sure you want to delete this part of the Workout?'),
        onCancel: () => Navigator.of(context).pop(false),
        onFinish: () => Navigator.of(context).pop(true),
      ),
    );
  }

  Future<WorkoutPart> openAddDialog(BuildContext context) {
    final workoutProvider =
        Provider.of<WorkoutProvider>(context, listen: false);
    return showDialog<WorkoutPart>(
      context: context,
      builder: (context) => StyledAlertDialog(
        title: Text(
          'Choose Art of Part',
          textAlign: TextAlign.center,
        ),
        content: Container(
          width: 250,
          height: 350,
          child: ListView(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.fitness_center),
                title: Text('Exercise'),
                trailing: Icon(Icons.navigate_next),
                onTap: () async {
                  Activity choosenActivity = await showSearch(
                    context: context,
                    delegate: ActivitySearch(
                      mode: ActivitySearchSelectMode.Single,
                    ),
                  );
                  if (choosenActivity == null) return;
                  var newPart = workoutProvider.createNewWorkoutPart();
                  newPart = newPart.copy(activityId: choosenActivity.id);
                  Navigator.of(context).pop(newPart);
                },
              ),
              ListTile(
                leading: Icon(Icons.group),
                title: Text('Round'),
                trailing: Icon(Icons.navigate_next),
                onTap: () {
                  Navigator.of(context)
                      .pop(workoutProvider.createNewGroupPart());
                },
              ),
              ListTile(
                leading: Icon(Icons.pause),
                title: Text('Pause'),
                trailing: Icon(Icons.navigate_next),
                onTap: () async {
                  final pause = workoutProvider.createNewPausePart();
                  double value = await openDialog(
                    context,
                    'Pause Intervall',
                    0,
                    'sec',
                  );
                  Navigator.of(context).pop(
                    pause.copy(
                      intervall: value.toInt(),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              Column(
                children: <Widget>[
                  Text('Predefined Pauses (sec)'),
                  SizedBox(height: 10),
                  Wrap(
                    alignment: WrapAlignment.spaceAround,
                    runSpacing: 10,
                    direction: Axis.horizontal,
                    spacing: 10,
                    children: [5, 10, 20, 30, 45, 60]
                        .map(
                          (e) => InkWell(
                            onTap: () {
                              final pause =
                                  workoutProvider.createNewPausePart();
                              Navigator.of(context)
                                  .pop(pause.copy(intervall: e));
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Theme.of(context).accentColor,
                              ),
                              child: Center(child: Text('$e')),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ],
          ),
        ),
        onCancel: () => Navigator.of(context).pop(),
      ),
    );
  }

  void openAlarmDialog() {
    showDialog(
      context: context,
      builder: (context) => StyledAlertDialog(
        title: Text('Alarm'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final alarm in selected.alarms) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    alarm.label,
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    alarm.relativeTimestamp > 0
                        ? alarm.relativeTimestamp.toString()
                        : alarm.timestamp.toString(),
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    alarm.sound.name,
                    style: TextStyle(fontSize: 14),
                  ),
                  Icon(
                    Icons.done,
                    color: alarm.activ
                        ? Theme.of(context).accentColor
                        : Theme.of(context).primaryColor,
                    size: 18,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
            InvertedFlatButton(
              child: Text('Custom'),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }

  void showInfoFlushbar(BuildContext context, String title, String message) {
    Flushbar(
      backgroundColor: Theme.of(context).primaryColorLight,
      margin: EdgeInsets.all(8),
      borderRadius: 8,
      title: title,
      message: message,
      icon: Icon(
        Icons.info_outline,
        size: 28,
        color: Theme.of(context).primaryColorDark,
      ),
      duration: Duration(seconds: 6),
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.FLOATING,
    )..show(context);
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
