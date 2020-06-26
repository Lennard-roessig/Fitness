part of 'runner_bloc.dart';

abstract class RunnerEvent {
  const RunnerEvent();
}

class UpdateTimeRunner extends RunnerEvent {
  final int seconds;
  final double delay;

  UpdateTimeRunner(this.seconds, this.delay);
}

class FinishedRepetitionRunner extends RunnerEvent {}

class SkipRunner extends RunnerEvent {}

class BackRunner extends RunnerEvent {}
