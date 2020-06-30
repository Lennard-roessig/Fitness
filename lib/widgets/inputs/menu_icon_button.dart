import 'package:flutter/material.dart';

class MenuIconButton extends StatelessWidget {
  final IconData icon;
  final Function() action;

  const MenuIconButton({
    Key key,
    this.icon,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: action == null ? Colors.grey : Theme.of(context).accentColor,
      ),
      child: InkWell(
        onTap: action,
        child: Icon(
          icon,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
