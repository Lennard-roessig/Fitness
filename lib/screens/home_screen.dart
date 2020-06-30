import 'package:fitness_workouts/screens/workout/workout_home_screen.dart';
import 'package:flutter/material.dart';

import 'timer_screen.dart';

class HomeScreen extends StatelessWidget {
  static const String route = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Navigation'),
        actions: <Widget>[
          // IconButton(
          //   icon: Icon(Icons.search),
          //   onPressed: () {},
          // ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: <Widget>[
          buildCard(context, title: 'Timer', route: TimerScreen.route),
          buildCard(context, title: 'Workouts', route: WorkoutHomeScreen.route),
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).accentColor,
              Color(0xFFFF0000),
            ],
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
