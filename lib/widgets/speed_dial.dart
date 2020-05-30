import 'dart:math' as math;

import 'package:flutter/material.dart';

class SpeedDial extends StatefulWidget {
  final List<SpeedDialItem> items;

  const SpeedDial({Key key, this.items}) : super(key: key);

  @override
  _SpeedDialState createState() => _SpeedDialState();
}

class _SpeedDialState extends State<SpeedDial> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.items.length, (int index) {
        Widget child = Container(
          height: 50.0,
          width: 120.0,
          alignment: FractionalOffset.topLeft,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: _controller,
              curve: Interval(0.0, 1.0 - index / widget.items.length / 2.0,
                  curve: Curves.easeOut),
            ),
            child: RaisedButton.icon(
              color: Theme.of(context).accentColor,
              label: widget.items[index].label,
              icon: Icon(widget.items[index].icon, color: Colors.black),
              onPressed: () {
                _controller.reverse();
                widget.items[index].onTab();
              },
            ),
          ),
        );
        return child;
      }).toList()
        ..add(
          RaisedButton(
            color: Theme.of(context).accentColor,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget child) {
                return Transform(
                  transform:
                      Matrix4.rotationZ(_controller.value * 0.5 * math.pi),
                  alignment: FractionalOffset.center,
                  child: Icon(_controller.isDismissed ? Icons.add : Icons.close,
                      color: Colors.black),
                );
              },
            ),
            onPressed: () {
              if (_controller.isDismissed) {
                _controller.forward();
              } else {
                _controller.reverse();
              }
            },
          ),
        ),
    );
  }
}

class SpeedDialItem {
  final IconData icon;
  final Widget label;
  final Function onTab;

  SpeedDialItem(this.icon, this.label, this.onTab);
}
