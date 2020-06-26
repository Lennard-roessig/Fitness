import 'workout_entity.dart';

abstract class WorkoutRepository {
  Future<List<WorkoutEntity>> loadWorkouts();

  Future saveWorkouts(List<WorkoutEntity> workouts);
}
