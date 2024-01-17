import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

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
      print('STATUS- Deleted');
    } else {
      // Handle error
      print('STATUS- Error deleting image');
    }
  } else {
    // Handle permission denied
    print('STATUS- Storage permission denied');
  }
}

Future<bool> deleteImageFromGallery(String filePath) async {
  try {
    await File(filePath).delete();
    return true;
  } catch (e) {
    print('STATUS- Error deleting file: $e');
    return false;
  }
}
