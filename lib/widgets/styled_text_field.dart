import 'package:flutter/material.dart';

class StyledTextField extends StatelessWidget {
  final String suffix;
  final bool expands;
  final Function(String val) onChange;
  final int maxLines;
  final String initialValue;

  const StyledTextField({
    Key key,
    this.initialValue = "",
    this.suffix,
    this.expands = true,
    this.onChange,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController()..text = this.initialValue,
      expands: expands,
      decoration: InputDecoration(
        filled: true,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        fillColor: Theme.of(context).primaryColor,
        suffixText: suffix,
      ),
      maxLines: maxLines,
      cursorColor: Theme.of(context).accentColor,
      enableInteractiveSelection: true,
      onChanged: onChange,
    );
  }
}
