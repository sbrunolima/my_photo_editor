import 'dart:io';
import 'package:flutter/material.dart';

class FilterContainer extends StatelessWidget {
  final String imagePath;
  final List<double> filter;
  final Function(List<double>) selectedFilter;

  FilterContainer({
    required this.imagePath,
    required this.filter,
    required this.selectedFilter,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        selectedFilter(filter);
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            border: Border.all(color: Colors.grey)),
        child: ColorFiltered(
          colorFilter: ColorFilter.matrix(filter),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6.0),
            child: Image.file(
              File(imagePath),
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
