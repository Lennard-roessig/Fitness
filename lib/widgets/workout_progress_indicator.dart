import 'package:fitness_workouts/blocs/runner/runner_bloc.dart';
import 'package:fitness_workouts/models/activity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
