import 'workout_entity.dart';

abstract class ReactivWorkoutRepository {
  Future<void> addNewWorkout(WorkoutEntity workout);

  Future<void> deleteWorkout(List<String> idList);

  Stream<List<WorkoutEntity>> workouts();

  Future<void> updateWorkout(WorkoutEntity workout);
}
