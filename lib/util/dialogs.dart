import 'package:fitness_workouts/models.dart';
import 'package:fitness_workouts/provider/workout_provider.dart';
import 'package:fitness_workouts/widgets/activity_search_delegate.dart';
import 'package:fitness_workouts/widgets/number_input.dart';
import 'package:fitness_workouts/widgets/styled_alert_dialog.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

Future<double> numberInputDialog(
  BuildContext context,
  String title,
  double initialValue,
  String suffix, {
  double stepSize = 1,
}) {
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
          minWidth: 100,
          maxWidth: 120,
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

Future<WorkoutPart> workoutPartAddDialog(
    BuildContext context, WorkoutProvider workoutProvider) {
  return showDialog<WorkoutPart>(
    context: context,
    builder: (context) => StyledAlertDialog(
      title: Text(
        'Choose Art of Part',
        textAlign: TextAlign.center,
      ),
      content: Container(
        height: 300,
        width: 250,
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
                Navigator.of(context).pop(workoutProvider.createNewGroupPart());
              },
            ),
            ListTile(
              leading: Icon(Icons.pause),
              title: Text('Pause'),
              trailing: Icon(Icons.navigate_next),
              onTap: () async {
                final pause = workoutProvider.createNewPausePart();
                double value = await numberInputDialog(
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
              mainAxisSize: MainAxisSize.min,
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
                            final pause = workoutProvider.createNewPausePart();
                            Navigator.of(context).pop(pause.copy(intervall: e));
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

Future<bool> confirmationDialog(
    BuildContext context, String title, String content) {
  return showDialog<bool>(
    context: context,
    builder: (context) => StyledAlertDialog(
      title: Text(title),
      content: Text(content),
      onCancel: () => Navigator.of(context).pop(false),
      onFinish: () => Navigator.of(context).pop(true),
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
