import 'package:flutter/material.dart';

import '../models.dart';
import 'activity_search_delegate.dart';

class ChipSearchField extends StatefulWidget {
  final Function(List<Activity>) onChange;

  const ChipSearchField({Key key, this.onChange}) : super(key: key);

  @override
  _ChipSearchFieldState createState() => _ChipSearchFieldState();
}

class _ChipSearchFieldState extends State<ChipSearchField> {
  List<Activity> selectedFields = [];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: GestureDetector(
            onTap: () => showSearch(
              context: context,
              delegate: ActivitySearch(
                toggle: toggle,
                selected: selectedFields,
                mode: ActivitySearchSelectMode.Multiple,
              ),
            ),
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Theme.of(context).primaryColor,
                ),
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).primaryColor,
              ),
              child: Wrap(
                spacing: 5,
                runSpacing: 5,
                children: selectedFields
                    .map(
                      (activity) => InputChip(
                        key: ObjectKey(activity),
                        label: Text(activity.name),
                        backgroundColor: Colors.transparent,
                        deleteIconColor: Theme.of(context).accentColor,
                        onDeleted: () => remove(activity),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
        RaisedButton(
          child: Icon(
            Icons.search,
            color: Theme.of(context).primaryColor,
          ),
          color: Theme.of(context).accentColor,
          onPressed: () => showSearch(
            context: context,
            delegate: ActivitySearch(
              toggle: toggle,
              selected: selectedFields,
              mode: ActivitySearchSelectMode.Multiple,
            ),
          ),
        ),
      ],
    );
  }

  bool toggle(Activity activity) {
    if (selectedFields.contains(activity)) {
      remove(activity);
      return false;
    }

    add(activity);
    return true;
  }

  void add(Activity activity) {
    setState(() {
      selectedFields = [...selectedFields, activity];
    });
    widget.onChange(selectedFields);
  }

  void remove(Activity activity) {
    setState(() {
      selectedFields.removeWhere((element) => element == activity);
    });
    widget.onChange(selectedFields);
  }
}
