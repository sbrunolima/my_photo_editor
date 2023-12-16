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

class LoadAndEditImage extends StatefulWidget {
  @override
  State<LoadAndEditImage> createState() => _LoadAndEditImageState();
}

class _LoadAndEditImageState extends State<LoadAndEditImage> {
  bool loaded = false;
  bool editMode = false;
  bool removedBackground = false;
  bool isLoading = false;
  Uint8List? image;
  String imagePath = '';

  ScreenshotController screenshotController = ScreenshotController();
  var backgroungColor = Colors.transparent;
  List newBackgroundColors = [
    Colors.transparent,
    Colors.white,
    Colors.red,
    Colors.green,
    Colors.orange,
  ];

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
        pixelRatio: 10.0,
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
                ? Center(
                    child: Container(
                      height: editMode ? 400 : mediaQuary.height - 150,
                      child: Screenshot(
                        controller: screenshotController,
                        child: Container(
                          color: backgroungColor,
                          child: Image.memory(
                            image!,
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                      ),
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
                    : Center(
                        child: ElevatedButton(
                          onPressed: () {
                            pickImage();
                          },
                          child: Text('Carregar Imagem'),
                        ),
                      ),
            if (editMode) const SizedBox(height: 10.0),
            if (editMode)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          backgroungColor = newBackgroundColors[1];
                        });
                      },
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          color: Colors.white,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          backgroungColor = newBackgroundColors[2];
                        });
                      },
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        floatingActionButton: removedBackground
            ? FloatingActionButton(
                onPressed: () {
                  setState(() {
                    editMode = !editMode;
                  });
                },
                backgroundColor: Colors.orange,
                elevation: 0,
                child: const Icon((Icons.edit)),
              )
            : const SizedBox.shrink(),
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
