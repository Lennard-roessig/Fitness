import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_workouts/blocs/timer/timer_bloc.dart';

import 'package:fitness_workouts/repositories/workouts_repository/firestore_reactive_workout_repository.dart';
import 'package:fitness_workouts/screens/home_screen.dart';
import 'package:fitness_workouts/screens/workout/workout_home_screen.dart';
import 'package:fitness_workouts/screens/workout/workout_runner_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/exercises/exercises.dart';
import 'blocs/sounds/sounds_bloc.dart';
import 'blocs/workouts/workouts.dart';
import 'repositories/exercise_repository/firestore_reactive_exercise_repository.dart';
import 'screens/timer_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<WorkoutsBloc>(
          create: (_) => WorkoutsBloc(
            workoutsRepository:
                FirestoreReactiveWorkoutRepository(Firestore.instance),
          )..add(LoadWorkouts()),
        ),
        BlocProvider<ExercisesBloc>(
          create: (_) => ExercisesBloc(
            exercisesRepository:
                FirestoreReactiveExerciseRepository(Firestore.instance),
          )..add(LoadExercises()),
        ),
        BlocProvider<SoundsBloc>(
          create: (_) => SoundsBloc()..add(LoadSounds()),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        accentColor: Color(0xFFFFA000),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
      routes: {
        HomeScreen.route: (_) => HomeScreen(),
        TimerScreen.route: (_) => TimerScreen(),
        WorkoutHomeScreen.route: (_) => WorkoutHomeScreen(),
        WorkoutRunnerScreen.route: (_) => MultiBlocProvider(
              providers: [
                BlocProvider<TimerBloc>(
                  create: (_) => TimerBloc(),
                ),
              ],
              child: WorkoutRunnerScreen(),
            ),
      },
    );
  }
}
