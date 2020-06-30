import 'package:fitness_workouts/blocs/workout_create/workout_create_bloc.dart';
import 'package:fitness_workouts/blocs/workouts/workouts.dart';
import 'package:fitness_workouts/screens/workout/workout_timeline_view.dart';
import 'package:fitness_workouts/widgets/dialogs/confirmation_dialog.dart';
import 'package:fitness_workouts/widgets/workout_action_speed_dial.dart';
import 'package:fitness_workouts/widgets/workout/workout_create_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class WorkoutCreateScreen extends StatelessWidget {
  final String workoutId;

  const WorkoutCreateScreen({Key key, this.workoutId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WorkoutCreateBloc(
        workoutsBloc: Provider.of<WorkoutsBloc>(context),
      )..add(InitializeWorkout(workoutId: workoutId)),
      child: WillPopScope(
        onWillPop: () async {
          bool leave = await showDialog<bool>(
            context: context,
            builder: (context) => ConfirmationDialog(
              title: "Sure you wanna leave?",
              content: "If you leave, all Progress gets lost",
            ),
          );

          return Future.value(leave ?? false);
        },
        child: Scaffold(
          appBar: WorkoutCreateTabbar(),
          body: WorkoutTimelineView(),
          floatingActionButton: WorkoutActionSpeedDial(),
        ),
      ),
    );
  }
}
