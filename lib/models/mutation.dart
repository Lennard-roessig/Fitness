import 'dart:math';

import 'package:fitness_workouts/repositories/workouts_repository/mutation_value.dart';

class Mutation {
  final MutationType type;
  final MutationTarget mutationTarget;
  final int max;
  final int min;
  final List<Point<int>> points;

  Mutation(
    this.type,
    this.mutationTarget,
    this.max,
    this.min,
    this.points,
  );

  MutationValue toEntity() {
    return MutationValue(
      this.type,
      this.mutationTarget,
      this.max,
      this.min,
      this.points,
    );
  }

  static Mutation fromEntity(MutationValue entity) {
    return Mutation(
      entity.type,
      entity.mutationTarget,
      entity.max,
      entity.min,
      entity.points,
    );
  }
}
