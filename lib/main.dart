import 'package:fitness_workouts/provider/activity_provider.dart';
import 'package:fitness_workouts/provider/sound_provider.dart';
import 'package:fitness_workouts/provider/workout_provider.dart';
import 'package:fitness_workouts/repositories/json_activity_repository.dart';
import 'package:fitness_workouts/repositories/json_workout_repository.dart';
import 'package:fitness_workouts/screens/home_screen.dart';
import 'package:fitness_workouts/screens/workout_create_screen.dart';
import 'package:fitness_workouts/screens/workout_finish_screen.dart';
import 'package:fitness_workouts/screens/workout_generate_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models.dart';
import 'screens/workout_clock_screen.dart';

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
        ChangeNotifierProvider(
          create: (_) => SoundProvider(sounds: [
            Sound("Sound 1", "assets/sound_1.mp3", true),
            Sound("Sound 2", "assets/sound_1.mp3", true),
            Sound("Sound 3", "assets/sound_1.mp3", true),
          ]),
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
        WorkoutFinishScreen.route: (_) => WorkoutFinishScreen(),
        WorkoutClockScreen.route: (_) => WorkoutClockScreen(),
      },
    );
  }
}
