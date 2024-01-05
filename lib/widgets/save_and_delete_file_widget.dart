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

void saveImage({
  required String imagePath,
  required bool isEditing,
  required ScreenshotController screenshotController,
  required BuildContext context,
  required Function(String, bool) callback,
}) async {
  var permission = await Permission.storage.request();

  var directoryPath = "/storage/emulated/0/Pictures/MyPhotoEditor";
  var fileName = "${DateTime.now().microsecondsSinceEpoch}.png";
  var finalSavePath = '$directoryPath/$fileName';

  if (permission.isGranted) {
    final directory = Directory(directoryPath);

    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    if (isEditing) {
      //IF THE FILE EXISTS, IT WILL DELETE THE OLD ANDE SAVE THE NEW
      deleteImage(imagePath: imagePath);
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
            content: Text('Salvo em ${directory.path}'),
          ),
        );

        callback(finalSavePath, true);
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Salvo em $finalSavePath'),
          ),
        );

        callback(finalSavePath, true);
        Navigator.of(context).pop();
      });
    }
  }
}

Future<void> deleteImage({required String imagePath}) async {
  if (imagePath.isEmpty) return;

  final status = await Permission.storage.request();
  if (status.isGranted) {
    final result = await deleteImageFromGallery(imagePath);
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
