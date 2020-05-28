import 'package:flutter/material.dart';

enum NumberType { Int, Double }

class NumberInput extends StatefulWidget {
  final String suffixLabel;
  final double initialValue;
  final double stepSize;
  final NumberType type;
  final Function(double value) onChange;

  const NumberInput({
    Key key,
    this.suffixLabel,
    this.initialValue = 0,
    this.stepSize = 1,
    this.type = NumberType.Int,
    this.onChange,
  }) : super(key: key);

  @override
  _NumberInputState createState() => _NumberInputState();
}

class _NumberInputState extends State<NumberInput> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller.text = convertValue(widget.initialValue);
    _controller.addListener(() {
      if (_controller.text.isNotEmpty) {
        double newValue = double.parse(_controller.text);
        if (widget.onChange != null) widget.onChange(newValue);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      child: Column(
        children: <Widget>[
          TextField(
            keyboardType: TextInputType.number,
            controller: _controller,
            expands: false,
            decoration: InputDecoration(
              suffix: Text(widget.suffixLabel ?? ""),
              prefix: Text(
                widget.suffixLabel ?? "",
                style: TextStyle(color: Colors.transparent),
              ),
              border: InputBorder.none,
            ),
            textAlign: TextAlign.center,
            onTap: clearField,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: IconButton(
                    color: Theme.of(context).primaryColor,
                    icon: Icon(Icons.add),
                    onPressed: () => step(1),
                  ),
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: IconButton(
                    color: Theme.of(context).primaryColor,
                    icon: Icon(Icons.remove),
                    onPressed: () => step(-1),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void step(int direction) {
    _setValue(value + direction * widget.stepSize);
  }

  void clearField() {
    _controller.text = "";
  }

  void _setValue(double newValue) {
    _controller.text = convertValue(newValue);
  }

  String convertValue(double newValue) {
    return newValue.toStringAsFixed(widget.type == NumberType.Int ? 0 : 1);
  }

  double get value {
    return _controller.text.isNotEmpty ? double.parse(_controller.text) : 0;
  }
}

// Column(
//       children: <Widget>[
//         InkWell(
//           onTap: () => step(1),
//           child: Container(
//             width: double.infinity,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(10),
//                 topRight: Radius.circular(10),
//               ),
//               color: Theme.of(context).accentColor,
//             ),
//             child: Icon(Icons.add),
//           ),
//         ),
//         Flexible(
//           flex: 2,
//           child: Container(
//             padding: EdgeInsets.all(5),
//             color: Theme.of(context).primaryColor,
//             child: TextField(
//               keyboardType: TextInputType.number,
//               controller: _controller,
//               expands: false,
//               decoration: InputDecoration(
//                 suffix: Text(widget.suffixLabel ?? ""),
//                 prefix: Text(
//                   widget.suffixLabel ?? "",
//                   style: TextStyle(color: Colors.transparent),
//                 ),
//                 border: InputBorder.none,
//               ),
//               textAlign: TextAlign.center,
//               onTap: clearField,
//             ),
//           ),
//         ),
//         InkWell(
//           onTap: () => step(-1),
//           child: Container(
//             width: size.width,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(10),
//                 bottomRight: Radius.circular(10),
//               ),
//               color: Theme.of(context).accentColor,
//             ),
//             child: Icon(Icons.remove),
//           ),
//         ),
//       ],
//     );
