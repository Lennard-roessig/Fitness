import 'dart:collection';

import 'package:fitness_workouts/model/activities_repository.dart';
import 'package:fitness_workouts/models.dart';
import 'package:flutter/cupertino.dart';

class ActivityProvider extends ChangeNotifier {
  final ActivitiesRepository repository;

  List<Activity> _activities;
  UnmodifiableListView<Activity> get activities =>
      UnmodifiableListView(_activities);

  UnmodifiableListView<Activity> get selectedActivities =>
      UnmodifiableListView(_activities.where((element) => element.selected));

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ActivityProvider({
    @required this.repository,
    List<Activity> activities,
  }) : _activities = activities ?? [];

  Future loadActivities() {
    _isLoading = true;
    notifyListeners();

    return repository.loadActivities().then((loadedActivities) {
      _activities.addAll(loadedActivities.map(Activity.fromEntity));
      _isLoading = false;
      notifyListeners();
    }).catchError((err) {
      _isLoading = false;
      notifyListeners();
    });
  }

  void updateActivity(Activity activity) {
    assert(activity != null);
    assert(activity.id != null);
    var oldTodo = _activities.firstWhere((it) => it.id == activity.id);
    var replaceIndex = _activities.indexOf(oldTodo);
    _activities.replaceRange(replaceIndex, replaceIndex + 1, [activity]);
    notifyListeners();
  }

  Activity activityById(String id) {
    return _activities.firstWhere((it) => it.id == id, orElse: () => null);
  }
}
