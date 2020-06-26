import 'activity_value.dart';

class WorkoutEntity {
  final String id;
  final String name;
  final String description;
  final List<ActivityValue> beginnerSequence;
  final List<ActivityValue> advancedSequence;
  final List<ActivityValue> professionalSequence;

  final int sets;

  WorkoutEntity(
    this.id,
    this.name,
    this.description,
    this.sets,
    this.beginnerSequence,
    this.advancedSequence,
    this.professionalSequence,
  );

  @override
  String toString() {
    return 'WorkoutEntity{id: $id, name: $name, description: $description, beginner: $beginnerSequence, advanced: $advancedSequence, professional: $professionalSequence,sets: $sets}, ';
  }

  Map<String, Object> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'beginnerSequence': beginnerSequence.map((e) => e.toJson()).toList(),
      'advancedSequence': advancedSequence.map((e) => e.toJson()).toList(),
      'professionalSequence':
          professionalSequence.map((e) => e.toJson()).toList(),
      'sets': sets
    };
  }

  static WorkoutEntity fromJson(Map<String, Object> json) {
    return WorkoutEntity(
      json['id'] as String,
      json['name'] as String,
      json['description'] as String,
      json['sets'] as int,
      (json['beginnerSequence'] as List)
          .map((e) => ActivityValue.fromJson(e))
          .toList(),
      (json['advancedSequence'] as List)
          .map((e) => ActivityValue.fromJson(e))
          .toList(),
      (json['professionalSequence'] as List)
          .map((e) => ActivityValue.fromJson(e))
          .toList(),
    );
  }
}
