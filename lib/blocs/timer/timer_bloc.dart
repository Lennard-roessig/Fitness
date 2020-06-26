import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  Timer timer;
  int lastTime = 0;
  static const duration = const Duration(seconds: 1);

  @override
  TimerState get initialState => TimerStopped(0);

  @override
  Future<void> close() {
    timer?.cancel();
    timer = null;
    return super.close();
  }

  @override
  Stream<TimerState> mapEventToState(TimerEvent event) async* {
    print(event);
    if (event is StartTimer) {
      if (timer == null)
        timer = Timer.periodic(duration, (timer) {
          add(TickTimer(timer.tick + lastTime));
        });
      yield TimerRunning(state.seconds, duration.inSeconds * 1.0);
    }

    if (event is StopTimer) {
      lastTime = timer?.tick ?? 0;
      timer?.cancel();
      timer = null;
      yield TimerStopped(state.seconds);
    }

    if (event is ToggleTimer) {
      if (state is TimerStopped) add(StartTimer());
      if (state is TimerRunning) add(StopTimer());
      yield state;
    }

    if (event is ResetTimer) {
      if (state is TimerStopped) yield TimerStopped(state.seconds);
      if (state is TimerRunning)
        yield TimerRunning(state.seconds, duration.inSeconds * 1.0);
    }

    if (event is TickTimer && state is TimerRunning) {
      yield TimerRunning(event.seconds, duration.inSeconds * 1.0);
    }
  }
}
