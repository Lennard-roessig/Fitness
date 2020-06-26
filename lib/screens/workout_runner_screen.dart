import 'package:fitness_workouts/blocs/activities/exercises.dart';
import 'package:fitness_workouts/blocs/runner/runner_bloc.dart';
import 'package:fitness_workouts/blocs/timer/timer_bloc.dart';
import 'package:fitness_workouts/models.dart';
import 'package:fitness_workouts/util/arc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkoutRunnerScreen extends StatelessWidget {
  static const route = '/clock';

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    Workout workout = arguments["workout"] as Workout;
    WorkoutLevel level = arguments["level"] as WorkoutLevel;

    return BlocProvider<RunnerBloc>(
      create: (_) => RunnerBloc(
        activities: workout.sequence(level),
        timerBloc: BlocProvider.of<TimerBloc>(context),
      ),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              BlocBuilder<RunnerBloc, RunnerState>(
                builder: (context, runnerState) =>
                    BlocBuilder<TimerBloc, TimerState>(
                  builder: (context, state) => Clock(
                    time: state.seconds,
                    exerciseTime: runnerState.time,
                    exerciseDuration: runnerState.activity.intervall,
                  ),
                ),
              ),
              Flexible(child: WorkoutSequence()),
              ControllPanel(),
            ],
          ),
        ),
      ),
    );
  }
}

class Clock extends StatelessWidget {
  final int time;
  final int exerciseTime;
  final int exerciseDuration;

  const Clock({
    Key key,
    this.time,
    this.exerciseTime,
    this.exerciseDuration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DigitalClock(
          absTime: time,
          relativeTime: exerciseTime,
          relativeMax: exerciseDuration,
          diameter: 300,
        )
      ],
    );
  }
}

class WorkoutSequence extends StatelessWidget {
  const WorkoutSequence({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RunnerBloc, RunnerState>(
      builder: (context, state) {
        return BlocBuilder<ExercisesBloc, ExercisesState>(
          builder: (context, activitiesState) {
            final loadedState = activitiesState as ExercisesLoaded;
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

class ControllPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.skip_previous),
          iconSize: 52,
          onPressed: () =>
              BlocProvider.of<RunnerBloc>(context).add(SkipRunner()),
        ),
        IconButton(
          iconSize: 52,
          icon: Icon(
            BlocProvider.of<TimerBloc>(context).state is TimerStopped
                ? Icons.play_arrow
                : Icons.pause,
          ),
          onPressed: () => BlocProvider.of<TimerBloc>(context).add(
            ToggleTimer(),
          ),
        ),
        IconButton(
            iconSize: 52,
            icon: Icon(Icons.skip_next),
            onPressed: () =>
                BlocProvider.of<RunnerBloc>(context).add(BackRunner())),
      ],
    );
  }
}

class DigitalClock extends StatelessWidget {
  final double diameter;
  final int relativeMax;
  final int absTime;
  final int relativeTime;

  const DigitalClock({
    Key key,
    @required this.absTime,
    @required this.relativeTime,
    this.relativeMax = 0,
    this.diameter = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Arc(
      diameter: diameter,
      percentage: 2 * (relativeTime / relativeMax),
    );
  }
}
