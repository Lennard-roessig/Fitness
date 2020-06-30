import 'package:fitness_workouts/blocs/sounds/sounds_bloc.dart';
import 'package:fitness_workouts/models/sound.dart';

import 'package:fitness_workouts/widgets/styled_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SoundField extends StatefulWidget {
  final Sound initialSound;
  final Function(Sound sound) onChange;

  const SoundField({
    Key key,
    this.initialSound,
    this.onChange,
  }) : super(key: key);

  @override
  _SoundFieldState createState() => _SoundFieldState();
}

class _SoundFieldState extends State<SoundField> {
  Sound selected;

  @override
  void initState() {
    super.initState();
    selected = widget.initialSound;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final newSound = await soundList(context, widget.initialSound);
        if (newSound != selected) {
          setState(
            () {
              selected = newSound;
            },
          );
          if (widget.onChange != null) widget.onChange(selected);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        width: double.infinity,
        color: Theme.of(context).primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(selected?.name ?? ""),
            Icon(Icons.volume_down),
          ],
        ),
      ),
    );
  }

  Future<Sound> soundList(BuildContext context, Sound initial) {
    Sound selected = initial;

    return showDialog<Sound>(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => StyledAlertDialog(
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
          onCancel: () => Navigator.of(context).pop(initial),
          onFinish: () => Navigator.of(context).pop(selected),
        ),
      ),
    );
  }
}
