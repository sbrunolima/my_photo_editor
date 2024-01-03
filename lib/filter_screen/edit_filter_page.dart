import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:file_manager/file_manager.dart';

//Screens
import '../screens/photo_view_page.dart';

//Widgets
import '../filter_screen/filters_container.dart';

//Utils
import '../utils/filters.dart';

class EditFilterPage extends StatefulWidget {
  static const routeName = '/edit-filte-screen';

  final String imagePath;
  final String imageName;
  final Function(String) callback;

  EditFilterPage(
      {required this.imagePath,
      required this.imageName,
      required this.callback});

  @override
  State<EditFilterPage> createState() => _EditFilterPageState();
}

class _EditFilterPageState extends State<EditFilterPage> {
  ScreenshotController screenshotController = ScreenshotController();
  File? imageFile;
  String temporaryPath = '';

  final List<List<double>> filters = [
    NOFILTER,
    PURPLE,
    SEPIUM,
    OLDTIMES,
    BLACKWHITE,
  ];

  var selectedFilter;

  @override
  void initState() {
    super.initState();
    selectedFilter = filters[0];
    imageFile = File(widget.imagePath);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        // leading: IconButton(
        //   onPressed: () {
        //     Navigator.of(context).pop();

        //     if (temporaryPath.isNotEmpty) {
        //       widget.callback(temporaryPath);
        //     }
        //   },
        //   icon: const Icon(
        //     Icons.arrow_back,
        //     color: Colors.red,
        //   ),
        // ),
        title: Text('Photo Editor'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              saveImage();
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Screenshot(
              controller: screenshotController,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: size.height - 300,
                  maxWidth: size.width,
                ),
                child: ColorFiltered(
                  colorFilter: ColorFilter.matrix(selectedFilter),
                  child: Image.file(
                    imageFile!,
                    width: size.width,
                    //fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(color: Colors.white),
          Container(
            height: 70,
            color: Colors.black,
            child: ListView.builder(
              itemCount: filters.length,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: FilterContainer(
                    imagePath: widget.imagePath,
                    filter: filters[index],
                    selectedFilter: (filter) {
                      setState(
                        () {
                          selectedFilter = filter;
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
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
          setState(() {
            temporaryPath = finalSavePath;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Salvo em ${directory.path}'),
            ),
          );

          widget.callback(temporaryPath);
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
