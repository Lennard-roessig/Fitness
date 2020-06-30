part of 'sounds_bloc.dart';

abstract class SoundsEvent extends Equatable {
  const SoundsEvent();

  @override
  List<Object> get props => [];
}

class LoadSounds extends SoundsEvent {}

class UpdatedSounds extends SoundsEvent {
  final List<Sound> sounds;

  const UpdatedSounds([this.sounds = const []]);

  @override
  List<Object> get props => [this.sounds];

  @override
  String toString() {
    return 'UpdatedSounds { sounds: $sounds }';
  }
}

class PlayTTS extends SoundsEvent {
  final String text;

  const PlayTTS(this.text);

  @override
  List<Object> get props => [text];

  @override
  String toString() {
    return 'PlayTTS { text: $text }';
  }
}

class PlaySound extends SoundsEvent {
  final Sound sound;

  const PlaySound(this.sound);

  @override
  List<Object> get props => [sound];

  @override
  String toString() {
    return 'PlaySound { sound: $sound }';
  }
}

class PlayDefaultSound extends SoundsEvent {
  @override
  String toString() {
    return 'PlayDefaultSound';
  }
}

class PrepareSounds extends SoundsEvent {
  final List<Sound> sounds;

  const PrepareSounds(this.sounds);

  @override
  List<Object> get props => [sounds];

  @override
  String toString() {
    return 'PrepareSounds { sounds: $sounds }';
  }
}
