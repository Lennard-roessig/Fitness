import 'package:flutter/material.dart';

class SwitchInput extends StatefulWidget {
  final List<String> options;
  final Function(int value) onChange;

  const SwitchInput({
    Key key,
    this.options,
    this.onChange,
  }) : super(key: key);

  @override
  _SwitchInputState createState() => _SwitchInputState();
}

class _SwitchInputState extends State<SwitchInput> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      child: Column(
        children: <Widget>[
          Container(
            height: 45,
            width: double.infinity,
            child: Center(
              child: FittedBox(
                child: Text(
                  widget.options[_selectedIndex],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: IconButton(
                    color: Theme.of(context).primaryColor,
                    icon: Icon(Icons.navigate_before),
                    onPressed: () => switching(-1),
                  ),
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: IconButton(
                    color: Theme.of(context).primaryColor,
                    icon: Icon(Icons.navigate_next),
                    onPressed: () => switching(1),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void switching(int direction) {
    setState(() {
      _selectedIndex = (_selectedIndex - direction) % widget.options.length;
    });
    if (widget.onChange != null)
      widget.onChange(
        _selectedIndex,
      );
  }
}
