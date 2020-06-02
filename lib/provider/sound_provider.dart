import 'dart:collection';

import 'package:fitness_workouts/models.dart';
import 'package:flutter/cupertino.dart';

class SoundProvider extends ChangeNotifier {
  List<Sound> _sounds;
  UnmodifiableListView<Sound> get sounds => UnmodifiableListView(_sounds);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  SoundProvider({
    List<Sound> sounds,
  }) : _sounds = sounds ?? [];

  // Future loadActivities() {
  //   _isLoading = true;
  //   notifyListeners();

  //   return repository.loadActivities().then((loadedActivities) {
  //     _activities.addAll(loadedActivities.map(Activity.fromEntity));
  //     _isLoading = false;
  //     notifyListeners();
  //   }).catchError((err) {
  //     _isLoading = false;
  //     notifyListeners();
  //   });
  // }

  // void updateActivity(Activity activity) {
  //   assert(activity != null);
  //   assert(activity.id != null);
  //   var oldTodo = _activities.firstWhere((it) => it.id == activity.id);
  //   var replaceIndex = _activities.indexOf(oldTodo);
  //   _activities.replaceRange(replaceIndex, replaceIndex + 1, [activity]);
  //   notifyListeners();
  // }

}
