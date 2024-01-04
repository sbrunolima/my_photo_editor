import 'dart:io';

import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:file_manager/file_manager.dart';

//Screens
import '../screens/photo_view_page.dart';

//Widgets
import '../filter_screen/filters_container.dart';
import '../widgets/my_back_icon.dart';

//Utils
import '../utils/filters.dart';

class EditFilterPage extends StatefulWidget {
  static const routeName = '/edit-filte-screen';

  final String imagePath;
  final String imageName;
  final bool isEditing;
  final Function(String, bool) callback;

  EditFilterPage({
    required this.imagePath,
    required this.imageName,
    required this.isEditing,
    required this.callback,
  });

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
        backgroundColor: Colors.black,
        leading: MyBackIcon(),
        title: Text(
          'Filtros',
          style: GoogleFonts.openSans(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Screenshot(
        controller: screenshotController,
        child: ColorFiltered(
          colorFilter: ColorFilter.matrix(selectedFilter),
          child: Image.file(
            imageFile!,
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
            //FILTERS WIDGET
            SizedBox(
              height: 60,
              child: ListView.builder(
                itemCount: filters.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
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
            const SizedBox(height: 20.0),
            //SAVE BUTTOM
            Padding(
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
          ],
        ),
      ),
    );
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
