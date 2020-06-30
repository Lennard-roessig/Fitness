import 'package:fitness_workouts/blocs/workouts/workouts.dart';
import 'package:fitness_workouts/screens/workout/workout_create_screen.dart';
import 'package:fitness_workouts/screens/workout/workout_runner_setup_screen.dart';
import 'package:fitness_workouts/widgets/workout_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkoutHomeScreen extends StatelessWidget {
  static const route = "/workout/home";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Workouts"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocBuilder<WorkoutsBloc, WorkoutsState>(
          builder: (c, state) {
            if (state is WorkoutsLoading) {
              return Center(child: CircularProgressIndicator());
            }
            final loadedState = (state as WorkoutsLoaded);

            return ListView.builder(
              itemCount: loadedState.workouts.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: GestureDetector(
                  onTap: () {
                    // provider.selectWorkout(provider.workouts[index]);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => WorkoutCreateScreen(
                            workoutId: loadedState.workouts[index].id),
                      ),
                    );
                  },
                  child: WorkoutTile(
                    name: loadedState.workouts[index].name,
                    lastDate: '12 März 2020',
                    duration: '10:00',
                    onPlay: () {
                      //provider.selectWorkout(provider.workouts[index]);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => WorkoutRunnerSetupScreen(
                              workout: loadedState.workouts[index]),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => WorkoutCreateScreen(),
          ),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}
