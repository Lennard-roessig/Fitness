import 'package:fitness_workouts/blocs/workout_create/workout_create_bloc.dart';
import 'package:fitness_workouts/blocs/workouts/workouts.dart';
import 'package:fitness_workouts/screens/workout_timeline_view.dart';
import 'package:fitness_workouts/util/dialogs.dart';
import 'package:fitness_workouts/widgets/workout_action_speed_dial.dart';
import 'package:fitness_workouts/widgets/workout_create_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class WorkoutCreateScreen extends StatefulWidget {
  static const String route = '/workout/create';

  @override
  _WorkoutCreateScreenState createState() => _WorkoutCreateScreenState();
}

class _WorkoutCreateScreenState extends State<WorkoutCreateScreen> {
  @override
  Widget build(BuildContext context) {
    // WorkoutsBloc workoutsBloc = BlocProvider.of<WorkoutsBloc>(context);
    final workoutId = ModalRoute.of(context).settings.arguments as String;

    return BlocProvider(
        create: (_) => WorkoutCreateBloc(
              workoutsBloc: Provider.of<WorkoutsBloc>(context),
            )..add(InitializeWorkout(workoutId: workoutId)),
        child: WillPopScope(
          onWillPop: () async {
            bool leave = await confirmationDialog(context, "Are u sure?!?!",
                "If u leave now, you will lose all changes!");
            return Future.value(leave);
          },
          child: Scaffold(
            appBar: WorkoutCreateTabbar(),
            body: WorkoutTimelineView(),
            floatingActionButton: WorkoutActionSpeedDial(),
          ),
        ));
  }
}
