import 'package:fitness_workouts/blocs/runner/runner_bloc.dart';
import 'package:fitness_workouts/widgets/time_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'arc.dart';

class WorkoutClock extends StatelessWidget {
  final int time;
  final double diameter;

  const WorkoutClock({
    Key key,
    this.time,
    this.diameter = 300,
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
            TimeText(
              seconds: runnerState.time,
              style: TextStyle(
                fontSize: 32,
                color: Theme.of(context).accentColor,
              ),
            ),
            TimeText(
              seconds: time,
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
