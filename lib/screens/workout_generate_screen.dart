import 'package:fitness_workouts/provider/activity_provider.dart';
import 'package:fitness_workouts/provider/workout_provider.dart';
import 'package:fitness_workouts/screens/workout_create_screen.dart';
import 'package:fitness_workouts/widgets/chip_search_field.dart';
import 'package:fitness_workouts/widgets/number_input.dart';
import 'package:fitness_workouts/widgets/switch_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models.dart';

enum PausePositions { AfterEveryExercise, AfterEveryRound }

class WorkoutGenerateScreen extends StatelessWidget {
  static const String route = '/workout/generate';

  int intervalls = 0;
  int repetitions = 0;
  int pause = 0;
  int rounds = 0;
  PausePositions pausePosition = PausePositions.AfterEveryExercise;
  List<Activity> selectedActivities = [];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        final workoutProvider =
            Provider.of<WorkoutProvider>(context, listen: false);
        workoutProvider.removeWorkout(workoutProvider.workout);
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Generate Workout'),
        ),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.spaceAround,
                runSpacing: 20,
                spacing: 20,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).primaryColor,
                    ),
                    child: Column(
                      children: <Widget>[
                        buildTitle('Exercises'),
                        SizedBox(
                          height: 8,
                        ),
                        Selector<ActivityProvider, List<Activity>>(
                          selector: (_, model) => model.activities,
                          builder: (_, activities, __) => ChipSearchField(
                            onChange: (value) {
                              selectedActivities = value;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  buildContainer(
                    context,
                    title: 'Intervall',
                    suffix: 'sec',
                    onChange: (val) => intervalls = val.toInt(),
                  ),
                  buildContainer(
                    context,
                    title: 'Repetitions',
                    suffix: 'reps',
                    onChange: (val) => repetitions = val.toInt(),
                  ),
                  Container(
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).primaryColor,
                    ),
                    child: Wrap(
                      spacing: 60,
                      runSpacing: 60,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            buildTitle('Pause'),
                            NumberInput(
                              suffixLabel: "sec",
                              onChange: (val) => pause = val.toInt(),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            buildTitle('Pause Position'),
                            SwitchInput(
                              options: [
                                'After every Exercise',
                                'After a Round'
                              ],
                              onChange: (val) => pausePosition =
                                  PausePositions.values[val.toInt()],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  buildContainer(
                    context,
                    title: 'Rounds',
                    onChange: (val) => rounds = val.toInt(),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            final workoutProvider =
                Provider.of<WorkoutProvider>(context, listen: false);

            selectedActivities
                .map((element) => WorkoutPart.empty().copy(
                      activityId: element.id,
                      intervall: intervalls,
                      repetitions: repetitions,
                    ))
                .expand((element) {
              if (pausePosition == PausePositions.AfterEveryExercise &&
                  pause > 0)
                return [element, WorkoutPart.pause(intervall: pause)];

              return [element];
            }).forEach((element) =>
                    workoutProvider.addNewWorkoutPart(element, null));

            if (rounds > 0) {
              if (pausePosition == PausePositions.AfterEveryRound && pause > 0)
                workoutProvider.addNewWorkoutPart(
                    WorkoutPart.pause(intervall: pause), null);

              workoutProvider.addNewWorkoutPart(
                  WorkoutPart.group(rounds: rounds), null);
            }

            Navigator.of(context)
                .pushReplacementNamed(WorkoutCreateScreen.route);
          },
          child: Icon(Icons.navigate_next),
        ),
      ),
    );
  }

  Container buildContainer(
    BuildContext context, {
    String title,
    String suffix,
    Function(double val) onChange,
  }) {
    return Container(
      padding: EdgeInsets.all(30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).primaryColor,
      ),
      child: Column(
        children: <Widget>[
          buildTitle(title),
          NumberInput(
            suffixLabel: suffix,
            onChange: onChange,
          ),
        ],
      ),
    );
  }

  Widget buildTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 18),
    );
  }
}
