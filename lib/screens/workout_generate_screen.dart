import 'package:fitness_workouts/provider/activity_provider.dart';
import 'package:fitness_workouts/screens/workout_create_screen.dart';
import 'package:fitness_workouts/widgets/chip_search_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models.dart';

class WorkoutGenerateScreen extends StatelessWidget {
  static const String route = '/workout/generate';

  List<Activity> selectedActivities = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate Workout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 20),
            Text('Exercises'),
            SizedBox(height: 8),
            Flexible(
              child: Selector<ActivityProvider, List<Activity>>(
                selector: (_, model) => model.activities,
                builder: (_, activities, __) => ChipSearchField(
                  onChange: (value) {
                    selectedActivities = value;
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            Text('Intervall'),
            SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  fillColor: Theme.of(context).primaryColor,
                  suffixText: 'sec',
                ),
                cursorColor: Theme.of(context).accentColor,
                enableInteractiveSelection: true,
              ),
            ),
            SizedBox(height: 20),
            Text('Repetitions'),
            SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  fillColor: Theme.of(context).primaryColor,
                  suffixText: 'reps',
                ),
                cursorColor: Theme.of(context).accentColor,
                enableInteractiveSelection: true,
              ),
            ),
            SizedBox(height: 20),
            Text('Pause'),
            SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  fillColor: Theme.of(context).primaryColor,
                  suffixText: 'sec',
                ),
                cursorColor: Theme.of(context).accentColor,
                enableInteractiveSelection: true,
              ),
            ),
            SizedBox(height: 20),
            Text('Rounds'),
            SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  fillColor: Theme.of(context).primaryColor,
                  suffixText: 'rounds',
                ),
                cursorColor: Theme.of(context).accentColor,
                enableInteractiveSelection: true,
              ),
            ),
            SizedBox(height: 20),
            Text('Pause position'),
            SizedBox(height: 8),
            Row(
              children: <Widget>[
                RaisedButton(
                  child: Text('After every Exercise'),
                  color: Theme.of(context).accentColor,
                  textColor: Colors.black,
                  onPressed: () {},
                ),
                SizedBox(width: 8),
                FlatButton(
                  child: Text(
                    'After a Round',
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(height: 120),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.of(context).pushNamed(WorkoutCreateScreen.route),
        child: Icon(Icons.navigate_next),
      ),
    );
  }
}
