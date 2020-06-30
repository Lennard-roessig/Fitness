import 'package:fitness_workouts/blocs/runner/runner_bloc.dart';
import 'package:fitness_workouts/blocs/timer/timer_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
