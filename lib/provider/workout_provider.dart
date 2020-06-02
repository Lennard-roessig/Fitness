import 'dart:collection';

import 'package:fitness_workouts/model/workout_repository.dart';
import 'package:fitness_workouts/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class WorkoutProvider extends ChangeNotifier {
  final WorkoutRepository repository;

  List<Workout> _workouts;
  UnmodifiableListView<Workout> get workouts => UnmodifiableListView(_workouts);
  UnmodifiableListView<WorkoutPart> getGroupMembers(String groupId) =>
      UnmodifiableListView(sequence == null
          ? const []
          : sequence.where((element) => element.groupId == groupId));

  WorkoutLevel _selectedLevel = WorkoutLevel.Beginner;
  UnmodifiableListView<WorkoutPart> get sequence => UnmodifiableListView(
      workout == null && workout.sequence(_selectedLevel) != null
          ? const []
          : workout.sequence(_selectedLevel));
  void selectLevel(WorkoutLevel level) {
    _selectedLevel = level;
    notifyListeners();
  }

  WorkoutLevel get level => _selectedLevel;

  int _selectedIndex;
  Workout get workout =>
      _selectedIndex == null ? null : _workouts[_selectedIndex];
  void selectWorkout(Workout workout) {
    _selectedIndex = _workouts.indexOf(workout);
    notifyListeners();
  }

  void unselect() {
    _selectedIndex = null;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  WorkoutProvider({
    @required this.repository,
    List<Workout> workouts,
  }) : _workouts = workouts ?? [];

  Future loadWorkouts() {
    _isLoading = true;
    notifyListeners();

    return repository.loadWorkouts().then((loadedActivities) {
      _workouts.addAll(loadedActivities.map(Workout.fromEntity));
      _isLoading = false;
      notifyListeners();
    }).catchError((err) {
      _isLoading = false;
      notifyListeners();
    });
  }

  void updateWorkout(Workout workout) {
    assert(workout != null);
    assert(workout.id != null);
    final oldTodo = _workouts.firstWhere((it) => it.id == workout.id);
    final replaceIndex = _workouts.indexOf(oldTodo);
    _workouts.replaceRange(replaceIndex, replaceIndex + 1, [workout]);
    notifyListeners();
  }

  Workout workoutById(String id) {
    return _workouts.firstWhere((it) => it.id == id, orElse: () => null);
  }

  void removeWorkout(Workout workout) {
    _selectedIndex = null;
    _workouts.remove(workout);
    notifyListeners();
  }

  Workout createWorkout() {
    Workout newWorkout = Workout.empty(Uuid().v4());
    _workouts.add(newWorkout);
    selectWorkout(newWorkout);
    return newWorkout;
  }

  void updateWorkoutPart(
      WorkoutPart newWorkoutPart, WorkoutPart oldWorkoutPart) {
    assert(newWorkoutPart != null);
    assert(oldWorkoutPart != null);
    assert(_selectedIndex != null);

    updateWorkoutSequence(
        sequence.map((x) => x == oldWorkoutPart ? newWorkoutPart : x).toList());
  }

  void deleteWorkoutPart(WorkoutPart toDelete) {
    assert(toDelete != null);
    assert(workout != null);
    updateWorkoutSequence(sequence.where((x) => x != toDelete).toList());
    if (toDelete.isGroup) _updateAllGroups();
  }

  void addNewWorkoutPart(WorkoutPart newPart, WorkoutPart behindThis) {
    assert(workout != null);
    assert(newPart != null);
    if (behindThis == null) {
      updateWorkoutSequence([...sequence, newPart]);
      return;
    }

    updateWorkoutSequence(
        sequence.expand((x) => x == behindThis ? [x, newPart] : [x]).toList());
  }

  void updateWorkoutSequence(List<WorkoutPart> newSequence) {
    updateWorkout(
      workout.copy(sequence: {
        ...workout.sequenceMap,
        _selectedLevel: newSequence,
      }),
    );
    _updateAllGroups();
    notifyListeners();
  }

  void _updateAllGroups() {
    assert(workout != null);
    var groupId = "";
    bool update = false;

    final newSeq = sequence.reversed
        .map((part) {
          if (part.isGroup) {
            groupId = part.referenceGroupId;
          } else if (part.groupId != groupId) {
            update = true;

            return part.copy(groupId: groupId);
          }
          return part;
        })
        .toList()
        .reversed
        .toList();

    if (update) {
      updateWorkoutSequence(newSeq);
    }
  }

  void copyFrom(WorkoutLevel fromLevel) {
    updateWorkoutSequence(getSequence(fromLevel));
  }

  List<WorkoutPart> getSequence(WorkoutLevel level) {
    return workout.sequence(level);
  }
}
