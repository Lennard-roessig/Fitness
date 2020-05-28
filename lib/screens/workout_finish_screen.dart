import 'package:fitness_workouts/provider/workout_provider.dart';
import 'package:fitness_workouts/screens/home_screen.dart';
import 'package:fitness_workouts/widgets/styled_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkoutFinishScreen extends StatelessWidget {
  static const String route = '/workout/finish';

  String name;
  String description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Finish Workout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Name'),
            StyledTextField(
              expands: false,
              onChange: (val) => name = val,
            ),
            SizedBox(
              height: 20,
            ),
            Text('Description'),
            StyledTextField(
              expands: false,
              maxLines: 5,
              onChange: (val) => description = val,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final workoutProvider =
              Provider.of<WorkoutProvider>(context, listen: false);

          workoutProvider.updateWorkout(workoutProvider.workout
              .copy(name: name, description: description));

          Navigator.popUntil(context, (route) => route.isFirst);
        },
        child: Icon(
          Icons.done,
        ),
      ),
    );
  }
}
