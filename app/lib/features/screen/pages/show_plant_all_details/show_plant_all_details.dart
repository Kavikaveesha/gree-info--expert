import 'package:app/features/screen/pages/show_plant_all_details/show_plant_all_common_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowPlantAllDetails extends StatelessWidget {
  final String plantTitle;
  final String mainDesc;
  final String howToDesc;
  final String fertiDesc;
  final List<dynamic> images;
  final String? collectionName;

  const ShowPlantAllDetails(
      {super.key,
      required this.plantTitle,
      required this.mainDesc,
      required this.howToDesc,
      required this.fertiDesc,
      required this.images,
      this.collectionName});

  @override
  Widget build(BuildContext context) {
    return CommonDetailsPage(
      collectionName: collectionName,
      plantTitle: plantTitle,
      mainDesc: mainDesc,
      howDesc: howToDesc,
      fetDesc: fertiDesc,
      images: images,
    );
  }
}
