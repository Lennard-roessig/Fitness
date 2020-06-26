import 'package:fitness_workouts/blocs/activities/exercises.dart';
import 'package:fitness_workouts/widgets/styled_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActivityListScreen extends StatelessWidget {
  static const route = "activities/list/";
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExercisesBloc, ExercisesState>(
        builder: (context, state) {
      if (state is ExercisesLoading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      final loadedState = state as ExercisesLoaded;
      return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: StyledTextField(
                expands: false,
                suffix: 'Icon',
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: loadedState.exercises.length,
                  itemBuilder: (_, index) => Container(
                    margin: EdgeInsets.only(top: 10),
                    color: Theme.of(context).primaryColorDark,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Flexible(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      Flexible(
                                        child: FittedBox(
                                          child: Text(loadedState
                                              .exercises[index].name),
                                        ),
                                      ),
                                      Spacer(),
                                      Icon(
                                        Icons.fitness_center,
                                        color: Theme.of(context).accentColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: 50,
                                width: 50,
                                color: Theme.of(context).accentColor,
                                child: Icon(Icons.info_outline),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 12,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          width: double.infinity,
                          color: Theme.of(context).accentColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Difficulty: Easy',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              Text(
                                'Muscle(s): ${loadedState.exercises[index].primaryMuscles.join(",")}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
