import 'package:flutter/material.dart';

import 'activity_list_screen.dart';

import 'timer_screen.dart';
import 'workout_list_screen.dart';

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
          buildCard(context, title: 'Workouts', route: WorkoutListScreen.route),
          buildCard(context,
              title: 'Exercise', route: ActivityListScreen.route),
          buildCard(context, title: 'Schedule'),
        ],
      ),
    );
    //   body: tabs[_tabIndex].view,
    //   floatingActionButton: tabs[_tabIndex].floatingActionButton,
    //   bottomNavigationBar: BottomNavigationBar(
    //     currentIndex: _tabIndex,
    //     onTap: (int index) => setState(() {
    //       _tabIndex = index;
    //     }),
    //     items: tabs.map((tab) => tab.navigationBarItem).toList(),
    //   ),
    //   floatingActionButtonLocation: tabs[_tabIndex].actionButtonLocation,
    // );
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

  // List<TabEntry> get tabs {
  //   return [
  //     TabEntry(
  //       title: 'Exercise',
  //       icon: Icon(
  //         Icons.directions_run,
  //       ),
  //       view: ActivityListView(),
  //       actionButton: FloatingActionButton(
  //         onPressed: () {
  //           Navigator.of(context).pushNamed(ActivityCreateScreen.route);
  //         },
  //         child: Icon(Icons.add),
  //       ),
  //       actionButtonLocation: FloatingActionButtonLocation.endTop,
  //     ),
  //     TabEntry(
  //       title: 'Workout',
  //       icon: Icon(
  //         Icons.home,
  //       ),
  //       view: WorkoutListView(),
  //       actionButton: FloatingActionButton(
  //         onPressed: () {
  //           // final workoutProvider =
  //           //     Provider.of<WorkoutProvider>(context, listen: false);
  //           // workoutProvider.createWorkout();
  //           Navigator.of(context).pushNamed(WorkoutCreateScreen.route);
  //         },
  //         child: Icon(Icons.add),
  //       ),
  //     ),
  //     TabEntry(
  //       title: 'Timer',
  //       icon: Icon(
  //         Icons.timer,
  //       ),
  //       view: TimerView(),
  //     ),
  //   ];
  // }
}
