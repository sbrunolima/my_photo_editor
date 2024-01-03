import 'dart:io';
import 'package:flutter/material.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:google_fonts/google_fonts.dart';

//Screens
import '../screens/crop_image.dart';
import '../filter_screen/edit_filter_page.dart';

class PhotoViewPageButtons extends StatelessWidget {
  final int pageRoute;
  final String buttonName;
  final String imagePath;
  final String imageName;
  final Function(String) callback;

  PhotoViewPageButtons({
    required this.pageRoute,
    required this.buttonName,
    required this.imagePath,
    required this.imageName,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        routes(pageRoute: pageRoute, context: context);
      },
      child: Column(
        children: [
          iconAccordingOption(),
          Text(
            buttonName,
            style: GoogleFonts.openSans(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void routes({required int pageRoute, required BuildContext context}) {
    if (pageRoute == 0) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CropImagePage(
            imagePath: imagePath,
            imageName: imageName,
            callback: (value) {
              callback(value.toString());
            },
          ),
        ),
      );
    }
    if (pageRoute == 1) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => EditFilterPage(
            imagePath: imagePath,
            imageName: imageName,
            callback: (value) {
              callback(value.toString());
            },
          ),
        ),
      );
    }
  }

  Widget iconAccordingOption() {
    return Icon(
      pageRoute == 0
          ? EneftyIcons.crop_outline
          : pageRoute == 1
              ? EneftyIcons.colorfilter_outline
              : Icons.edit,
      color: Colors.white,
    );
  }
}
