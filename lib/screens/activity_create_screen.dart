import 'package:fitness_workouts/widgets/styled_text_field.dart';
import 'package:flutter/material.dart';

class ActivityCreateScreen extends StatelessWidget {
  static const route = '/activity/create';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Exercise'),
      ),
      body: ListView(
        children: <Widget>[
          Text('Name'),
          StyledTextField(
            expands: false,
          ),
          Text('Difficulty'),
          Row(
            children: <Widget>[
              FlatButton(
                child: Text('Beginner'),
                onPressed: () {},
              ),
              FlatButton(
                child: Text('Advanced'),
                onPressed: () {},
              ),
              FlatButton(
                child: Text('Professional'),
                onPressed: () {},
              ),
            ],
          ),
          Text('Primary Muscle'),
          Text('Supporting Muscle'),
          Text('Equipment'),
          Text('Detailed Information Video'),
          StyledTextField(
            expands: false,
          ),
          Text('Short Repetition Video (< 3sec.)'),
          StyledTextField(
            expands: false,
          ),
          Text('Description'),
          Container(
            height: 200,
            child: StyledTextField(
              expands: true,
              maxLines: null,
            ),
          ),
          RaisedButton(
            onPressed: () {
              // final activity = Activity.empty(
              //   difficulty: null,
              //   name: "Test",
              //   primary: <ExerciseMuscleTarget>[ExerciseMuscleTarget.Bizeps],
              //   supporting: <ExerciseMuscleTarget>[ExerciseMuscleTarget.Bizeps],
              // );
              // Navigator.of(context).pop(activity);
            },
            child: Text('Finish'),
          )
        ],
      ),
    );
  }
}
