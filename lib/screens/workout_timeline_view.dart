import 'package:fitness_workouts/blocs/activities/exercises.dart';
import 'package:fitness_workouts/blocs/workout_create/workout_create_bloc.dart';
import 'package:fitness_workouts/widgets/workout_part_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models.dart';

/*

Work on Timeline 
- switch parts
- add parts
- remove parts 
- create Rounds
- etc. 
*/
class WorkoutTimelineView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final workoutCreateBloc = BlocProvider.of<WorkoutCreateBloc>(context);

    return GestureDetector(
      onTap: () => tab(null, workoutCreateBloc),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: BlocBuilder<WorkoutCreateBloc, WorkoutCreateState>(
            builder: (c, state) {
          if (state is WorkoutCreateInitial) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final readyState = (state as WorkoutCreateReady);
          return Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                right: 41,
                child: Container(
                  width: 1,
                  height: size.height,
                  color: Theme.of(context).accentColor,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: readyState.currentSequence.isEmpty
                    ? Center(
                        child: Column(
                          children: <Widget>[
                            for (final level in readyState.definedSequences)
                              RaisedButton(
                                color: Theme.of(context).accentColor,
                                child: Text(
                                  'Start from ${level.toString().replaceAll("WorkoutLevel.", "").toUpperCase()} Sequence',
                                  style: TextStyle(color: Colors.black),
                                ),
                                onPressed: () => workoutCreateBloc.add(
                                  CopyWorkoutSequence(
                                    from: level,
                                    to: readyState.level,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      )
                    : BlocBuilder<ExercisesBloc, ExercisesState>(
                        builder: (context, exercisesState) {
                          return Theme(
                            data: Theme.of(context)
                                .copyWith(canvasColor: Colors.transparent),
                            child: ReorderableListView(
                              children: [
                                for (final workoutpart
                                    in readyState.currentSequence)
                                  Padding(
                                    key: ObjectKey(workoutpart),
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    child: WorkoutPartTile(
                                      activity: workoutpart,
                                      name: (exercisesState is ExercisesLoaded)
                                          ? exercisesState
                                                  .exerciseById(
                                                      workoutpart.exerciseId)
                                                  ?.name ??
                                              "Unknown Exercise"
                                          : "Loading",
                                      time: time(
                                        workoutpart,
                                        readyState.currentSequence,
                                      ),
                                      add: (newPart) =>
                                          add(newPart, workoutCreateBloc),
                                      delete: (_) => delete(
                                          workoutpart, workoutCreateBloc),
                                      update: (oldPart, newPart) => update(
                                          oldPart, newPart, workoutCreateBloc),
                                      tab: (_) =>
                                          tab(workoutpart, workoutCreateBloc),
                                      isActiv:
                                          readyState.selected == workoutpart,
                                    ),
                                  ),
                              ],
                              onReorder: (oldIndex, newIndex) => reorder(
                                  oldIndex, newIndex, workoutCreateBloc),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        }),
      ),
    );
  }

  int time(Activity part, List<Activity> sequence) {
    assert(part != null);
    int time = 0;
    int lastGroupTime = 0;
    for (int i = 0; i < sequence.indexOf(part); i++) {
      if (sequence[i].isGroup) {
        time = time + ((time - lastGroupTime) * (sequence[i].rounds - 1));
        lastGroupTime = time;
        continue;
      }
      time += sequence[i].intervall;
    }
    return time;
  }

  void reorder(
    int oldIndex,
    int newIndex,
    WorkoutCreateBloc workoutCreateBloc,
  ) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    workoutCreateBloc
        .add(ReorderWorkoutPart(newIndex: newIndex, oldIndex: oldIndex));
  }

  void add(Activity part, WorkoutCreateBloc workoutCreateBloc) {
    workoutCreateBloc.add(AddWorkoutPart(workoutPart: part));
  }

  void delete(Activity part, WorkoutCreateBloc workoutCreateBloc) {
    workoutCreateBloc.add(RemoveWorkoutPart(workoutPart: part));
  }

  void update(
      Activity oldPart, Activity newPart, WorkoutCreateBloc workoutCreateBloc) {
    workoutCreateBloc
        .add(UpdateWorkoutPart(newPart: newPart, oldPart: oldPart));
  }

  void tab(Activity part, WorkoutCreateBloc workoutCreateBloc) {
    workoutCreateBloc.add(
      SelectWorkoutPart(
        workoutPart: part,
      ),
    );
  }
}

enum MenuItemActionTarget { Activity, Group, Pause, PauseAndActivity, All }

class MenuItem {
  final IconData icon;
  final Function action;
  final MenuItemActionTarget actionTarget;

  MenuItem(
    this.icon, {
    this.action,
    this.actionTarget,
  });
}
