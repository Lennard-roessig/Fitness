import 'package:fitness_workouts/provider/workout_provider.dart';
import 'package:fitness_workouts/screens/workout_create_screen.dart';
import 'package:fitness_workouts/widgets/workout_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models.dart';

class WorkoutListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Consumer<WorkoutProvider>(
        builder: (_, provider, __) => ListView.builder(
          itemCount: provider.workouts.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: GestureDetector(
              onTap: () {
                provider.select(provider.workouts[index]);
                Navigator.of(context).pushNamed(WorkoutCreateScreen.route);
              },
              child: WorkoutTile(
                name: provider.workouts[index].name,
                lastDate: '12 März 2020',
                duration: '10:00',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
