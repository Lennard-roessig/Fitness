import 'package:flutter/material.dart';

class TimeText extends StatelessWidget {
  final int seconds;
  final TextStyle style;

  const TimeText({Key key, this.seconds, this.style}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      formatSecondsIntoMin(seconds),
      style: style,
    );
  }

  String formatSecondsIntoMin(int seconds) {
    final int minutes = (seconds / 60.0).floorToDouble().toInt();
    final int restSeconds = seconds % 60;

    return '$minutes:${_format(restSeconds)}';
  }

  String _format(int n) {
    return n < 10 ? '0$n' : n.toString();
  }
}
