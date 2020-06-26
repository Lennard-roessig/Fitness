import 'exercise_entity.dart';

abstract class ReactiveExerciseRepository {
  Future<void> addNewExercise(ExerciseEntity exercise);

  Future<void> deleteExercise(List<String> idList);

  Stream<List<ExerciseEntity>> exercises();

  Future<void> updateExercise(ExerciseEntity exercise);
}
