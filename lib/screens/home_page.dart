import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

//Widgets
import '../filter_screen/filters_container.dart';

//Utils
import '../utils/filters.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<List<double>> filters = [
    NOFILTER,
    PURPLE,
    SEPIUM,
    OLDTIMES,
    BLACKWHITE,
  ];

  var selectedFilter;
  String imagePath = '';
  @override
  void initState() {
    super.initState();
    selectedFilter = filters[0];
  }

  void pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );

    if (pickedImage != null) {
      imagePath = pickedImage.path;

      setState(() {});
    } else {
      //Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text('Photo Editor'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: pickImage,
              icon: Icon(Icons.add),
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                constraints: BoxConstraints(
                  maxHeight: size.height - 300,
                  maxWidth: size.width,
                ),
                child: ColorFiltered(
                  colorFilter: ColorFilter.matrix(selectedFilter),
                  child: Image.file(
                    File(imagePath),
                    width: size.width,
                    //fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
            ],
          ),
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(color: Colors.white),
            Container(
              height: 70,
              color: Colors.black,
              child: ListView.builder(
                  itemCount: filters.length,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: FilterContainer(
                          imagePath: imagePath,
                          filter: filters[index],
                          selectedFilter: (filter) {
                            setState(() {
                              selectedFilter = filter;
                            });
                          }),
                    );
                  }),
            ),
          ],
        ));
  }
}
