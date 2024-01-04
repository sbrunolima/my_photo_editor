import 'dart:io';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

//Widgets
import '../widgets/my_back_icon.dart';

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
          onTap: saveImage,
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
          backgroundColor: Colors.black,
          statusBarColor: Colors.black,
          cropFrameColor: Colors.orange.shade900,
          cropGridColor: Colors.orange.shade900,
          dimmedLayerColor: Colors.black,
        ),
      ],
    );

    if (croppedFile != null) {
      imageFile = File(croppedFile.path);
      setState(() {});
    }
  }

  void saveImage() async {
    var permission = await Permission.storage.request();

    var directoryPath = "/storage/emulated/0/Pictures/MyPhotoEditor";
    var fileName = "${DateTime.now().microsecondsSinceEpoch}.png";
    var finalSavePath = '$directoryPath/$fileName';

    if (permission.isGranted) {
      final directory = Directory(directoryPath);

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      if (widget.isEditing) {
        //IF THE FILE EXISTS, IT WILL DELETE THE OLD ANDE SAVE THE NEW
        deleteImage();
        //SAVE THE NEW
        await screenshotController
            .captureAndSave(
          directory.path,
          delay: const Duration(milliseconds: 100),
          fileName: fileName,
          pixelRatio: 4.0,
        )
            .then((value) {
          setState(() {
            temporaryPath = finalSavePath;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Salvo em ${directory.path}'),
            ),
          );

          widget.callback(temporaryPath, true);
          Navigator.of(context).pop();
        });
      } else {
        //IF THE FILE IS NEW, IT WILL ONLY CREATE
        await screenshotController
            .captureAndSave(
          directory.path,
          delay: const Duration(milliseconds: 100),
          fileName: fileName,
          pixelRatio: 4.0,
        )
            .then((value) {
          setState(() {
            temporaryPath = finalSavePath;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Salvo em $finalSavePath'),
            ),
          );

          widget.callback(temporaryPath, true);
          Navigator.of(context).pop();
        });
      }
    }
  }

  Future<void> deleteImage() async {
    if (widget.imagePath.isEmpty) return;

    final status = await Permission.storage.request();
    if (status.isGranted) {
      final result = await deleteImageFromGallery(widget.imagePath);
      if (result) {
        print('STTATSU- Deleted');
      } else {
        // Handle error
        print('STTATSU- Error deleting image');
      }
    } else {
      // Handle permission denied
      print('STTATSU- Storage permission denied');
    }
  }

  Future<bool> deleteImageFromGallery(String filePath) async {
    try {
      await File(filePath).delete();
      return true;
    } catch (e) {
      print('STTATSU- Error deleting file: $e');
      return false;
    }
  }
}
