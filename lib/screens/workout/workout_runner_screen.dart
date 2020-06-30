import 'package:fitness_workouts/blocs/exercises/exercises.dart';
import 'package:fitness_workouts/blocs/runner/runner_bloc.dart';
import 'package:fitness_workouts/blocs/sounds/sounds_bloc.dart';
import 'package:fitness_workouts/blocs/timer/timer_bloc.dart';
import 'package:fitness_workouts/models/activity.dart';
import 'package:fitness_workouts/models/sound.dart';
import 'package:fitness_workouts/models/workout.dart';

import 'package:fitness_workouts/util/arc.dart';
import 'package:fitness_workouts/util/time_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
                builder: (context, state) => Clock(
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

class WorkoutProgressIndicator extends StatelessWidget {
  final List<Activity> activities;
  final double height = 15;

  const WorkoutProgressIndicator({Key key, this.activities}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return BlocBuilder<RunnerBloc, RunnerState>(builder: (context, state) {
      if (state is RunnerFinished)
        return Container(
          height: height,
          width: width,
          color: Theme.of(context).primaryColor,
        );

      final activActivities = activitiesInGroup(state.activity.groupId);
      final time = totalTime(activActivities);
      final usedTime = timeUsed(activActivities, state.activity);
      final rounds = roundsToDo(state.activity.groupId);
      return SizedBox(
        height: height,
        width: width,
        child: Stack(
          children: <Widget>[
            Container(
              height: height,
              width: width,
              color: Theme.of(context).primaryColor,
            ),
            AnimatedContainer(
              duration: Duration(seconds: 1),
              curve: Curves.linear,
              height: height,
              width: (usedTime + state.time) / time * width,
              color: Theme.of(context).accentColor.withOpacity(0.4),
            ),
            Center(
              child: Text(
                'Round ${state.round + 1} / $rounds',
              ),
            ),
          ],
        ),
      );
    });
  }

  List<Activity> activitiesInGroup(String groupId) {
    if (groupId == null || groupId.isEmpty) return activities;
    return activities.where((element) => element.groupId == groupId).toList();
  }

  int totalTime(List<Activity> activActivities) {
    return activActivities.fold(0, (previousValue, element) {
      return previousValue + element.intervall;
    });
  }

  int timeUsed(List<Activity> activActivities, Activity activity) {
    return activActivities
        .takeWhile((value) => value != activity)
        .fold(0, (previousValue, element) => previousValue + element.intervall);
  }

  int roundsToDo(String groupId) {
    return activities
        .firstWhere((element) => element.referenceGroupId == groupId)
        .rounds;
  }
}

class Clock extends StatelessWidget {
  final int time;
  final double diameter = 300;

  const Clock({
    Key key,
    this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RunnerBloc, RunnerState>(
        builder: (context, runnerState) {
      final newValue = runnerState.time / runnerState.activity.intervall;

      var t;
      if (runnerState is RunnerRunning)
        t = Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              formatSecondsIntoMin(runnerState.time),
              style: TextStyle(
                fontSize: 32,
                color: Theme.of(context).accentColor,
              ),
            ),
            Text(
              formatSecondsIntoMin(time),
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).primaryColorLight,
              ),
            ),
          ],
        );

      if (runnerState is RunnerWaiting)
        t = Container(
          child: FlatButton(
            child: Text(
              'DONE',
              style: TextStyle(
                fontSize: 32,
                color: Theme.of(context).accentColor,
              ),
            ),
            onPressed: () {
              BlocProvider.of<RunnerBloc>(context)
                  .add(FinishedRepetitionRunner());
            },
          ),
        );

      if (runnerState is RunnerRunningAndWaiting) {
        t = t = Container(
          child: FlatButton(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  '${runnerState.time}',
                  style: TextStyle(
                    fontSize: 32,
                    color: Theme.of(context).accentColor,
                  ),
                ),
                Text(
                  'DONE',
                  style: TextStyle(
                    fontSize: 32,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ],
            ),
            onPressed: () {
              BlocProvider.of<RunnerBloc>(context)
                  .add(FinishedRepetitionRunner());
            },
          ),
        );
      }

      if (runnerState is RunnerFinished) t = Text('FINISHED');

      return SizedBox(
        height: diameter + 50,
        child: Stack(
          children: <Widget>[
            Center(
              child: Arc(
                diameter: diameter,
                percentage: 2 * newValue,
              ),
            ),
            Center(
              child: t,
            ),
          ],
        ),
      );
    });
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

class ControllPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RunnerBloc, RunnerState>(builder: (context, state) {
      if (state is RunnerFinished) {
        return Center(
          child: IconButton(
            icon: Icon(Icons.repeat),
            iconSize: 52,
            onPressed: () =>
                BlocProvider.of<RunnerBloc>(context).add(RepeatRunner()),
          ),
        );
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.skip_previous),
            iconSize: 52,
            onPressed: () =>
                BlocProvider.of<RunnerBloc>(context).add(BackRunner()),
          ),
          BlocBuilder<TimerBloc, TimerState>(
            builder: (context, state) => IconButton(
              iconSize: 52,
              icon: Icon(
                state is TimerStopped ? Icons.play_arrow : Icons.pause,
              ),
              onPressed: () =>
                  BlocProvider.of<TimerBloc>(context).add(ToggleTimer()),
            ),
          ),
          IconButton(
            iconSize: 52,
            icon: Icon(Icons.skip_next),
            onPressed: () => BlocProvider.of<RunnerBloc>(context).add(
              SkipRunner(),
            ),
          ),
        ],
      );
    });
  }
}
