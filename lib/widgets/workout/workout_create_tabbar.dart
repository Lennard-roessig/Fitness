import 'package:fitness_workouts/blocs/workout_create/workout_create.dart';
import 'package:fitness_workouts/models/workout.dart';
import 'package:fitness_workouts/screens/workout/workout_finish_screen.dart';
import 'package:fitness_workouts/util/tab_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkoutCreateTabbar extends StatefulWidget
    implements PreferredSizeWidget {
  const WorkoutCreateTabbar({Key key}) : super(key: key);

  @override
  _WorkoutCreateTabbarState createState() => _WorkoutCreateTabbarState();

  @override
  Size get preferredSize => Size(double.infinity, 100);
}

class _WorkoutCreateTabbarState extends State<WorkoutCreateTabbar>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        TabController(initialIndex: 0, length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Workout Edit'),
      actions: <Widget>[
        FlatButton(
          onPressed: () async {
            final bloc = BlocProvider.of<WorkoutCreateBloc>(context);
            final readyState = bloc.state as WorkoutCreateReady;

            final value = await Navigator.of(context).push(
              MaterialPageRoute(builder: (_) {
                return WorkoutFinishScreen(
                  information: SetInformation(
                    name: readyState.workout.name,
                    description: readyState.workout.description,
                  ),
                );
              }),
            );
            if (value != null) {
              bloc.add(value);
              bloc.add(Save());
              Navigator.of(context).pop();
            }
          },
          child: Text('Next'),
        ),
      ],
      bottom: TabBar(
        onTap: (index) {
          BlocProvider.of<WorkoutCreateBloc>(context)
              .add(SwitchLevel(to: tabs[index].data));
        },
        controller: _controller,
        tabs: <Tab>[
          for (final tab in tabs)
            Tab(
              text: tab.title,
            ),
        ],
      ),
    );
  }

  void switching(index) {
    BlocProvider.of<WorkoutCreateBloc>(context)
        .add(SwitchLevel(to: tabs[index].data));
  }

  List<TabEntry> get tabs {
    return [
      TabEntry(
        title: 'Beginner',
        data: WorkoutLevel.Beginner,
        icon: Icon(
          Icons.directions_run,
        ),
      ),
      TabEntry(
        title: 'Advanced',
        data: WorkoutLevel.Advanced,
        icon: Icon(
          Icons.home,
        ),
      ),
      TabEntry(
        title: 'Professional',
        data: WorkoutLevel.Professional,
        icon: Icon(
          Icons.directions_run,
        ),
      ),
    ];
  }
}
