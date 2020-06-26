import 'package:fitness_workouts/models.dart';
import 'package:fitness_workouts/widgets/number_input.dart';
import 'package:fitness_workouts/widgets/styled_alert_dialog.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:fitness_workouts/widgets/styled_text_field.dart';
import 'package:fitness_workouts/widgets/inverted_flat_button.dart';
import 'package:fitness_workouts/widgets/sound_field.dart';
import 'package:fitness_workouts/widgets/switch_input.dart';

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

//  Column(
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 Text('Predefined Pauses (sec)'),
//                 SizedBox(height: 10),
//                 Wrap(
//                   alignment: WrapAlignment.spaceAround,
//                   runSpacing: 10,
//                   direction: Axis.horizontal,
//                   spacing: 10,
//                   children: [5, 10, 20, 30, 45, 60]
//                       .map(
//                         (e) => InkWell(
//                           onTap: () {
//                             final pause = WorkoutPart.pause();
//                             Navigator.of(context).pop(pause.copy(intervall: e));
//                           },
//                           child: Container(
//                             width: 30,
//                             height: 30,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(15),
//                               color: Theme.of(context).accentColor,
//                             ),
//                             child: Center(child: Text('$e')),
//                           ),
//                         ),
//                       )
//                       .toList(),
//                 ),
//               ],
//             ),

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

Future<List<Alarm>> openAlarmDialog(
    BuildContext context, List<Alarm> activAlarms) {
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
                          .map((e) => e == alarm ? e.copy(activ: !e.activ) : e)
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
                    activAlarms = [...activAlarms, newAlarm];
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
      title: Text('Custom Alarm'),
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
          Text('Time'),
          SizedBox(
            height: 5,
          ),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                NumberInput(
                  onChange: (value) => time = value,
                ),
                SizedBox(width: 20),
                SwitchInput(
                  options: options,
                  onChange: (index) => type = options[index],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
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
