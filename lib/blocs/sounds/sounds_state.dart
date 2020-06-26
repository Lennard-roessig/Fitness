part of 'sounds_bloc.dart';

abstract class SoundsState extends Equatable {
  const SoundsState();
  @override
  List<Object> get props => [];
}

class SoundsLoading extends SoundsState {}

class SoundsLoaded extends SoundsState {
  final List<Sound> sounds;

  const SoundsLoaded(this.sounds);

  @override
  List<Object> get props => [sounds];

  @override
  String toString() {
    return 'SoundsLoaded { sounds: $sounds }';
  }
}
