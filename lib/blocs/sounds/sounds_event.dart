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
