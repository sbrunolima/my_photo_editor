import 'dart:typed_data';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:image/image.dart' as img;

class ImageProcessing {
  int height = 0;
  int width = 0;
  Future<Uint8List> removeWhiteBackground(Uint8List bytes) async {
    img.Image image = img.decodeImage(bytes)!;
    var pixels = image.getBytes();
    height = image.height;
    width = image.width;
    if (image.width > image.height) {
      return pixels;
    }
    if (pixels[3] == 0) {
      return pixels;
    }
    int red = pixels[0], green = pixels[1], blue = pixels[2];
    if (red != 255 && green != 255 && blue != 255) {
      return pixels;
    }
    for (int i = 0, len = pixels.length; i < len; i += 4) {
      if (pixels[i] == red && pixels[i + 1] == green && pixels[i + 2] == blue) {
        pixels[i + 3] = 0;
      }
    }
    return pixels;
  }
}
