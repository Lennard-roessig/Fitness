import 'package:fitness_workouts/provider/workout_provider.dart';
import 'package:fitness_workouts/screens/workout_finish_screen.dart';
import 'package:fitness_workouts/screens/workout_timeline_view.dart';
import 'package:fitness_workouts/util/tab_entry.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models.dart';

class WorkoutCreateScreen extends StatefulWidget {
  static const String route = '/workout/create';

  @override
  _WorkoutCreateScreenState createState() => _WorkoutCreateScreenState();
}

class _WorkoutCreateScreenState extends State<WorkoutCreateScreen>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        TabController(initialIndex: 0, length: tabs.length, vsync: this);

    _controller.addListener(() {
      switching(_controller.index);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WorkoutProvider workoutProvider = Provider.of<WorkoutProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Workoute Create'),
        actions: <Widget>[],
        bottom: TabBar(
          controller: _controller,
          tabs: <Tab>[
            for (final tab in tabs)
              Tab(
                text: tab.title,
              ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: [
          for (final tab in tabs)
            WorkoutTimelineView(
              sequence: workoutProvider.getSequence(tab.data),
              updateSequence: (newSequence) {
                workoutProvider.updateWorkoutSequence(newSequence);
              },
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(WorkoutFinishScreen.route);
        },
        child: Icon(Icons.navigate_next),
      ),
    );
  }

  void switching(index) {
    final workoutProvider =
        Provider.of<WorkoutProvider>(context, listen: false);
    workoutProvider.selectLevel(tabs[index].data);
  }

  List<TabEntry> get tabs {
    return [
      TabEntry(
        title: 'Beginner',
        data: WorkoutLevel.Beginner,
        icon: Icon(
          Icons.directions_run,
        ),
      ),
      TabEntry(
        title: 'Advanced',
        data: WorkoutLevel.Advanced,
        icon: Icon(
          Icons.home,
        ),
      ),
      TabEntry(
        title: 'Professional',
        data: WorkoutLevel.Professional,
        icon: Icon(
          Icons.directions_run,
        ),
      ),
    ];
  }
}
