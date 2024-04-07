import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/mediaQuery.dart';

class CommonDetailsPage extends StatelessWidget {
  final String firstImg;
  final String? secondImg;
  final String? thirdImg;
  final String plantTitle;
  final String mainDesc;
  final String? howDesc;
  final String? fetDesc;

  const CommonDetailsPage(
      {super.key,
      required this.firstImg,
      this.secondImg,
      this.thirdImg,
      required this.plantTitle,
      required this.mainDesc,
      this.howDesc,
      this.fetDesc});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQueryUtils.getWidth(context);
    final double screenHeight = MediaQueryUtils.getHeight(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          plantTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: SizedBox(
                width: double.infinity,
                height: screenHeight * .3,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: [
                    // Render images
                    for (var img in [firstImg, secondImg, thirdImg])
                      if (img != null) ...[
                        SizedBox(width: screenWidth * 0.02),
                        Container(
                          margin: EdgeInsets.all(10),
                          width: screenWidth * 0.5,
                          height: screenHeight * 0.3,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.05),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: screenWidth * 0.01,
                                blurRadius: screenWidth * 0.025,
                                offset: const Offset(0, .1),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.05),
                            child: Image.network(
                              img!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mainDesc,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'How to Grow',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  Text(
                    howDesc!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'Fertilizers',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  Text(
                    fetDesc!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
