import 'dart:io';
import 'package:flutter/material.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:screenshot/screenshot.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:themed/themed.dart';

//Widgets
import '../widgets/slider_shape.dart';
import '../widgets/my_back_icon.dart';
import '../widgets/save_and_delete_file_widget.dart';

class HuePage extends StatefulWidget {
  static const routeName = '/contrast-screen';

  final String imagePath;
  final String imageName;
  final bool isEditing;
  final Function(String, bool) callback;

  HuePage({
    required this.imagePath,
    required this.imageName,
    required this.isEditing,
    required this.callback,
  });

  @override
  State<HuePage> createState() => _HuePageState();
}

class _HuePageState extends State<HuePage> {
  double changedValue = 0;
  ScreenshotController screenshotController = ScreenshotController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: MyBackIcon(),
        title: Text(
          'Hue',
          style: GoogleFonts.openSans(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Screenshot(
        controller: screenshotController,
        child: ChangeColors(
          hue: changedValue,
          child: Image.file(
            File(widget.imagePath),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 145,
        color: Colors.black,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //BRITHNESS BAR
            SliderTheme(
              data: const SliderThemeData(
                thumbColor: Colors.green,
                thumbShape: AppSliderShape(thumbRadius: 10),
              ),
              child: Slider(
                value: changedValue,
                min: 0,
                max: 1,
                divisions: 10,
                label: changedValue.toStringAsFixed(1),
                onChanged: (value) {
                  setState(() {
                    changedValue = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 20.0),
            //SAVE BUTTOM
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isLoading = true;
                  });

                  saveImage(
                    imagePath: widget.imagePath,
                    isEditing: widget.isEditing,
                    screenshotController: screenshotController,
                    context: context,
                    callback: (newImagePath, newEditValue) {
                      widget.callback(newImagePath, newEditValue);
                    },
                  );
                },
                child: Container(
                  height: 55,
                  width: size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    color: Colors.white30,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!isLoading)
                        const Icon(
                          EneftyIcons.brush_2_bold,
                          color: Colors.white,
                          size: 20,
                        ),
                      const SizedBox(width: 4.0),
                      isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'Salvar',
                              style: GoogleFonts.openSans(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
