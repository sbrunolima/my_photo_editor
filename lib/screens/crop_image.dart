import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

class CropImagePage extends StatefulWidget {
  final String imagePath;
  final String imageName;
  final Function(String) callback;

  CropImagePage(
      {required this.imagePath,
      required this.imageName,
      required this.callback});

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Imagem'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              saveImage();
            },
            icon: const Icon(
              Icons.save,
              color: Colors.orange,
            ),
          ),
          const SizedBox(width: 4.0),
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0),
        child: GestureDetector(
          onTap: cropImage,
          child: Container(
            height: 60,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.transparent),
              borderRadius: BorderRadius.circular(0.0),
              color: Colors.orange.shade900,
            ),
            child: const Center(
              child: Text(
                'Editar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
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
    var fileName = "${widget.imageName}-edited-copy.png";
    var finalSavePath = '$directoryPath/$fileName';

    if (permission.isGranted) {
      final directory = Directory(directoryPath);

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      if (widget.imagePath.toLowerCase() == finalSavePath.toLowerCase()) {
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Salvo em $value'),
            ),
          );

          widget.callback(value.toString());
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

          widget.callback(temporaryPath);
          Navigator.of(context).pop();
        });
      }
    }
  }

  Future<void> deleteImage() async {
    if (widget.imagePath == null) return;

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
