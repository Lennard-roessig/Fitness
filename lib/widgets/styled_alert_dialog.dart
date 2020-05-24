import 'package:fitness_workouts/widgets/inverted_flat_button.dart';
import 'package:flutter/material.dart';

class StyledAlertDialog extends StatelessWidget {
  final Widget title;
  final Widget content;
  final void Function() onCancel;
  final void Function() onFinish;

  StyledAlertDialog({
    this.title,
    this.content,
    this.onCancel,
    this.onFinish,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          width: 2,
          color: Theme.of(context).accentColor,
        ),
      ),
      title: title,
      content: content,
      actions: <Widget>[
        if (this.onCancel != null)
          InvertedFlatButton(
            child: Text('Cancel'),
            onPressed: this.onCancel,
          ),
        if (this.onFinish != null)
          RaisedButton(
            child: Text('Apply'),
            onPressed: this.onFinish,
            color: Theme.of(context).accentColor,
          ),
      ],
    );
  }
}
