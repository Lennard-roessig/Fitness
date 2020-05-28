import 'package:fitness_workouts/provider/activity_provider.dart';
import 'package:fitness_workouts/widgets/styled_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActivityListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ActivityProvider>(
      builder: (_, provider, __) => Column(
        children: <Widget>[
          StyledTextField(
            expands: false,
          ),
          Flexible(
            child: ListView.builder(
              itemCount: provider.activities.length,
              itemBuilder: (_, index) => ListTile(
                title: Text(provider.activities[index].name),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
