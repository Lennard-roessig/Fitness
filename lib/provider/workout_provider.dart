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
    // if (sequence.isEmpty) {
    //   updateWorkoutSequence(workout.sequenceMap[WorkoutLevel.Beginner]);
    // }
    notifyListeners();
  }

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

  int timeForIndex(index) {
    assert(_selectedIndex != null);
    int time = 0;
    int lastGroupTime = 0;
    for (int i = 0; i < index; i++) {
      if (sequence[i].isGroup) {
        time = time + ((time - lastGroupTime) * sequence[i].rounds);
        lastGroupTime = time;
        continue;
      }
      time += sequence[i].intervall;
    }
    return time;
  }

  void reorderWorkoutParts(int oldIndex, int newIndex) {}

  int indexOfWorkoutPart(WorkoutPart part) {
    return sequence.indexOf(part);
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
    if (toDelete.isGroup) updateAllGroups();
  }

  void duplicateWorkoutPart(WorkoutPart toDuplicate) {
    assert(toDuplicate != null);
    assert(workout != null);
    updateWorkoutSequence(sequence
        .expand((x) => x == toDuplicate ? [x, x.copy()] : [x])
        .toList());
  }

  void addNewWorkoutPart(WorkoutPart newPart, WorkoutPart behindThis) {
    assert(workout != null);
    assert(newPart != null);

    final p = sequence;
    if (behindThis == null) {
      updateWorkoutSequence([...sequence, newPart]);
      return;
    }

    updateWorkoutSequence(
        sequence.expand((x) => x == behindThis ? [x, newPart] : [x]).toList());
  }

  void switchWorkoutpartPosition(oldIndex, newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final tmp = sequence.where((x) => x != sequence[oldIndex]).toList();

    updateWorkoutSequence([
      ...tmp.sublist(0, newIndex),
      sequence[oldIndex],
      ...tmp.sublist(newIndex, tmp.length)
    ]);
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

    for (final part in sequence.reversed) {
      if (part.isGroup) {
        groupId = part.referenceGroupId;
        continue;
      }

      if (part.groupId != groupId) {
        updateWorkoutPart(part.copy(groupId: groupId), part);
      }
    }
    for (int i = sequence.length - 1; i >= 0; i--) {}
  }

  GroupPosition groupPositionOfWorkout(WorkoutPart part) {
    assert(part != null);
    assert(workout != null);
    if (part.referenceGroupId.isNotEmpty) return GroupPosition.Tail;
    if (part.groupId.isEmpty) return GroupPosition.None;
    for (final element in sequence) {
      if (element.groupId == part.groupId) {
        if (element == part)
          return GroupPosition.Head;
        else
          break;
      }
    }

    for (final element in sequence.reversed) {
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

  void updateWorkoutSequence(List<WorkoutPart> newSequence) {
    updateWorkout(
      workout.copy(sequence: {
        ...workout.sequenceMap,
        _selectedLevel: newSequence,
      }),
    );
    updateAllGroups();
    notifyListeners();
  }
}
