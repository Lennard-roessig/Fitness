import 'package:fitness_workouts/util/dialogs.dart';
import 'package:fitness_workouts/widgets/activity_search_delegate.dart';

import 'package:fitness_workouts/widgets/speed_dial.dart';

import 'package:fitness_workouts/widgets/workout_part_tile.dart';
import 'package:flutter/material.dart';

import '../models.dart';

/*

Work on Timeline 
- switch parts
- add parts
- remove parts 
- create Rounds
- etc. 
*/
class WorkoutTimelineView extends StatefulWidget {
  final List<WorkoutPart> sequence;
  final Function(List<WorkoutPart> sequence) updateSequence;

  WorkoutTimelineView({this.sequence, this.updateSequence});

  @override
  _WorkoutTimelineViewState createState() => _WorkoutTimelineViewState();
}

class _WorkoutTimelineViewState extends State<WorkoutTimelineView> {
  // List<WorkoutPart> localSequence;
  WorkoutPart selected;

  @override
  void initState() {
    super.initState();
    // localSequence = widget.sequence != null ? widget.sequence : [];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => setState(() {
        selected = null;
      }),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              right: 41,
              child: Container(
                width: 1,
                height: size.height,
                color: Theme.of(context).accentColor,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Theme(
                data:
                    Theme.of(context).copyWith(canvasColor: Colors.transparent),
                child: ReorderableListView(
                  children: [
                    for (final workoutpart in widget.sequence)
                      Padding(
                        key: ObjectKey(workoutpart),
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: WorkoutPartTile(
                          workoutpart: workoutpart,
                          time: time(workoutpart),
                          add: add,
                          delete: delete,
                          update: update,
                          tab: tab,
                          isActiv: selected == workoutpart,
                        ),
                      ),
                  ],
                  onReorder: reorder,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                margin: EdgeInsets.only(bottom: 20),
                child: SpeedDial(items: [
                  SpeedDialItem(Icons.fitness_center, Text('Exercise'),
                      () async {
                    Activity choosenActivity = await showSearch(
                      context: context,
                      delegate: ActivitySearch(
                        mode: ActivitySearchSelectMode.Single,
                      ),
                    );
                    if (choosenActivity == null) return;
                    add(WorkoutPart.empty()
                        .copy(activityId: choosenActivity.id));
                  }),
                  SpeedDialItem(Icons.pause, Text('Pause'), () async {
                    double value = await numberInputDialog(
                      context,
                      'Pause Intervall',
                      0,
                      'sec',
                    );
                    add(WorkoutPart.pause(intervall: value.toInt()));
                  }),
                  SpeedDialItem(Icons.group, Text('Round'), () async {
                    add(WorkoutPart.group());
                  }),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int time(WorkoutPart part) {
    assert(part != null);
    int time = 0;
    int lastGroupTime = 0;
    for (int i = 0; i < widget.sequence.indexOf(part); i++) {
      if (widget.sequence[i].isGroup) {
        time =
            time + ((time - lastGroupTime) * (widget.sequence[i].rounds - 1));
        lastGroupTime = time;
        continue;
      }
      time += widget.sequence[i].intervall;
    }
    return time;
  }

  void reorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final tmp =
        widget.sequence.where((x) => x != widget.sequence[oldIndex]).toList();

    widget.updateSequence([
      ...tmp.sublist(0, newIndex),
      widget.sequence[oldIndex],
      ...tmp.sublist(newIndex, tmp.length)
    ]);
  }

  void add(WorkoutPart part) {
    assert(part != null);
    if (selected != null) {
      int index = widget.sequence.indexOf(selected);
      widget.updateSequence([
        ...widget.sequence.sublist(0, index + 1),
        part,
        ...widget.sequence.sublist(index + 1, widget.sequence.length)
      ]);
      // to switch focus
      tab(part);
      return;
    }

    widget.updateSequence([...widget.sequence, part]);
  }

  void delete(WorkoutPart part) {
    assert(part != null);
    widget.updateSequence(widget.sequence.where((x) => x != part).toList());
  }

  void update(WorkoutPart oldPart, WorkoutPart newPart) {
    assert(newPart != null);
    assert(oldPart != null);

    widget.updateSequence(
        widget.sequence.map((x) => x == oldPart ? newPart : x).toList());
  }

  void tab(WorkoutPart part) {
    setState(() {
      if (selected == part)
        selected = null;
      else
        selected = part;
    });
  }
}

enum MenuItemActionTarget { Activity, Group, Pause, PauseAndActivity, All }

class MenuItem {
  final IconData icon;
  final Function action;
  final MenuItemActionTarget actionTarget;

  MenuItem(
    this.icon, {
    this.action,
    this.actionTarget,
  });
}
