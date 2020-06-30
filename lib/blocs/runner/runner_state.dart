part of 'runner_bloc.dart';

abstract class RunnerState extends Equatable {
  final int round;
  final int time;
  final Activity activity;
  final int index;

  const RunnerState(this.round, this.time, this.activity, this.index);
  @override
  List<Object> get props => [round, time, activity, index];
}

// for activities based on repetitions instead of time
class RunnerWaiting extends RunnerState {
  RunnerWaiting({
    int round,
    int time,
    Activity activity,
    int index,
  }) : super(round, time, activity, index);
}

class RunnerRunningAndWaiting extends RunnerState {
  RunnerRunningAndWaiting({
    int round,
    int time,
    Activity activity,
    int index,
  }) : super(round, time, activity, index);
}

class RunnerRunning extends RunnerState {
  RunnerRunning({
    int round,
    int time,
    Activity activity,
    int index,
  }) : super(round, time, activity, index);
}

class RunnerFinished extends RunnerState {
  RunnerFinished({
    int round,
    int time,
    int index,
  }) : super(round, time, Activity.pause(), index);
}
