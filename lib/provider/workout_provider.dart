import 'dart:collection';

import 'package:fitness_workouts/model/workout_repository.dart';
import 'package:fitness_workouts/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

enum GroupPosition { Head, Tail, None, Mid, HeadAndTail }

class WorkoutProvider extends ChangeNotifier {
  final WorkoutRepository repository;

  List<Workout> _workouts;
  UnmodifiableListView<Workout> get workouts => UnmodifiableListView(_workouts);
  UnmodifiableListView<WorkoutPart> getGroupMembers(String groupId) =>
      UnmodifiableListView(
          workout.sequence.where((element) => element.groupId == groupId));

  int _selectedIndex;
  Workout get workout =>
      _selectedIndex == null ? null : _workouts[_selectedIndex];
  void select(Workout workout) {
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

  Workout createWorkout() {
    Workout newWorkout = Workout.empty(Uuid().v4());
    _workouts.add(newWorkout);
    select(newWorkout);
    return newWorkout;
  }

  int timeForIndex(index) {
    assert(_selectedIndex != null);

    int time = 0;
    int lastGroupTime = 0;
    for (int i = 0; i < index; i++) {
      if (workout.sequence[i].isGroup) {
        time = time + ((time - lastGroupTime) * workout.sequence[i].rounds);
        lastGroupTime = time;
        continue;
      }
      time += workout.sequence[i].intervall;
    }

    return time;
  }

  void reorderWorkoutParts(int oldIndex, int newIndex) {}

  int indexOfWorkoutPart(WorkoutPart part) {
    return workout.sequence.indexOf(part);
  }

  void updateWorkoutPart(
      WorkoutPart newWorkoutPart, WorkoutPart oldWorkoutPart) {
    assert(newWorkoutPart != null);
    assert(oldWorkoutPart != null);
    assert(_selectedIndex != null);
    final replaceIndex = workout.sequence.indexOf(oldWorkoutPart);
    workout.sequence
        .replaceRange(replaceIndex, replaceIndex + 1, [newWorkoutPart]);
    notifyListeners();
  }

  void deleteWorkoutPart(WorkoutPart toDelete) {
    assert(toDelete != null);
    assert(_selectedIndex != null);
    workout.sequence.removeWhere((element) => element == toDelete);
    if (toDelete.isGroup) updateAllGroups();
    notifyListeners();
  }

  void duplicateWorkoutPart(WorkoutPart toDuplicate) {
    assert(toDuplicate != null);
    assert(_selectedIndex != null);
    final duplicateIndex = workout.sequence.indexOf(toDuplicate);
    workout.sequence.insert(duplicateIndex + 1, toDuplicate.copy());
    notifyListeners();
  }

  void addNewWorkoutPart(WorkoutPart newPart, WorkoutPart behindThis) {
    assert(_selectedIndex != null);
    assert(newPart != null);

    if (behindThis == null) {
      workout.sequence.add(newPart);
      notifyListeners();
      return;
    }

    final duplicateIndex = workout.sequence.indexOf(behindThis);

    workout.sequence.insert(duplicateIndex + 1, newPart);
    updateAllGroups();
    notifyListeners();
  }

  WorkoutPart createNewWorkoutPart() {
    return WorkoutPart.empty();
  }

  WorkoutPart createNewGroupPart() {
    return WorkoutPart.empty(
      isGroup: true,
      referenceGroupId: Uuid().v4(),
    );
  }

  WorkoutPart createNewPausePart() {
    return WorkoutPart.empty(isPause: true);
  }

  void updateAllGroups() {
    assert(_selectedIndex != null);
    var groupId = "";

    for (final part in workout.sequence.reversed) {
      if (part.isGroup) {
        groupId = part.referenceGroupId;
        continue;
      }

      if (part.groupId != groupId) {
        updateWorkoutPart(part.copy(groupId: groupId), part);
      }
    }
    for (int i = workout.sequence.length - 1; i >= 0; i--) {}
  }

  GroupPosition groupPositionOfWorkout(WorkoutPart part) {
    assert(part != null);
    assert(workout != null);
    if (part.referenceGroupId.isNotEmpty) return GroupPosition.Tail;
    if (part.groupId.isEmpty) return GroupPosition.None;
    for (final element in workout.sequence) {
      if (element.groupId == part.groupId) {
        if (element == part)
          return GroupPosition.Head;
        else
          break;
      }
    }

    for (final element in workout.sequence.reversed) {
      if (element.groupId == part.groupId ||
          element.referenceGroupId == part.groupId) {
        if (element == part)
          return GroupPosition.Tail;
        else
          break;
      }
    }
    return GroupPosition.Mid;
  }
}
