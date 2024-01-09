import 'dart:io';
import 'package:flutter/material.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:screenshot/screenshot.dart';
import 'package:google_fonts/google_fonts.dart';

//Widgets
import '../widgets/my_back_icon.dart';
import '../widgets/save_and_delete_file_widget.dart';

class ImageContrastWidget extends StatefulWidget {
  static const routeName = '/contrast-screen';

  final String imagePath;
  final String imageName;
  final bool isEditing;
  final Function(String, bool) callback;

  ImageContrastWidget({
    required this.imagePath,
    required this.imageName,
    required this.isEditing,
    required this.callback,
  });

  @override
  _ImageContrastWidgetState createState() => _ImageContrastWidgetState();
}

class _ImageContrastWidgetState extends State<ImageContrastWidget> {
  int contrastColorIndex = 0;
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
          'Contraste',
          style: GoogleFonts.openSans(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Screenshot(
        controller: screenshotController,
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(
              contrastColors[contrastColorIndex], BlendMode.colorBurn),
          child: Image.file(
            File(widget.imagePath),
            width: size.width,
            height: size.height,
            fit: BoxFit.contain,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 145,
        color: Colors.black,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //CONTRAST LIST
            SizedBox(
              height: 60.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                itemCount: contrastColors.length,
                itemBuilder: (context, index) {
                  return contrastedImagesContainer(
                      color: contrastColors[index],
                      colorIndex: index,
                      callback: (value) {
                        setState(() {
                          contrastColorIndex = value;
                        });
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

  List<Color> contrastColors = [
    Colors.grey.shade100,
    Colors.grey.shade200,
    Colors.grey.shade300,
    Colors.grey.shade400,
    Colors.grey.shade500,
    Colors.grey.shade600,
  ];

  Widget contrastedImagesContainer({
    required Color color,
    required int colorIndex,
    required Function(int) callback,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: GestureDetector(
        onTap: () {
          callback(colorIndex);
        },
        child: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6.0),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(color, BlendMode.colorBurn),
              child: Image.file(
                File(widget.imagePath),
                height: 60,
                width: 60,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
