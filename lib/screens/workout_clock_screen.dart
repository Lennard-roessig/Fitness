import 'dart:async';

import 'package:fitness_workouts/models.dart';
import 'package:fitness_workouts/provider/activity_provider.dart';
import 'package:fitness_workouts/provider/clock_provider.dart';
import 'package:fitness_workouts/provider/workout_provider.dart';
import 'package:fitness_workouts/util/arc.dart';
import 'package:fitness_workouts/util/time_format.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkoutClockScreen extends StatelessWidget {
  static const route = '/clock';

  @override
  Widget build(BuildContext context) {
    return Consumer2<WorkoutProvider, ActivityProvider>(
      builder: (_, workoutProvider, activityProvider, __) =>
          ChangeNotifierProvider(
        create: (context) => ClockProvider(
          level1: WorkoutLevel.Beginner,
          workout: workoutProvider.workout,
          activityById: activityProvider.activityById,
        ),
        child: Consumer<ClockProvider>(
          builder: (_, clockProvider, __) => WillPopScope(
            onWillPop: () {
              clockProvider.stopTimer();
              return Future.value(true);
            },
            child: Scaffold(
              appBar: AppBar(),
              body: Stack(
                children: <Widget>[
                  Container(
                    color: Theme.of(context).primaryColor,
                    width: double.infinity,
                    height: 200,
                  ),
                  Center(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 120,
                        ),
                        clockProvider.finished(WorkoutLevel.Beginner)
                            ? Text('Finished')
                            : DigitalClock(
                                absTime: clockProvider.elapsedSeconds,
                                relativeTime:
                                    clockProvider.relativeElapsedSeconds(
                                        WorkoutLevel.Beginner),
                                relativeMax: clockProvider
                                    .currentWorkoutpart(WorkoutLevel.Beginner)
                                    .intervall,
                                diameter: 200,
                              ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.skip_previous),
                              iconSize: 52,
                              onPressed: () =>
                                  clockProvider.previous(WorkoutLevel.Beginner),
                            ),
                            IconButton(
                              iconSize: 52,
                              icon: Icon(
                                clockProvider.isRunning
                                    ? Icons.pause
                                    : Icons.play_arrow,
                              ),
                              onPressed: () => clockProvider.isRunning
                                  ? clockProvider.pauseTimer()
                                  : clockProvider.startTimer(),
                            ),
                            IconButton(
                              iconSize: 52,
                              icon: Icon(Icons.skip_next),
                              onPressed: () =>
                                  clockProvider.skip(WorkoutLevel.Beginner),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 16, top: 8),
                              child: Text(
                                name(
                                    clockProvider.currentWorkoutpart(
                                        WorkoutLevel.Beginner),
                                    activityProvider),
                                style: TextStyle(
                                  fontSize: 32,
                                  color: Theme.of(context).textSelectionColor,
                                ),
                              ),
                            ),
                            for (final workoutpart in clockProvider
                                .nextParts(WorkoutLevel.Beginner, amount: 3))
                              Padding(
                                padding: EdgeInsets.only(bottom: 8),
                                child: Text(
                                  name(workoutpart, activityProvider),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).primaryColorLight,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String name(WorkoutPart part, ActivityProvider activityProvider) {
    if (part.isPause) return "Pause";
    return activityProvider.activityById(part.activityId)?.name ?? "";
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
    return Container(
      child: Stack(
        children: <Widget>[
          Arc(
            diameter: diameter,
            percentage: 2 * (relativeTime / relativeMax),
          ),
          Container(
            width: diameter,
            height: diameter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                FittedBox(
                  child: Text(
                    formatSecondsIntoMin(relativeTime),
                    style: TextStyle(fontSize: 40),
                  ),
                ),
                FittedBox(
                  child: Text(
                    formatSecondsIntoMin(absTime),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
