import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

class CropImagePage extends StatefulWidget {
  final String imagePath;
  final Function(String) callback;

  CropImagePage({required this.imagePath, required this.callback});

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
              icon: const Icon(Icons.save)),
          const SizedBox(width: 15.0),
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
              color: Colors.purple,
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
    File? croppedImage = await ImageCropper().cropImage(
      sourcePath: widget.imagePath,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9,
      ],
      androidUiSettings: const AndroidUiSettings(
        toolbarTitle: 'Recortar',
        toolbarColor: Colors.black,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
      ),
    );

    if (croppedImage != null) {
      imageFile = croppedImage;
      setState(() {});
    }
  }

  void saveImage() async {
    var permission = await Permission.storage.request();

    var directoryPath = "/storage/emulated/0/Pictures/MyPhotoEditor";
    var fileName = "${DateTime.now().microsecondsSinceEpoch}.png";

    if (permission.isGranted) {
      final directory = Directory(directoryPath);

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      await screenshotController
          .captureAndSave(
        directory.path,
        delay: const Duration(milliseconds: 100),
        fileName: fileName,
        pixelRatio: 4.0,
      )
          .then((value) {
        setState(() {
          temporaryPath = '$directoryPath/$fileName';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Salvo em ${directory.path}'),
          ),
        );

        widget.callback(temporaryPath);
        Navigator.of(context).pop();
      });
    }
  }
}
