import 'package:fitness_workouts/provider/activity_provider.dart';
import 'package:fitness_workouts/provider/workout_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models.dart';

enum ActivitySearchSelectMode { Single, Multiple }

class ActivitySearch extends SearchDelegate<Activity> {
  final bool Function(Activity) toggle;
  final List<Activity> selected;
  final ActivitySearchSelectMode mode;

  ActivitySearch({
    this.toggle,
    this.selected = const [],
    this.mode = ActivitySearchSelectMode.Single,
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

  // TODO has to be equal to Suggestions
  @override
  Widget buildResults(BuildContext context) {
    return Selector<ActivityProvider, List<Activity>>(
      selector: (_, model) => model.activities,
      builder: (context, model, _) => ListView(
        children: model.isEmpty
            ? Text('No Data')
            : !isEmpty(model)
                ? model
                    .where((activity) => activity.name
                        .toLowerCase()
                        .contains(query.toLowerCase()))
                    .map(
                      (activity) => StatefulBuilder(
                        builder: (context, setState) => GestureDetector(
                          child: ListTile(
                            trailing: selected.contains(activity)
                                ? Icon(
                                    Icons.done,
                                    color: Theme.of(context).accentColor,
                                  )
                                : Icon(
                                    Icons.done,
                                    color: Theme.of(context).primaryColor,
                                  ),
                            title: Text(activity.name),
                          ),
                          onTap: () {
                            setState(() {
                              switch (this.mode) {
                                case ActivitySearchSelectMode.Single:
                                  close(context, activity);
                                  break;
                                case ActivitySearchSelectMode.Multiple:
                                  assert(toggle != null);
                                  bool add = toggle(activity);
                                  if (add) {
                                    selected.add(activity);
                                  } else {
                                    selected.removeWhere(
                                        (element) => element == activity);
                                  }
                                  break;
                              }
                            });
                          },
                        ),
                      ),
                    )
                    .toList()
                : [
                    ListTile(
                      title: FlatButton(
                        child: Text('add'),
                        onPressed: () {},
                      ),
                    )
                  ],
      ),
    );
  }

  bool isEmpty(List<Activity> model) {
    return model
        .where((activity) =>
            activity.name.toLowerCase().contains(query.toLowerCase()))
        .isEmpty;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Selector<ActivityProvider, List<Activity>>(
        selector: (_, model) => model.activities,
        builder: (context, model, _) => ListView(
              children: model.isEmpty
                  ? Text('Waiting for Data')
                  : model
                      .where((activity) => activity.name
                          .toLowerCase()
                          .contains(query.toLowerCase()))
                      .map(
                        (activity) => StatefulBuilder(
                          builder: (context, setState) => GestureDetector(
                            child: ListTile(
                              trailing: selected.contains(activity)
                                  ? Icon(
                                      Icons.done,
                                      color: Theme.of(context).accentColor,
                                    )
                                  : Icon(
                                      Icons.done,
                                      color: Theme.of(context).primaryColor,
                                    ),
                              title: Text(activity.name),
                            ),
                            onTap: () {
                              setState(() {
                                switch (this.mode) {
                                  case ActivitySearchSelectMode.Single:
                                    close(context, activity);
                                    break;
                                  case ActivitySearchSelectMode.Multiple:
                                    assert(toggle != null);
                                    bool add = toggle(activity);
                                    if (add) {
                                      selected.add(activity);
                                    } else {
                                      selected.removeWhere(
                                          (element) => element == activity);
                                    }
                                    break;
                                }
                              });
                            },
                          ),
                        ),
                      )
                      .toList(),
            ));
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final theme = Theme.of(context);
    return theme;
  }
}
