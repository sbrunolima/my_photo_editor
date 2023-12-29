import 'dart:io';
import 'package:flutter/material.dart';
import 'package:enefty_icons/enefty_icons.dart';

//Screens
import '../screens/crop_image.dart';

class PhotoViewPage extends StatefulWidget {
  final String imagePath;

  PhotoViewPage({required this.imagePath});

  @override
  State<PhotoViewPage> createState() => _PhotoViewPageState();
}

class _PhotoViewPageState extends State<PhotoViewPage> {
  String editedPath = '';

  @override
  void initState() {
    super.initState();
    editedPath = widget.imagePath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Image.file(File(editedPath)),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(color: Colors.black),
          Container(
            height: 70,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CropImagePage(
                            imagePath: widget.imagePath,
                            callback: (value) {
                              setState(() {
                                editedPath = value.toString();
                              });
                            },
                          ),
                        ),
                      );
                    },
                    child: Icon(EneftyIcons.crop_outline),
                  ),
                  Icon(Icons.edit),
                  Icon(Icons.edit),
                  Icon(Icons.edit),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
