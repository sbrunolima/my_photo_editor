import 'dart:io';
import 'package:flutter/material.dart';

//Widgets
import '../photo_view_page/photo_view_page_buttons.dart';
import '../widgets/my_back_icon.dart';

class PhotoViewPage extends StatefulWidget {
  final String imagePath;
  final String imageName;

  PhotoViewPage({required this.imagePath, required this.imageName});

  @override
  State<PhotoViewPage> createState() => _PhotoViewPageState();
}

class _PhotoViewPageState extends State<PhotoViewPage> {
  String editedPath = '';
  bool isInit = true;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    if (isInit) {
      editedPath = widget.imagePath;
    }

    isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: MyBackIcon(),
      ),
      body: Center(
        child: Image.file(File(editedPath)),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(color: Colors.black),
          SizedBox(
            height: 70,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              children: [
                PhotoViewPageButtons(
                  pageRoute: 0,
                  buttonName: 'Recortar',
                  imagePath: editedPath,
                  imageName: widget.imageName,
                  isEditing: isEditing,
                  callback: (newImagePath, newEditValue) {
                    setState(() {
                      editedPath = newImagePath;
                      isEditing = newEditValue;
                    });
                  },
                ),
                PhotoViewPageButtons(
                  pageRoute: 1,
                  buttonName: 'Filtros',
                  imagePath: editedPath,
                  imageName: widget.imageName,
                  isEditing: isEditing,
                  callback: (newImagePath, newEditValue) {
                    setState(() {
                      editedPath = newImagePath;
                      isEditing = newEditValue;
                    });
                  },
                ),
                PhotoViewPageButtons(
                  pageRoute: 2,
                  buttonName: 'Contraste',
                  imagePath: editedPath,
                  imageName: widget.imageName,
                  isEditing: isEditing,
                  callback: (newImagePath, newEditValue) {
                    setState(() {
                      editedPath = newImagePath;
                      isEditing = newEditValue;
                    });
                  },
                ),
                PhotoViewPageButtons(
                  pageRoute: 3,
                  buttonName: 'Saturação',
                  imagePath: editedPath,
                  imageName: widget.imageName,
                  isEditing: isEditing,
                  callback: (newImagePath, newEditValue) {
                    setState(() {
                      editedPath = newImagePath;
                      isEditing = newEditValue;
                    });
                  },
                ),
                PhotoViewPageButtons(
                  pageRoute: 4,
                  buttonName: 'Brilho',
                  imagePath: editedPath,
                  imageName: widget.imageName,
                  isEditing: isEditing,
                  callback: (newImagePath, newEditValue) {
                    setState(() {
                      editedPath = newImagePath;
                      isEditing = newEditValue;
                    });
                  },
                ),
                PhotoViewPageButtons(
                  pageRoute: 5,
                  buttonName: 'Hue',
                  imagePath: editedPath,
                  imageName: widget.imageName,
                  isEditing: isEditing,
                  callback: (newImagePath, newEditValue) {
                    setState(() {
                      editedPath = newImagePath;
                      isEditing = newEditValue;
                    });
                  },
                ),
                Icon(Icons.edit),
                Icon(Icons.edit),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
