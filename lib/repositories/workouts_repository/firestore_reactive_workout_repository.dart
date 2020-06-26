import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_workouts/repositories/workouts_repository/workout_entity.dart';

import 'activity_value.dart';
import 'reactive_workout_repository.dart';

class FirestoreReactiveWorkoutRepository implements ReactivWorkoutRepository {
  static const String path = 'workouts';

  final Firestore firestore;

  const FirestoreReactiveWorkoutRepository(this.firestore);

  @override
  Future<void> addNewWorkout(WorkoutEntity workout) {
    return firestore.collection(path).add(workout.toJson());
  }

  @override
  Future<void> deleteWorkout(List<String> idList) async {
    await Future.wait<void>(idList.map((id) {
      return firestore.collection(path).document(id).delete();
    }));
  }

  @override
  Future<void> updateWorkout(WorkoutEntity workout) {
    return firestore
        .collection(path)
        .document(workout.id)
        .updateData(workout.toJson());
  }

  @override
  Stream<List<WorkoutEntity>> workouts() {
    return firestore.collection(path).snapshots().map((snapshot) {
      return snapshot.documents.map((doc) {
        return WorkoutEntity(
          doc.documentID,
          doc['name'] as String,
          doc['description'] as String,
          doc['sets'] as int,
          (doc['beginnerSequence'] as List)
              .map((e) => ActivityValue.fromJson(e))
              .toList(),
          (doc['advancedSequence'] as List)
              .map((e) => ActivityValue.fromJson(e))
              .toList(),
          (doc['professionalSequence'] as List)
              .map((e) => ActivityValue.fromJson(e))
              .toList(),
        );
      }).toList();
    });
  }
}
