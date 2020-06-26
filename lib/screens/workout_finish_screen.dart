import 'package:fitness_workouts/blocs/workout_create/workout_create.dart';
import 'package:fitness_workouts/widgets/styled_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class WorkoutFinishScreen extends StatelessWidget {
  static const String route = '/workout/finish';

  String name;
  String description;

  @override
  Widget build(BuildContext context) {
    final information =
        ModalRoute.of(context).settings.arguments as SetInformation;

    name = information.name ?? "";
    description = information.description ?? "";
    return Scaffold(
      appBar: AppBar(
        title: Text('Finish Workout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Name'),
            StyledTextField(
              initialValue: name,
              expands: false,
              onChange: (val) => name = val,
            ),
            SizedBox(
              height: 20,
            ),
            Text('Description'),
            StyledTextField(
              initialValue: description,
              expands: false,
              maxLines: 5,
              onChange: (val) => description = val,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (this.name == null || this.name.isEmpty) return;
          if (this.description == null || this.description.isEmpty) return;
          Navigator.of(context)
              .pop(SetInformation(name: name, description: description));
        },
        child: Icon(
          Icons.done,
        ),
      ),
    );
  }
}
