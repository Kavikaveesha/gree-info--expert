import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/mediaQuery.dart';

class CommonDetailsPage extends StatelessWidget {
  final List<dynamic> images;
  final String plantTitle;
  final String mainDesc;
  final String? howDesc;
  final String? fetDesc;
  final String? collectionName;

  const CommonDetailsPage(
      {super.key,
      required this.plantTitle,
      required this.mainDesc,
      this.howDesc,
      this.fetDesc,
      required this.images,
      this.collectionName});

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
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: images
                        .length, // Assuming dataList is the list containing image URLs
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.only(
                            left: index == 0 ? 0 : screenWidth * 0.02),
                        child: Container(
                          margin: EdgeInsets.all(10),
                          width: screenWidth * 0.5,
                          height: screenHeight * 0.3,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.05),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: screenWidth * 0.005,
                                blurRadius: screenWidth * 0.01,
                                offset: const Offset(0, .1),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.05),
                            child: Image.network(
                              images[index]['url'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  )),
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
                      collectionName == 'fertilizers' ? '' : 'How to Grow',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  Text(
                    howDesc ?? 'No data available',
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
                      collectionName == 'fertilizers' ? '' : 'Fertilizers',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  Text(
                    fetDesc ?? 'No data available',
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
