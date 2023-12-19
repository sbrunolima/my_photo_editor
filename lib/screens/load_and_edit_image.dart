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

//Widgets
import '../edit_image/background_colors.dart';

class LoadAndEditImage extends StatefulWidget {
  @override
  State<LoadAndEditImage> createState() => _LoadAndEditImageState();
}

class _LoadAndEditImageState extends State<LoadAndEditImage> {
  bool loaded = false;
  bool editMode = false;
  bool removedBackground = false;
  bool isLoading = false;
  bool saveLoading = false;
  Uint8List? image;
  String imagePath = '';

  ScreenshotController screenshotController = ScreenshotController();
  var backgroungColor = Colors.transparent;

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
      setState(() {
        saveLoading = true;
      });

      final directory = Directory(directoryPath);

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      await screenshotController
          .captureAndSave(
        directory.path,
        delay: const Duration(milliseconds: 100),
        fileName: fileName,
        pixelRatio: 10.0,
      )
          .then((value) {
        setState(() {
          saveLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Salvo em ${directory.path}'),
          ),
        );

        Navigator.of(context).pop();
      });
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
              onPressed: !editMode
                  ? () {
                      saveImage();
                    }
                  : null,
              icon: Icon(Icons.save),
            ),
            const SizedBox(width: 10.0),
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  removedBackground
                      ? Center(
                          child: Screenshot(
                            controller: screenshotController,
                            child: Container(
                              color: backgroungColor,
                              child: Image.memory(
                                image!,
                                height: editMode ? 400 : mediaQuary.height,
                                filterQuality: FilterQuality.high,
                              ),
                            ),
                          ),
                        )
                      : loaded
                          ? GestureDetector(
                              onTap: pickImage,
                              child: Image.file(
                                File(imagePath),
                                height: mediaQuary.height,
                                width: mediaQuary.width,
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
                  if (editMode)
                    GridView.builder(
                      itemCount: 10,
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: BackgroundColors(
                            colorSelected: index,
                            callback: (value) {
                              setState(() {
                                backgroungColor = value;
                              });
                            },
                          ),
                        );
                      },
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        crossAxisSpacing: 1.0,
                        mainAxisSpacing: 1.0,
                      ),
                    )
                ],
              ),
            ),
            if (saveLoading)
              Container(
                color: Colors.black54,
                child: const Center(
                    child: CircularProgressIndicator(color: Colors.orange)),
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
                child: Icon(!editMode ? Icons.edit : Icons.save),
              )
            : const SizedBox.shrink(),
        bottomNavigationBar: SizedBox(
          height: 60,
          child: removedBackground
              ? ElevatedButton(
                  onPressed: saveLoading
                      ? null
                      : () {
                          Navigator.of(context).pop();
                        },
                  child: Text('Cancelar'),
                )
              : ElevatedButton(
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
                  child: isLoading
                      ? CircularProgressIndicator()
                      : Text('Remover Fundo'),
                ),
        ));
  }
}
