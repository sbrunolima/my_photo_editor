import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

//Widgets
import '../widgets/slider_shape.dart';

class ImageContrastWidget extends StatefulWidget {
  final String imagePath;

  ImageContrastWidget({required this.imagePath});

  @override
  _ImageContrastWidgetState createState() => _ImageContrastWidgetState();
}

class _ImageContrastWidgetState extends State<ImageContrastWidget> {
  img.Image? _adjustedImage;
  double changedValue = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Contrast Adjustment'),
      ),
      body: Center(
        child: _adjustedImage != null
            ? Image.memory(Uint8List.fromList(img.encodePng(_adjustedImage!)))
            : CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          loadAndAdjustImage(contrastSize: 0);
        },
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }

  Future<void> loadAndAdjustImage({required double contrastSize}) async {
    try {
      final imagePicker = ImagePicker();
      final XFile? pickedFile =
          await imagePicker.pickImage(source: ImageSource.gallery);

      if (pickedFile == null) {
        // No image picked
        return;
      }

      ByteData data = await pickedFile
          .readAsBytes()
          .then((bytes) => ByteData.sublistView(Uint8List.fromList(bytes)));
      img.Image image =
          img.decodeImage(Uint8List.fromList(data.buffer.asUint8List()))!;

      // Adjust contrast using the provided contrast function
      _adjustedImage = contrast(image,
          contrast: contrastSize); // You can adjust the contrast value

      setState(() {
        // Trigger a rebuild to update the UI with the adjusted image
      });
    } catch (e) {
      // Handle any errors that occurred during image loading
      print('Error loading or adjusting image: $e');
    }
  }

  img.Image contrast(img.Image src, {required num contrast}) {
    if (contrast == 100.0) {
      return src;
    }

    num _lastContrast = 0;
    Uint8List _contrast = Uint8List(256);

    if (contrast != _lastContrast) {
      _lastContrast = contrast;

      contrast = contrast / 100.0;
      contrast = contrast * contrast;
      for (var i = 0; i < 256; ++i) {
        _contrast[i] = (((((i / 255.0) - 0.5) * contrast) + 0.5) * 255.0)
            .clamp(0, 255)
            .toInt();
      }
    }

    for (final frame in src.frames) {
      for (final p in frame) {
        p
          ..r = _contrast[p.r as int]
          ..g = _contrast[p.g as int]
          ..b = _contrast[p.b as int];
      }
    }

    return src;
  }
}
