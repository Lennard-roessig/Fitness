import 'package:fitness_workouts/blocs/exercises/exercises.dart';
import 'package:fitness_workouts/blocs/runner/runner_bloc.dart';
import 'package:fitness_workouts/models/activity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkoutSequence extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RunnerBloc, RunnerState>(
      builder: (context, state) {
        if (state is RunnerFinished) return SizedBox();

        return BlocBuilder<ExercisesBloc, ExercisesState>(
          builder: (context, exerciseState) {
            final loadedState = exerciseState as ExercisesLoaded;
            return Column(
              children: [
                Text(
                  loadedState.exerciseById(state.activity.exerciseId)?.name ??
                      "Pause",
                  style: TextStyle(
                    fontSize: 26,
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  information(state.activity),
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String information(Activity part) {
    final reps = part.repetitions > 0 ? '${part.repetitions} reps' : null;
    final intervall = part.intervall > 0 ? '${part.intervall} sec' : null;

    if (intervall != null && reps != null) return '$reps, $intervall';
    if (intervall != null) return intervall;
    return reps;
  }
}
