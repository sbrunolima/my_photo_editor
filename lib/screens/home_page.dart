import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:google_fonts/google_fonts.dart';

//Screens
import '../screens/photo_view_page.dart';

//Widget
import '../widgets/custom_page_route.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<AssetEntity>> _getImagesFromStorage() async {
    try {
      var permission = await Permission.storage.request();

      if (permission.isGranted) {
        // Retrieve all images
        final List<AssetPathEntity> images =
            await PhotoManager.getAssetPathList(
          onlyAll: false,
          type: RequestType.image,
        );

        // Provide a list of folder names you want to include
        List<String> folderNames = ["Camera", "Screenshots", "MyPhotoEditor"];

        // Filter paths based on the specified folder names
        List<AssetPathEntity> selectedPaths = images
            .where((path) =>
                folderNames.any((folder) => path.name.contains(folder)))
            .toList();

        // Combine assets from all selected paths
        List<AssetEntity> filteredImages = [];
        for (var path in selectedPaths) {
          var assets = await path.getAssetListRange(
            start: 0,
            end: path.assetCount,
          );
          filteredImages.addAll(assets);
        }

        return filteredImages;
      }
    } catch (e) {
      print('Error getting images: $e');
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Photo Editor',
          style: GoogleFonts.openSans(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [],
      ),
      body: FutureBuilder(
        future: _getImagesFromStorage(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<AssetEntity> images = snapshot.data as List<AssetEntity>;
            return _buildImageGrid(images);
          }
        },
      ),
    );
  }

  Widget _buildImageGrid(List<AssetEntity> images) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2.0,
        mainAxisSpacing: 2.0,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return FutureBuilder(
          future: Future.wait([
            images[index].thumbnailData,
            images[index].originFile,
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              Uint8List thumbData = snapshot.data![0] as Uint8List;
              File originFile = snapshot.data![1] as File;
              String imageName = images[index].title.toString();

              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    CustomPageRoute(
                      child: PhotoViewPage(
                        imagePath: '${originFile.parent.path}/$imageName',
                        imageName: imageName,
                      ),
                    ),
                  );
                },
                child: Image.memory(thumbData, fit: BoxFit.cover),
              );
            }
          },
        );
      },
    );
  }
}
