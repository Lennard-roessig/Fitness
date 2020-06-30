import 'package:fitness_workouts/repositories/workouts_repository/alarm_value.dart';

import 'sound.dart';

class Alarm {
  final String label;
  final bool activ;
  final Sound sound;
  final int timestamp;
  final double relativeTimestamp;

  Alarm(
    this.label,
    this.activ,
    this.sound,
    this.timestamp,
    this.relativeTimestamp,
  );

  Alarm copy({
    String label,
    bool activ,
    Sound sound,
    int timestamp,
    double relativeTimestamp,
  }) {
    return Alarm(
      label ?? this.label,
      activ ?? this.activ,
      sound ?? this.sound,
      timestamp ?? this.timestamp,
      relativeTimestamp ?? this.relativeTimestamp,
    );
  }

  AlarmValue toEntity() {
    return AlarmValue(this.label, this.activ, this.sound.toEntity(),
        this.timestamp, this.relativeTimestamp);
  }

  static Alarm fromEntity(AlarmValue entity) {
    return Alarm(entity.label, entity.activ, Sound.fromEntity(entity.sound),
        entity.timestamp, entity.relativeTimestamp);
  }
}
