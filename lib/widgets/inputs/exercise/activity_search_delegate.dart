import 'package:fitness_workouts/blocs/exercises/exercises.dart';
import 'package:fitness_workouts/models/exercise.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ExerciseSearchSelectMode { Single, Multiple }

class ExerciseSearch extends SearchDelegate<Exercise> {
  final bool Function(Exercise) toggle;
  final List<Exercise> selected;
  final ExerciseSearchSelectMode mode;

  ExerciseSearch({
    this.toggle,
    this.selected = const [],
    this.mode = ExerciseSearchSelectMode.Single,
  });

  @override
  String get searchFieldLabel => 'Search Exercise ...';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
      IconButton(
        icon: Icon(Icons.done),
        onPressed: () {
          close(context, null);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return BlocBuilder<ExercisesBloc, ExercisesState>(
        builder: (context, state) {
      if (state is ExercisesLoading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      final loadedState = state as ExercisesLoaded;
      return ListView(
          children: loadedState.exercises
              .where((exercise) =>
                  exercise.name.toLowerCase().contains(query.toLowerCase()))
              .map(
                (exercise) => StatefulBuilder(
                  builder: (context, setState) => GestureDetector(
                    child: ListTile(
                      trailing: selected.contains(exercise)
                          ? Icon(
                              Icons.done,
                              color: Theme.of(context).accentColor,
                            )
                          : Icon(
                              Icons.done,
                              color: Theme.of(context).primaryColor,
                            ),
                      title: Text(exercise.name),
                    ),
                    onTap: () {
                      setState(() {
                        switch (this.mode) {
                          case ExerciseSearchSelectMode.Single:
                            close(context, exercise);
                            break;
                          case ExerciseSearchSelectMode.Multiple:
                            assert(toggle != null);
                            bool add = toggle(exercise);
                            if (add) {
                              selected.add(exercise);
                            } else {
                              selected.removeWhere(
                                  (element) => element == exercise);
                            }
                            break;
                        }
                      });
                    },
                  ),
                ),
              )
              .toList());
    });
  }

  bool isEmpty(List<Exercise> model) {
    return model
        .where((activity) =>
            activity.name.toLowerCase().contains(query.toLowerCase()))
        .isEmpty;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return BlocBuilder<ExercisesBloc, ExercisesState>(
        builder: (context, state) {
      if (state is ExercisesLoading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      final loadedState = state as ExercisesLoaded;
      return ListView(
          children: loadedState.exercises
              .where((exercise) =>
                  exercise.name.toLowerCase().contains(query.toLowerCase()))
              .map(
                (exercise) => StatefulBuilder(
                  builder: (context, setState) => GestureDetector(
                    child: ListTile(
                      trailing: selected.contains(exercise)
                          ? Icon(
                              Icons.done,
                              color: Theme.of(context).accentColor,
                            )
                          : Icon(
                              Icons.done,
                              color: Theme.of(context).primaryColor,
                            ),
                      title: Text(exercise.name),
                    ),
                    onTap: () {
                      setState(() {
                        switch (this.mode) {
                          case ExerciseSearchSelectMode.Single:
                            close(context, exercise);
                            break;
                          case ExerciseSearchSelectMode.Multiple:
                            assert(toggle != null);
                            bool add = toggle(exercise);
                            if (add) {
                              selected.add(exercise);
                            } else {
                              selected.removeWhere(
                                  (element) => element == exercise);
                            }
                            break;
                        }
                      });
                    },
                  ),
                ),
              )
              .toList());
    });
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final theme = Theme.of(context);
    return theme;
  }
}
