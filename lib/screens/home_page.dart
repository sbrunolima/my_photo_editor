import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:before_after/before_after.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

//Screens
import '../screens/load_and_edit_image.dart';

//API
import '../api/remove_background_api.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    //Get the device size
    final mediaQuary = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Remover Fundo'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => LoadAndEditImage(),
                  ),
                );
              },
              child: Text('Carregar Imagem'),
            ),
          ],
        ),
      ),
    );
  }
}
