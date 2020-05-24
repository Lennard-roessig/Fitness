import 'activity_entity.dart';

abstract class ActivitiesRepository {
  Future<List<ActivityEntity>> loadActivities();

  Future saveActivities(List<ActivityEntity> activities);
}
