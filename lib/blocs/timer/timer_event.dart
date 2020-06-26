part of 'timer_bloc.dart';

abstract class TimerEvent {
  const TimerEvent();
}

class ToggleTimer extends TimerEvent {}

class StartTimer extends TimerEvent {}

class StopTimer extends TimerEvent {}

class ResetTimer extends TimerEvent {}

class TickTimer extends TimerEvent {
  final int seconds;

  TickTimer(this.seconds);
}
