import 'exercise_entity.dart';

abstract class ExerciseRepository {
  Future<List<ExerciseEntity>> loadExercises();

  Future saveExercises(List<ExerciseEntity> exercises);
}
