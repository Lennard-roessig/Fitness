import 'package:fitness_workouts/widgets/dialogs/styled_alert_dialog.dart';
import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;

  const ConfirmationDialog({Key key, this.title, this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StyledAlertDialog(
      title: Text(title),
      content: Text(content),
      actionbar: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          RaisedButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          RaisedButton(
            child: Text('Ok'),
            onPressed: () => Navigator.of(context).pop(true),
          )
        ],
      ),
    );
  }
}
