import 'package:fitness_workouts/blocs/runner/runner_bloc.dart';
import 'package:fitness_workouts/blocs/sounds/sounds_bloc.dart';
import 'package:fitness_workouts/blocs/timer/timer_bloc.dart';
import 'package:fitness_workouts/models/sound.dart';
import 'package:fitness_workouts/models/workout.dart';

import 'package:fitness_workouts/widgets/controll_panel.dart';
import 'package:fitness_workouts/widgets/workout_clock.dart';
import 'package:fitness_workouts/widgets/workout_progress_indicator.dart';
import 'package:fitness_workouts/widgets/workout_sequence.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkoutRunnerScreen extends StatelessWidget {
  static const route = "/workout/runner";

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    Workout workout = arguments["workout"] as Workout;
    WorkoutLevel level = arguments["level"] as WorkoutLevel;

    List<Sound> sounds = workout
        .sequence(level)
        .expand((e) => e.alarms.map((e) => e.sound))
        .toSet()
        .toList();

    return BlocProvider<RunnerBloc>(
      create: (_) => RunnerBloc(
        activities: workout.sequence(level),
        timerBloc: BlocProvider.of<TimerBloc>(context),
        soundsBloc: BlocProvider.of<SoundsBloc>(context)
          ..add(PrepareSounds(sounds)),
      ),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              WorkoutProgressIndicator(
                activities: workout.sequence(level),
              ),
              BlocBuilder<TimerBloc, TimerState>(
                builder: (context, state) => WorkoutClock(
                  time: state.seconds,
                ),
              ),
              Spacer(),
              WorkoutSequence(),
              Spacer(),
              ControllPanel(),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
