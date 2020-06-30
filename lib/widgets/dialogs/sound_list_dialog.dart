import 'package:fitness_workouts/blocs/sounds/sounds_bloc.dart';
import 'package:fitness_workouts/models/sound.dart';
import 'package:fitness_workouts/widgets/dialogs/styled_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SoundListDialog extends StatefulWidget {
  final Sound sound;

  SoundListDialog(this.sound);

  @override
  _SoundListDialogState createState() => _SoundListDialogState();
}

class _SoundListDialogState extends State<SoundListDialog> {
  Sound selected;

  @override
  Widget build(BuildContext context) {
    return StyledAlertDialog(
      title: Text('Custom Dialog'),
      content: Container(
        width: 250,
        height: 350,
        child: BlocBuilder<SoundsBloc, SoundsState>(builder: (c, state) {
          if (state is SoundsLoading) {
            return CircularProgressIndicator();
          }

          final loadedState = (state as SoundsLoaded);
          return ListView.builder(
            itemCount: loadedState.sounds.length,
            itemBuilder: (_, index) => GestureDetector(
              onTap: () => setState(() {
                selected = loadedState.sounds[index];
              }),
              child: ListTile(
                title: Text(loadedState.sounds[index].name),
                trailing: Icon(
                  Icons.done,
                  color: selected == loadedState.sounds[index]
                      ? Theme.of(context).accentColor
                      : Theme.of(context).primaryColor,
                ),
              ),
            ),
          );
        }),
      ),
      onCancel: () => Navigator.of(context).pop(widget.sound),
      onFinish: () => Navigator.of(context).pop(selected),
    );
  }
}
