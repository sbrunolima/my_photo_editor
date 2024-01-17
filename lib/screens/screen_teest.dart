import 'package:flutter/material.dart';

//Widgets
import '../widgets/slider_shape.dart';

class ScreenForTests extends StatefulWidget {
  @override
  State<ScreenForTests> createState() => _ScreenForTestsState();
}

class _ScreenForTestsState extends State<ScreenForTests> {
  double changedValue = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SliderTheme(
            data: const SliderThemeData(
              thumbColor: Colors.green,
              thumbShape: AppSliderShape(thumbRadius: 10),
            ),
            child: Slider(
              value: changedValue,
              min: 0,
              max: 250,
              divisions: 25,
              label: '$changedValue',
              onChanged: (value) {
                setState(() {
                  changedValue = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
