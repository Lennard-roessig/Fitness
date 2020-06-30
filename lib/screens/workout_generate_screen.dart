import 'package:fitness_workouts/blocs/exercises/exercises.dart';
import 'package:fitness_workouts/blocs/workout_create/workout_create.dart';
import 'package:fitness_workouts/widgets/chip_search_field.dart';
import 'package:fitness_workouts/widgets/number_input.dart';
import 'package:fitness_workouts/widgets/switch_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models.dart';

class WorkoutGenerateScreen extends StatelessWidget {
  final Function(List<Exercise> exercises, int pause, int rounds,
      int repetitions, int intervalls, PausePositions pausePosition) onSave;

  WorkoutGenerateScreen({Key key, this.onSave}) : super(key: key);

  int intervalls = 0;
  int repetitions = 0;
  int pause = 0;
  int rounds = 0;
  PausePositions pausePosition = PausePositions.AfterEveryExercise;
  List<Exercise> exercises = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      BlocBuilder<ExercisesBloc, ExercisesState>(
                        builder: (context, state) => ChipSearchField(
                          onChange: (value) {
                            exercises = value;
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
                            options: ['After every Exercise', 'After a Round'],
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
          Navigator.of(context).pop(Generate(
            intervalls,
            repetitions,
            pause,
            rounds,
            pausePosition,
            exercises,
          ));
        },
        child: Icon(Icons.navigate_next),
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
