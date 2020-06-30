import 'package:fitness_workouts/screens/workout/workout_home_screen.dart';
import 'package:flutter/material.dart';

import 'timer_screen.dart';

class HomeScreen extends StatelessWidget {
  static const String route = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Home Navigation')),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: <Widget>[
          buildCard(context, title: 'Workouts', route: WorkoutHomeScreen.route),
          buildCard(context, title: 'Timer', route: TimerScreen.route),
          buildCard(context, title: 'Schedule'),
        ],
      ),
    );
  }

  Widget buildCard(
    BuildContext context, {
    @required String title,
    String route,
  }) {
    return InkWell(
      onTap: () {
        if (route != null) {
          Navigator.of(context).pushNamed(route);
        }
      },
      child: Container(
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border.all(
            color: Theme.of(context).accentColor,
            width: 2,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
