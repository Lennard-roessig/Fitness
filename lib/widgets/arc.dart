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
    final center = Offset(size.height / 2, size.width / 2);
    drawCircle(
      canvas,
      size.height,
      2 * math.pi,
      2 * math.pi,
      center,
      ringDefaultColor,
    );

    drawCircle(
      canvas,
      size.height,
      -math.pi / 2,
      percentage * math.pi,
      center,
      ringColor,
    );

    drawCircle(
      canvas,
      size.height * 0.85,
      2 * math.pi,
      2 * math.pi,
      center,
      backgroundColor,
    );
  }

  void drawCircle(Canvas canvas, double diameter, double startAngle,
      double sweepAngle, Offset center, Color color) {
    canvas.drawArc(
      Rect.fromCenter(
        center: center,
        height: diameter,
        width: diameter,
      ),
      startAngle,
      sweepAngle,
      true,
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(MyPainter oldDelegate) =>
      oldDelegate.percentage != percentage;
}
