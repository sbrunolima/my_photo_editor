import 'package:flutter/material.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:google_fonts/google_fonts.dart';

//Screens
import '../screens/crop_image_page.dart';
import '../screens/edit_filter_page.dart';
import '../screens/contrast_page.dart';
import '../screens/saturation_page.dart';
import '../screens/brightness_page.dart';
import '../screens/hue_page.dart';

//Widgets
import '../widgets/custom_page_route.dart';

class PhotoViewPageButtons extends StatelessWidget {
  final int pageRoute;
  final String buttonName;
  final String imagePath;
  final String imageName;
  final bool isEditing;
  final Function(String, bool) callback;

  PhotoViewPageButtons({
    required this.pageRoute,
    required this.buttonName,
    required this.imagePath,
    required this.imageName,
    required this.isEditing,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: GestureDetector(
        onTap: () {
          routes(pageRoute: pageRoute, context: context);
        },
        child: Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            color: Colors.white30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconAccordingOption(),
              Text(
                buttonName,
                style: GoogleFonts.openSans(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void routes({required int pageRoute, required BuildContext context}) {
    if (pageRoute == 0) {
      Navigator.of(context).push(
        CustomPageRoute(
          child: CropImagePage(
            imagePath: imagePath,
            imageName: imageName,
            isEditing: isEditing,
            callback: (newImagePath, newEditValue) {
              callback(newImagePath.toString(), newEditValue);
            },
          ),
        ),
      );
    }
    if (pageRoute == 1) {
      Navigator.of(context).push(
        CustomPageRoute(
          child: EditFilterPage(
            imagePath: imagePath,
            imageName: imageName,
            isEditing: isEditing,
            callback: (newImagePath, newEditValue) {
              callback(newImagePath.toString(), newEditValue);
            },
          ),
        ),
      );
    }
    if (pageRoute == 2) {
      Navigator.of(context).push(
        CustomPageRoute(
          child: ContrastPage(
            imagePath: imagePath,
            imageName: imageName,
            isEditing: isEditing,
            callback: (newImagePath, newEditValue) {
              callback(newImagePath.toString(), newEditValue);
            },
          ),
        ),
      );
    }
    if (pageRoute == 3) {
      Navigator.of(context).push(
        CustomPageRoute(
          child: SaturationPage(
            imagePath: imagePath,
            imageName: imageName,
            isEditing: isEditing,
            callback: (newImagePath, newEditValue) {
              callback(newImagePath.toString(), newEditValue);
            },
          ),
        ),
      );
    }
    if (pageRoute == 4) {
      Navigator.of(context).push(
        CustomPageRoute(
          child: BrightnessPage(
            imagePath: imagePath,
            imageName: imageName,
            isEditing: isEditing,
            callback: (newImagePath, newEditValue) {
              callback(newImagePath.toString(), newEditValue);
            },
          ),
        ),
      );
    }
    if (pageRoute == 5) {
      Navigator.of(context).push(
        CustomPageRoute(
          child: HuePage(
            imagePath: imagePath,
            imageName: imageName,
            isEditing: isEditing,
            callback: (newImagePath, newEditValue) {
              callback(newImagePath.toString(), newEditValue);
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
              : pageRoute == 2
                  ? EneftyIcons.mask_2_bold
                  : pageRoute == 3
                      ? EneftyIcons.drop_bold
                      : pageRoute == 4
                          ? EneftyIcons.sun_bold
                          : pageRoute == 5
                              ? EneftyIcons.mirror_bold
                              : Icons.edit,
      color: Colors.white,
    );
  }
}
