import 'package:fitness_workouts/model/workout_part_value.dart';

class WorkoutEntity {
  final String id;
  final String name;
  final String description;
  final List<WorkoutPartValue> sequence;
  final int sets;

  WorkoutEntity(
    this.id,
    this.name,
    this.description,
    this.sets,
    this.sequence,
  );

  @override
  String toString() {
    return 'WorkoutEntity{id: $id, name: $name, description: $description, sequence: $sequence, sets: $sets}';
  }

  Map<String, Object> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'sequence': sequence.map((e) => e.toJson()).toList(),
      'sets': sets
    };
  }

  static WorkoutEntity fromJson(Map<String, Object> json) {
    return WorkoutEntity(
      json['id'] as String,
      json['name'] as String,
      json['description'] as String,
      json['sets'] as int,
      (json['sequence'] as List)
          .map((e) => WorkoutPartValue.fromJson(e))
          .toList(),
    );
  }
}
