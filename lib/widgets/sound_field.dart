import 'package:fitness_workouts/models/sound.dart';
import 'package:fitness_workouts/widgets/dialogs/sound_list_dialog.dart';

import 'package:flutter/material.dart';

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
    return showDialog<Sound>(
      context: context,
      barrierDismissible: false,
      builder: (context) => SoundListDialog(initial),
    );
  }
}
