import 'package:fitness_workouts/provider/activity_provider.dart';
import 'package:fitness_workouts/provider/workout_provider.dart';
import 'package:fitness_workouts/repositories/json_activity_repository.dart';
import 'package:fitness_workouts/repositories/json_workout_repository.dart';
import 'package:fitness_workouts/screens/home_screen.dart';
import 'package:fitness_workouts/screens/workout_create_screen.dart';
import 'package:fitness_workouts/screens/workout_generate_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ActivityProvider(repository: JsonActivityRepository())
            ..loadActivities(),
        ),
        ChangeNotifierProvider(
          create: (_) => WorkoutProvider(repository: JsonWorkoutRepository())
            ..loadWorkouts(),
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
        WorkoutGenerateScreen.route: (_) => WorkoutGenerateScreen(),
        WorkoutCreateScreen.route: (_) => WorkoutCreateScreen(),
      },
    );
  }
}
