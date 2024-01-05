import 'dart:io';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:screenshot/screenshot.dart';

//Widgets
import '../widgets/my_back_icon.dart';
import '../widgets/save_and_delete_file_widget.dart';

class CropImagePage extends StatefulWidget {
  final String imagePath;
  final String imageName;
  final bool isEditing;
  final Function(String, bool) callback;

  CropImagePage({
    required this.imagePath,
    required this.imageName,
    required this.isEditing,
    required this.callback,
  });

  @override
  State<CropImagePage> createState() => _CropImagePageState();
}

class _CropImagePageState extends State<CropImagePage> {
  ScreenshotController screenshotController = ScreenshotController();
  File? imageFile;
  String temporaryPath = '';

  @override
  void initState() {
    super.initState();
    imageFile = File(widget.imagePath);
    cropImage();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: MyBackIcon(),
        title: Text(
          'Recortar',
          style: GoogleFonts.openSans(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: cropImage,
            icon: const Icon(
              EneftyIcons.gallery_edit_bold,
              color: Colors.orange,
              size: 30,
            ),
          ),
          const SizedBox(width: 5.0),
        ],
      ),
      body: Center(
        child: imageFile != null
            ? Screenshot(
                controller: screenshotController,
                child: Image.file(imageFile!),
              )
            : const SizedBox(),
      ),
      //SAVE BUTTOM
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: GestureDetector(
          onTap: () {
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
                const Icon(
                  EneftyIcons.brush_2_bold,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 4.0),
                Text(
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
    );
  }

  Future cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: widget.imagePath,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Recortar',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
          cropFrameColor: Colors.orange.shade900,
          cropGridColor: Colors.orange.shade900,
        ),
      ],
    );

    if (croppedFile != null) {
      imageFile = File(croppedFile.path);
      setState(() {});
    }
  }
}
