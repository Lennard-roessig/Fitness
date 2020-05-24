import 'activity_entity.dart';

abstract class ReactiveActivitiesRepository {
  Future<void> addNewActivity(ActivityEntity activity);

  Future<void> deleteActivity(List<String> idList);

  Stream<List<ActivityEntity>> activities();

  Future<void> updateActivity(ActivityEntity activity);
}
