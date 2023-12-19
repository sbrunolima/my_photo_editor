import 'package:flutter/material.dart';

class BackgroundColors extends StatefulWidget {
  final int colorSelected;
  final Function(Color) callback;

  BackgroundColors({required this.colorSelected, required this.callback});

  @override
  State<BackgroundColors> createState() => _BackgroundColorsState();
}

class _BackgroundColorsState extends State<BackgroundColors> {
  List newBackgroundColors = [
    Colors.transparent,
    Colors.white,
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.grey,
    Colors.black,
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.callback(newBackgroundColors[widget.colorSelected]);
      },
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
          color: newBackgroundColors[widget.colorSelected],
        ),
        child: widget.colorSelected == 0
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset('assets/Transparent.png'),
              )
            : null,
      ),
    );
  }
}
