import 'dart:io';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screenshot/screenshot.dart';

//Widgets
import '../filter_screen/filters_container.dart';
import '../widgets/my_back_icon.dart';
import '../widgets/save_and_delete_file_widget.dart';

//Utils
import '../utils/filters.dart';

class EditFilterPage extends StatefulWidget {
  static const routeName = '/edit-filte-screen';

  final String imagePath;
  final String imageName;
  final bool isEditing;
  final Function(String, bool) callback;

  EditFilterPage({
    required this.imagePath,
    required this.imageName,
    required this.isEditing,
    required this.callback,
  });

  @override
  State<EditFilterPage> createState() => _EditFilterPageState();
}

class _EditFilterPageState extends State<EditFilterPage> {
  ScreenshotController screenshotController = ScreenshotController();
  File? imageFile;
  bool isLoading = false;

  final List<List<double>> filters = [
    NOFILTER,
    PURPLE,
    SEPIUM,
    OLDTIMES,
    BLACKWHITE,
  ];

  var selectedFilter;

  @override
  void initState() {
    super.initState();
    selectedFilter = filters[0];
    imageFile = File(widget.imagePath);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: MyBackIcon(),
        title: Text(
          'Filtros',
          style: GoogleFonts.openSans(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Screenshot(
        controller: screenshotController,
        child: ColorFiltered(
          colorFilter: ColorFilter.matrix(selectedFilter),
          child: Image.file(
            imageFile!,
            width: size.width,
            height: size.height,
            fit: BoxFit.contain,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 145,
        color: Colors.black,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //FILTERS WIDGET
            SizedBox(
              height: 60,
              child: ListView.builder(
                itemCount: filters.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: FilterContainer(
                      imagePath: widget.imagePath,
                      filter: filters[index],
                      selectedFilter: (filter) {
                        setState(
                          () {
                            selectedFilter = filter;
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20.0),
            //SAVE BUTTOM
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isLoading = true;
                  });

                  saveImage(
                    imagePath: widget.imagePath,
                    isEditing: widget.isEditing,
                    screenshotController: screenshotController,
                    context: context,
                    callback: (newImagePath, newEditValue) {
                      widget.callback(newImagePath, newEditValue);
                    },
                  );
                },
                child: Container(
                  height: 55,
                  width: size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    color: Colors.white30,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!isLoading)
                        const Icon(
                          EneftyIcons.brush_2_bold,
                          color: Colors.white,
                          size: 20,
                        ),
                      const SizedBox(width: 4.0),
                      isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'Salvar',
                              style: GoogleFonts.openSans(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
