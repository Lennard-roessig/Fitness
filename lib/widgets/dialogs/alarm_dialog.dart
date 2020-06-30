import 'package:fitness_workouts/models/alarm.dart';
import 'package:fitness_workouts/widgets/dialogs/alarm_create_dialog.dart';
import 'package:flutter/material.dart';

import '../inverted_flat_button.dart';
import 'styled_alert_dialog.dart';

class AlarmDialog extends StatefulWidget {
  final List<Alarm> alarms;

  const AlarmDialog({Key key, this.alarms}) : super(key: key);

  @override
  _AlarmDialogState createState() => _AlarmDialogState();
}

class _AlarmDialogState extends State<AlarmDialog> {
  List<Alarm> newAlarms;

  @override
  void didChangeDependencies() {
    newAlarms = widget.alarms;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return StyledAlertDialog(
      title: Text('Alarm'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final alarm in newAlarms) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  alarm.label,
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  alarm.relativeTimestamp > 0
                      ? (alarm.relativeTimestamp * 100).toStringAsFixed(2) + "%"
                      : alarm.timestamp.toString(),
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  alarm.sound.name,
                  style: TextStyle(fontSize: 14),
                ),
                GestureDetector(
                  onTap: () => setState(() {
                    newAlarms = newAlarms
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
              final newAlarm = await showDialog<Alarm>(
                context: context,
                builder: (_) => AlarmCreateDialog(),
              );
              if (newAlarm != null) {
                setState(() {
                  newAlarms = [...newAlarms, newAlarm];
                });
              }
            },
          )
        ],
      ),
      onFinish: () => Navigator.of(context).pop(newAlarms),
    );
  }
}
