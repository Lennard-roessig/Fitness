part of 'timer_bloc.dart';

abstract class TimerState extends Equatable {
  final int seconds;
  final int delay;
  const TimerState(this.seconds, this.delay);
  @override
  List<Object> get props => [seconds, delay];
}

class TimerStopped extends TimerState {
  TimerStopped(int seconds) : super(seconds, 0);
}

class TimerRunning extends TimerState {
  TimerRunning(int seconds, int delay) : super(seconds, delay);
}
