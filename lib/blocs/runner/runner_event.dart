part of 'runner_bloc.dart';

abstract class RunnerEvent {
  const RunnerEvent();
}

class UpdateTimeRunner extends RunnerEvent {
  final int seconds;
  final int delay;

  UpdateTimeRunner(this.seconds, this.delay);
}

class FinishedRepetitionRunner extends RunnerEvent {}

class SkipRunner extends RunnerEvent {}

class BackRunner extends RunnerEvent {}

class FinishRunner extends RunnerEvent {}

class RepeatRunner extends RunnerEvent {}
