import 'sound_value.dart';

class AlarmValue {
  final String label;
  final bool activ;
  final SoundValue sound;
  final int timestamp;
  final double relativeTimestamp;

  AlarmValue(
    this.label,
    this.activ,
    this.sound,
    this.timestamp,
    this.relativeTimestamp,
  );

  @override
  String toString() {
    return 'AlarmValue{label: $label, activ: $activ, sound: $sound, timestamp: $timestamp, relativeTimestamp: $relativeTimestamp}';
  }

  Map<String, Object> toJson() {
    return {
      'label': label,
      'activ': activ,
      'sound': sound.toJson(),
      'timestamp': timestamp,
      'relativeTimestamp': relativeTimestamp
    };
  }

  static AlarmValue fromJson(Map<String, Object> json) {
    return AlarmValue(
      json['label'] as String,
      json['activ'] as bool,
      SoundValue.fromJson(json['sound']),
      json['timestamp'] as int,
      json['relativeTimestamp'] as double,
    );
  }
}
