import 'package:fitness_workouts/provider/workout_provider.dart';
import 'package:fitness_workouts/screens/timer_view.dart';
import 'package:fitness_workouts/screens/workout_generate_screen.dart';
import 'package:fitness_workouts/screens/workout_list_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../util/tab_entry.dart';

import 'activity_list_view.dart';

class HomeScreen extends StatefulWidget {
  static const String route = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _tabIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: tabs[_tabIndex].view,
      floatingActionButton: tabs[_tabIndex].floatingActionButton,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabIndex,
        onTap: (int index) => setState(() {
          _tabIndex = index;
        }),
        items: tabs.map((tab) => tab.navigationBarItem).toList(),
      ),
    );
  }

  List<TabEntry> get tabs {
    return [
      TabEntry(
        title: 'Exercise',
        icon: Icon(
          Icons.directions_run,
        ),
        view: ActivityListView(),
      ),
      TabEntry(
        title: 'Workout',
        icon: Icon(
          Icons.home,
        ),
        view: WorkoutListView(),
        actionButton: FloatingActionButton(
          onPressed: () {
            final workoutProvider =
                Provider.of<WorkoutProvider>(context, listen: false);
            workoutProvider.createWorkout();
            Navigator.of(context).pushNamed(WorkoutGenerateScreen.route);
          },
          child: Icon(Icons.add),
        ),
      ),
      TabEntry(
        title: 'Timer',
        icon: Icon(
          Icons.timer,
        ),
        view: TimerView(),
      ),
    ];
  }
}
