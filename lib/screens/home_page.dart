import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:before_after/before_after.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

//API
import '../api/remove_background_api.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loaded = false;
  bool removedBackground = false;
  bool isLoading = false;
  Uint8List? image;
  String imagePath = '';

  ScreenshotController screenshotController = ScreenshotController();

  var value = 0.5;

  void pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );

    if (pickedImage != null) {
      imagePath = pickedImage.path;
      loaded = true;

      setState(() {});
    } else {
      //Handle error
    }
  }

  void saveImage() async {
    var permission = await Permission.storage.request();

    var directoryPath = "/storage/emulated/0/Download/";
    var fileName = "${DateTime.now().microsecondsSinceEpoch}.png";

    if (permission.isGranted) {
      final directory = Directory(directoryPath);

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      await screenshotController.captureAndSave(
        directory.path,
        delay: Duration(milliseconds: 100),
        fileName: fileName,
        pixelRatio: 1.0,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Salvo em ${directory.path}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //Get the device size
    final mediaQuary = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: Text('Remover Fundo'),
          actions: [
            IconButton(
              onPressed: () {
                saveImage();
              },
              icon: Icon(Icons.save),
            ),
            const SizedBox(width: 10.0),
          ],
        ),
        body: Column(
          children: [
            removedBackground
                ? SizedBox(
                    height: mediaQuary.height - 150,
                    width: mediaQuary.width,
                    child: Screenshot(
                      controller: screenshotController,
                      child: Image.memory(image!),
                    ),
                  )
                : loaded
                    ? GestureDetector(
                        onTap: pickImage,
                        child: Container(
                          height: mediaQuary.height - 150,
                          width: mediaQuary.width,
                          child: Image.file(File(imagePath)),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          pickImage();
                        },
                        child: Text('Carregar Imagem'),
                      ),
          ],
        ),
        bottomNavigationBar: SizedBox(
          height: 60,
          child: ElevatedButton(
            onPressed: loaded
                ? () async {
                    setState(() {
                      isLoading = true;
                    });

                    image = await RemoveBgApi.removeBackground(
                      imagePath: imagePath,
                    );

                    if (image != null) {
                      removedBackground = true;
                      isLoading = false;
                      setState(() {});
                    }
                  }
                : null,
            child:
                isLoading ? CircularProgressIndicator() : Text('Remover Fundo'),
          ),
        ));
  }
}
