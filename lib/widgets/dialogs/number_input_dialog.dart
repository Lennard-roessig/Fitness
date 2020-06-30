import 'package:flutter/material.dart';

import '../number_input.dart';
import 'styled_alert_dialog.dart';

class NumberInputDialog extends StatelessWidget {
  final String title;
  final String suffix;
  final double stepSize;

  double initialValue;

  NumberInputDialog({
    Key key,
    @required this.title,
    @required this.initialValue,
    @required this.suffix,
    this.stepSize = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StyledAlertDialog(
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
    );
  }
}
