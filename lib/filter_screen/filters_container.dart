import 'dart:io';
import 'package:flutter/material.dart';

//Utils
import '../utils/filters.dart';

class FilterContainer extends StatelessWidget {
  final String imagePath;
  final List<double> filter;
  final Function(List<double>) selectedFilter;

  FilterContainer(
      {required this.imagePath,
      required this.filter,
      required this.selectedFilter});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        selectedFilter(filter);
      },
      child: Container(
        constraints: const BoxConstraints(
          maxHeight: 70,
          maxWidth: 70,
        ),
        child: ColorFiltered(
          colorFilter: ColorFilter.matrix(filter),
          child: Image.file(
            File(imagePath),
            width: 70,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
