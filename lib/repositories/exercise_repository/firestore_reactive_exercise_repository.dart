// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'exercise_entity.dart';
import 'reactive_exercise_repository.dart';

class FirestoreReactiveExerciseRepository
    implements ReactiveExerciseRepository {
  static const String path = 'activities';

  final Firestore firestore;

  const FirestoreReactiveExerciseRepository(this.firestore);

  @override
  Future<void> addNewExercise(ExerciseEntity exercise) {
    return firestore
        .collection(path)
        .document(exercise.id)
        .setData(exercise.toJson());
  }

  @override
  Future<void> deleteExercise(List<String> idList) async {
    await Future.wait<void>(idList.map((id) {
      return firestore.collection(path).document(id).delete();
    }));
  }

  @override
  Stream<List<ExerciseEntity>> exercises() {
    return firestore.collection(path).snapshots().map((snapshot) {
      return snapshot.documents.map((doc) {
        return ExerciseEntity(
          doc.documentID,
          doc['name'] as String,
          doc['muscleGroup'] as String,
          List.from(doc['primaryMuscles']),
          List.from(doc['synergistMuscles']),
          List.from(doc['dynamicStabilizerMuscles']),
          List.from(doc['stabilizerMuscles']),
          doc['force'] as String,
          doc['mechanic'] as String,
          doc['utility'] as String,
          doc['descriptionPreperation'] as String,
          doc['descriptionExecution'] as String,
          List.from(doc['equipment']),
          doc['detailVideoUrl'] as String,
          doc['repetitionVideoUrl'] as String,
        );
      }).toList();
    });
  }

  @override
  Future<void> updateExercise(ExerciseEntity exercise) {
    return firestore
        .collection(path)
        .document(exercise.id)
        .updateData(exercise.toJson());
  }
}
