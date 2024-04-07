import 'package:app/features/screen/pages/show_plant_all_details/show_plant_all_common_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowPlantAllDetails extends StatelessWidget {
  final String plantTitle;
  final String firstImg;
  final String secondImg;
  final String thirdImg;
  final String mainDesc;
  final String howToDesc;
  final String fertiDesc;

  const ShowPlantAllDetails(
      {super.key,
      required this.plantTitle,
      required this.firstImg,
      required this.secondImg,
      required this.thirdImg,
      required this.mainDesc,
      required this.howToDesc,
      required this.fertiDesc});

  @override
  Widget build(BuildContext context) {
    return CommonDetailsPage(
        firstImg: firstImg,
        secondImg: secondImg,
        thirdImg: thirdImg,
        plantTitle: plantTitle,
        mainDesc: mainDesc,
        howDesc: howToDesc,
        fetDesc: fertiDesc);
  }
}
