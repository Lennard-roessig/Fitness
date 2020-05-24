import 'workout_entity.dart';

abstract class ReactiveActivitiesRepository {
  Future<void> addNewActivity(WorkoutEntity workout);

  Future<void> deleteActivity(List<String> idList);

  Stream<List<WorkoutEntity>> workouts();

  Future<void> updateActivity(WorkoutEntity workout);
}
