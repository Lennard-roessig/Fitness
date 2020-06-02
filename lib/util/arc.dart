import 'dart:math' as math;

import 'package:flutter/material.dart';

class Arc extends StatelessWidget {
  final double diameter;
  final double percentage;

  const Arc({
    Key key,
    this.diameter = 200,
    this.percentage = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MyPainter(
        percentage: percentage,
        ringColor: Theme.of(context).accentColor,
        ringDefaultColor: Theme.of(context).primaryColor,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      size: Size(diameter, diameter),
    );
  }
}

// This is the Painter class
class MyPainter extends CustomPainter {
  final Color ringColor;
  final Color ringDefaultColor;
  final Color backgroundColor;
  final double percentage;

  MyPainter({
    this.ringColor,
    this.ringDefaultColor,
    this.backgroundColor,
    this.percentage,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final innerHeight2 = size.height - 0;
    final innerWidth2 = size.width - 0;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.height / 2, size.width / 2),
        height: innerHeight2,
        width: innerWidth2,
      ),
      2 * math.pi,
      2 * math.pi,
      true,
      Paint()..color = backgroundColor,
    );

    final innerHeight1 = size.height - 18;
    final innerWidth1 = size.width - 18;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.height / 2, size.width / 2),
        height: innerHeight1,
        width: innerWidth1,
      ),
      2 * math.pi,
      2 * math.pi,
      true,
      Paint()..color = ringDefaultColor,
    );

    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.height / 2, size.width / 2),
        height: innerHeight1,
        width: innerWidth1,
      ),
      -math.pi / 2,
      percentage * math.pi,
      true,
      Paint()..color = ringColor,
    );

    final innerHeight = size.height - 38;
    final innerWidth = size.width - 38;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.height / 2, size.width / 2),
        height: innerHeight,
        width: innerWidth,
      ),
      2 * math.pi,
      2 * math.pi,
      true,
      Paint()..color = backgroundColor,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
