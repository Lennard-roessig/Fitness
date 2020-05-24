import 'package:flutter/material.dart';

class WorkoutTile extends StatelessWidget {
  final String name;
  final String lastDate;
  final String duration;

  const WorkoutTile({
    Key key,
    this.name,
    this.lastDate,
    this.duration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Flexible(
          flex: 3,
          child: Stack(
            children: <Widget>[
              Container(
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(20),
                    right: Radius.circular(0),
                  ),
                  color: Theme.of(context).accentColor,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 1),
                height: 79,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(20),
                    right: Radius.circular(0),
                  ),
                  color: Theme.of(context).primaryColor,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      child: Text(
                        lastDate,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.access_time,
                            size: 12,
                          ),
                          Text(
                            duration,
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 50,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(20),
                    right: Radius.circular(0),
                  ),
                  color: Theme.of(context).primaryColorDark,
                ),
                child: Text(
                  name,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
        Flexible(
          child: Container(
            alignment: Alignment.topRight,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(0),
                right: Radius.circular(20),
              ),
              color: Theme.of(context).accentColor,
            ),
            child: Center(
              child: IconButton(
                icon: Icon(Icons.play_arrow),
                color: Colors.white,
                iconSize: 64,
                onPressed: () {},
              ),
            ),
          ),
        ),
      ],
    );
  }
}
