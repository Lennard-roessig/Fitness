import 'package:flutter/material.dart';

import '../models.dart';
import 'activity_search_delegate.dart';

class ChipSearchField extends StatefulWidget {
  final Function(List<Exercise>) onChange;

  const ChipSearchField({Key key, this.onChange}) : super(key: key);

  @override
  _ChipSearchFieldState createState() => _ChipSearchFieldState();
}

class _ChipSearchFieldState extends State<ChipSearchField> {
  List<Exercise> selectedFields = [];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: GestureDetector(
            onTap: () => showSearch(
              context: context,
              delegate: ExerciseSearch(
                toggle: toggle,
                selected: selectedFields,
                mode: ExerciseSearchSelectMode.Multiple,
              ),
            ),
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).primaryColor,
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      children: selectedFields
                          .map(
                            (exercise) => InputChip(
                              key: ObjectKey(exercise),
                              label: Text(exercise.name),
                              backgroundColor: Colors.transparent,
                              deleteIconColor: Theme.of(context).accentColor,
                              onDeleted: () => remove(exercise),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  IconButton(
                    alignment: Alignment.centerRight,
                    icon: Icon(Icons.search),
                    onPressed: () => showSearch(
                      context: context,
                      delegate: ExerciseSearch(
                        toggle: toggle,
                        selected: selectedFields,
                        mode: ExerciseSearchSelectMode.Multiple,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  bool toggle(Exercise exercise) {
    if (selectedFields.contains(exercise)) {
      remove(exercise);
      return false;
    }

    add(exercise);
    return true;
  }

  void add(Exercise exercise) {
    setState(() {
      selectedFields = [...selectedFields, exercise];
    });
    widget.onChange(selectedFields);
  }

  void remove(Exercise exercise) {
    setState(() {
      selectedFields.removeWhere((element) => element == exercise);
    });
    widget.onChange(selectedFields);
  }
}
