import 'package:fitness_workouts/repositories/workouts_repository/sound_value.dart';

class Sound {
  final String name;
  final String path;
  final bool local;

  Sound(
    this.name,
    this.path,
    this.local,
  );

  SoundValue toEntity() {
    return SoundValue(
      this.name,
      this.path,
      this.local,
    );
  }

  static Sound fromEntity(SoundValue entity) {
    return Sound(
      entity.name,
      entity.path,
      entity.local,
    );
  }
}
