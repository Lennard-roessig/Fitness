import 'package:fitness_workouts/models/alarm.dart';
import 'package:fitness_workouts/models/sound.dart';
import 'package:fitness_workouts/widgets/inputs/styled_text_field.dart';
import 'package:fitness_workouts/widgets/inputs/switch_input.dart';
import 'package:flutter/material.dart';

import '../inputs/number_input.dart';
import '../inputs/sound_field.dart';
import 'styled_alert_dialog.dart';

// ignore: must_be_immutable
class AlarmCreateDialog extends StatelessWidget {
  static const options = const ['sec', '%'];
  String name;
  Sound sound;
  double time;
  String type = 'sec';

  @override
  Widget build(BuildContext context) {
    return StyledAlertDialog(
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
    );
  }
}
