import 'package:flutter/material.dart';
import 'package:enefty_icons/enefty_icons.dart';

class MyBackIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        EneftyIcons.arrow_left_bold,
        color: Colors.white,
        size: 35,
      ),
      onPressed: () => Navigator.of(context).pop(),
    );
  }
}
