import 'package:fitness_workouts/models.dart';
import 'package:fitness_workouts/provider/sound_provider.dart';
import 'package:fitness_workouts/widgets/styled_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
            child: Consumer<SoundProvider>(
              builder: (_, provider, __) => ListView.builder(
                itemCount: provider.sounds.length,
                itemBuilder: (_, index) => GestureDetector(
                  onTap: () => setState(() {
                    selected = provider.sounds[index];
                  }),
                  child: ListTile(
                    title: Text(provider.sounds[index].name),
                    trailing: Icon(
                      Icons.done,
                      color: selected == provider.sounds[index]
                          ? Theme.of(context).accentColor
                          : Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
          onCancel: () => Navigator.of(context).pop(initial),
          onFinish: () => Navigator.of(context).pop(selected),
        ),
      ),
    );
  }
}
