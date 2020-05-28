import 'package:flutter/material.dart';

class TabEntry {
  final Widget view;
  final title;
  final Icon icon;
  final Object data;

  final FloatingActionButton actionButton;

  TabEntry({
    this.view,
    this.title,
    this.icon,
    this.data,
    this.actionButton,
  });

  Widget body() {
    return view;
  }

  BottomNavigationBarItem get navigationBarItem {
    return BottomNavigationBarItem(
      title: Text(title),
      icon: icon,
    );
  }

  FloatingActionButton get floatingActionButton {
    return actionButton;
  }
}
