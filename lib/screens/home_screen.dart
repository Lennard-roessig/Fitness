import 'package:fitness_workouts/provider/workout_provider.dart';
import 'package:fitness_workouts/screens/timer_view.dart';
import 'package:fitness_workouts/screens/workout_generate_screen.dart';
import 'package:fitness_workouts/screens/workout_list_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'exercise_list_view.dart';
import 'workout_create_screen.dart';

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

  List<Tab> get tabs {
    return [
      Tab(
        title: 'Exercise',
        icon: Icon(
          Icons.directions_run,
        ),
        view: ExerciseListView(),
      ),
      Tab(
        title: 'Workout',
        icon: Icon(
          Icons.home,
        ),
        view: WorkoutListView(),
        actionButton: FloatingActionButton(
          onPressed: () {
            Provider.of<WorkoutProvider>(context, listen: false)
                .createWorkout();
            Navigator.of(context).pushNamed(WorkoutGenerateScreen.route);
          },
          child: Icon(Icons.add),
        ),
      ),
      Tab(
        title: 'Timer',
        icon: Icon(
          Icons.timer,
        ),
        view: TimerView(),
      ),
    ];
  }
}

class Tab {
  final Widget view;
  final title;
  final Icon icon;

  final FloatingActionButton actionButton;

  Tab({this.view, this.title, this.icon, this.actionButton});

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
