import 'package:fitness_workouts/blocs/workout_create/workout_create.dart';
import 'package:fitness_workouts/models/activity.dart';
import 'package:fitness_workouts/models/exercise.dart';
import 'package:fitness_workouts/screens/workout_generate_screen.dart';
import 'package:fitness_workouts/util/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'activity_search_delegate.dart';

class WorkoutActionSpeedDial extends StatelessWidget {
  const WorkoutActionSpeedDial({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      // both default to 16
      marginRight: 18,
      marginBottom: 20,
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      // this is ignored if animatedIcon is non null
      // child: Icon(Icons.add),
      // visible: _dialVisible,
      // If true user is forced to close dial manually
      // by tapping main button and overlay is not rendered.
      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      tooltip: 'Add Parts',
      heroTag: 'speed-dial-hero-tag',
      backgroundColor: Theme.of(context).accentColor,
      foregroundColor: Colors.black,
      elevation: 8.0,
      shape: CircleBorder(),
      children: speedDialChilds(context),
    );
  }

  List<SpeedDialChild> speedDialChilds(BuildContext context) {
    final workoutCreateBloc = BlocProvider.of<WorkoutCreateBloc>(context);
    return [
      SpeedDialChild(
          child: Icon(Icons.add_to_photos),
          backgroundColor: Theme.of(context).accentColor,
          labelBackgroundColor: Theme.of(context).accentColor,
          label: 'Generate',
          labelStyle:
              TextStyle(fontSize: 18.0, color: Theme.of(context).primaryColor),
          onTap: () async {
            final generate = await Navigator.of(context).push(
              MaterialPageRoute(builder: (_) {
                return WorkoutGenerateScreen();
              }),
            );
            if (generate != null) workoutCreateBloc.add(generate);
          }),
      SpeedDialChild(
          child: Icon(Icons.pause),
          backgroundColor: Theme.of(context).accentColor,
          labelBackgroundColor: Theme.of(context).accentColor,
          label: 'Pause',
          labelStyle:
              TextStyle(fontSize: 18.0, color: Theme.of(context).primaryColor),
          onTap: () async {
            double value = await numberInputDialog(
              context,
              'Pause Intervall',
              0,
              'sec',
            );
            add(Activity.pause(intervall: value.toInt()), workoutCreateBloc);
          }),
      SpeedDialChild(
          child: Icon(Icons.repeat),
          backgroundColor: Theme.of(context).accentColor,
          labelBackgroundColor: Theme.of(context).accentColor,
          label: 'Round',
          labelStyle:
              TextStyle(fontSize: 18.0, color: Theme.of(context).primaryColor),
          onTap: () async {
            add(Activity.group(), workoutCreateBloc);
          }),
      SpeedDialChild(
          child: Icon(Icons.fitness_center),
          backgroundColor: Theme.of(context).accentColor,
          labelBackgroundColor: Theme.of(context).accentColor,
          elevation: 0,
          label: 'Exercise',
          labelStyle:
              TextStyle(fontSize: 18.0, color: Theme.of(context).primaryColor),
          onTap: () async {
            Exercise choosenExercise = await showSearch(
              context: context,
              delegate: ExerciseSearch(
                mode: ExerciseSearchSelectMode.Single,
              ),
            );
            if (choosenExercise == null) return;
            add(Activity.empty().copy(exerciseId: choosenExercise.id),
                workoutCreateBloc);
          }),
    ];
  }

  void add(Activity part, WorkoutCreateBloc workoutCreateBloc) {
    workoutCreateBloc.add(AddWorkoutPart(workoutPart: part));
  }
}
