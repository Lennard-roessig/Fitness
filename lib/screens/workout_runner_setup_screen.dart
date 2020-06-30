import 'package:fitness_workouts/blocs/exercises/exercises.dart';
import 'package:fitness_workouts/models/workout.dart';

import 'package:fitness_workouts/screens/workout_runner_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkoutRunnerSetupScreen extends StatelessWidget {
  static const route = "clock/setup";

  @override
  Widget build(BuildContext context) {
    Workout workout = ModalRoute.of(context).settings.arguments as Workout;
    return Scaffold(
      appBar: AppBar(),
      body:
          BlocBuilder<ExercisesBloc, ExercisesState>(builder: (context, state) {
        if (state is ExercisesLoading) return CircularProgressIndicator();

        final stateLoaded = state as ExercisesLoaded;

        return ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: Text(
                "Exercises",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            ...workout.sequenceMap[WorkoutLevel.Beginner]
                .map((e) {
                  if (e.isGroup || e.isPause) return null;
                  final activity = stateLoaded.exerciseById(e.exerciseId);
                  return Container(
                    margin: EdgeInsets.all(15),
                    color: Theme.of(context).primaryColor,
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            activity.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text('Preperation'),
                        Container(
                          margin: EdgeInsets.only(
                            bottom: 15,
                            left: 15,
                            right: 15,
                            top: 8,
                          ),
                          padding: EdgeInsets.all(15),
                          color: Theme.of(context).backgroundColor,
                          child: Text(activity.descriptionPreperation),
                        ),
                        Text('Execution'),
                        Container(
                          margin: EdgeInsets.only(
                            bottom: 15,
                            left: 15,
                            right: 15,
                            top: 8,
                          ),
                          padding: EdgeInsets.all(15),
                          color: Theme.of(context).backgroundColor,
                          child: Text(activity.descriptionExecution),
                        ),
                      ],
                    ),
                  );
                })
                .where((element) => element != null)
                .toList(),
            RaisedButton(
              color: Theme.of(context).accentColor,
              child: Text(
                'Start',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(
                    WorkoutRunnerScreen.route,
                    arguments: {
                      "workout": workout,
                      "level": WorkoutLevel.Beginner,
                    });
              },
            )
          ],
        );
      }),
    );
  }
}
