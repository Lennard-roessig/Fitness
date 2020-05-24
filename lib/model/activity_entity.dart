enum ExerciseDifficulty { Beginner, Advanced, Profi }

// TODO - add muscle groups
enum ExerciseMuscleTarget { Bizeps, Abdominal, Trizeps, Chest }

enum Equipment {
  None,
}

class ActivityEntity {
  final String id;
  final String name;
  final String description;

  // Detailed information about the exercise
  final String detailVideoUrl;
  // max 3sec. video only one Repetition (without tone, etc..)
  final String repetitionVideoUrl;

  final ExerciseDifficulty difficulty;
  final List<ExerciseMuscleTarget> primary;
  final List<ExerciseMuscleTarget> supporting;

  final List<Equipment> equipment;

  ActivityEntity(
      this.id,
      this.name,
      this.description,
      this.detailVideoUrl,
      this.repetitionVideoUrl,
      this.difficulty,
      this.primary,
      this.supporting,
      this.equipment);

  @override
  String toString() {
    return 'ActivityEntity{id: $id, name: $name, description: $description, detailVideoUrl: $detailVideoUrl, repetitionVideoUrl: $repetitionVideoUrl, difficulty: $difficulty, primary: $primary, supporting: $supporting, equipment: $equipment}';
  }

  Map<String, Object> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'detailVideoUrl': detailVideoUrl,
      'repetitionVideoUrl': repetitionVideoUrl,
      'difficulty': difficulty.toString(),
      'primary': primary.map((e) => e.toString()).toList(),
      'supporting': supporting.map((e) => e.toString()).toList(),
      'equipment': equipment.map((e) => e.toString()).toList(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          detailVideoUrl == other.detailVideoUrl &&
          repetitionVideoUrl == other.repetitionVideoUrl &&
          difficulty == other.difficulty &&
          primary == other.primary &&
          supporting == other.supporting &&
          equipment == other.equipment;

  static ActivityEntity fromJson(Map<String, Object> json) {
    return ActivityEntity(
      json['id'] as String,
      json['name'] as String,
      json['description'] as String,
      json['detailVideoUrl'] as String,
      json['repetitionVideoUrl'] as String,
      getExerciseDifficultyFromString(json['difficulty']),
      (json['primary'] as List)
          .map((e) => getExerciseMuscleTargetFromString(e))
          .toList(),
      (json['supporting'] as List)
          .map((e) => getExerciseMuscleTargetFromString(e))
          .toList(),
      (json['equipment'] as List)
          .map((e) => getEquipmentFromString(e))
          .toList(),
    );
  }

  static ExerciseDifficulty getExerciseDifficultyFromString(
      String exerciseDifficultyString) {
    for (ExerciseDifficulty element in ExerciseDifficulty.values) {
      if (element.toString() == exerciseDifficultyString) {
        return element;
      }
    }
    return null;
  }

  static ExerciseMuscleTarget getExerciseMuscleTargetFromString(
      String exerciseMuscleTargetString) {
    for (ExerciseMuscleTarget element in ExerciseMuscleTarget.values) {
      if (element.toString() == exerciseMuscleTargetString) {
        return element;
      }
    }
    return null;
  }

  static Equipment getEquipmentFromString(String equipmentString) {
    for (Equipment element in Equipment.values) {
      if (element.toString() == equipmentString) {
        return element;
      }
    }
    return null;
  }
}
