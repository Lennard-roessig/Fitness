import 'package:flutter/material.dart';

class InvertedFlatButton extends StatelessWidget {
  final Widget child;
  final void Function() onPressed;

  InvertedFlatButton({
    this.child,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onPressed,
      child: child,
      color: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          width: 1,
          color: Theme.of(context).accentColor,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
