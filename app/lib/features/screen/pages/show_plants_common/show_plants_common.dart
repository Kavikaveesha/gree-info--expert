import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:app/common/widgets/common_plant_card/common_plant_card.dart';
import 'package:app/features/screen/pages/show_plant_all_details/show_plant_all_details.dart';
import 'package:app/utils/constants/image_strings.dart';
import 'package:app/utils/constants/mediaQuery.dart';

import '../../../../common/widgets/search_bar/search_bar.dart';

class ShowPlantsCommon extends StatefulWidget {
  final String title;
  final String collectionName;

  const ShowPlantsCommon({
    Key? key,
    required this.title,
    required this.collectionName,
  }) : super(key: key);

  @override
  State<ShowPlantsCommon> createState() => _ShowPlantsCommonState();
}

class _ShowPlantsCommonState extends State<ShowPlantsCommon> {
  String title = '';
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        titleSpacing: 10,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomSearchBar(
              controller: searchController,
              onChange: (val) {
                setState(() {
                  title = val;
                });
              },
            ),
            PlantBox(), // Corrected method name to follow Dart conventions
          ],
        ),
      ),
    );
  }

  Widget PlantBox() {
    // Corrected method name to follow Dart conventions
    return SizedBox(
      height: MediaQueryUtils.getHeight(context),
      child: FutureBuilder<QuerySnapshot>(
        future:
            FirebaseFirestore.instance.collection(widget.collectionName).get(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final List<DocumentSnapshot> documents = snapshot.data!.docs;
            if (documents.isEmpty) {
              // If there are no documents available
              return Center(
                child: Column(
                  children: [
                    Image.asset(
                      MyImages.noData,
                      width: MediaQueryUtils.getWidth(context) * .5,
                    ),
                    Text('No posts available'),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final document = documents[index];

                final List<dynamic> images = document['images'];

                String firstImg = '';
                String secondImg = '';
                String thirdImg = '';
                String mainDesc1 = '';

                if (images.length >= 1) {
                  firstImg = images[0]['url'];
                }

                if (images.length >= 2) {
                  secondImg = images[1]['url'];
                }

                if (images.length >= 3) {
                  thirdImg = images[2]['url'];
                }
                final String plantTitle = document['title'];
                String mainDesc = document['mainPara'];
                String howToDesc = document['secondPara'];
                String fertiDesc = document['thirdPara'];
                if (mainDesc.length > 50) {
                  mainDesc1 = mainDesc.substring(0, 100) + '...';
                }

                if (title.isEmpty) {
                  return ExpandableCard(
                    title: plantTitle,
                    description: mainDesc1,
                    imagePath: firstImg,
                    onTapMore: () {
                      Get.to(() => ShowPlantAllDetails(
                            collectionName: widget.collectionName,
                            plantTitle: plantTitle,
                            mainDesc: mainDesc,
                            howToDesc: howToDesc,
                            fertiDesc: fertiDesc,
                            images: images,
                          ));
                    },
                  );
                }
                if (document['title']
                    .toString()
                    .toLowerCase()
                    .startsWith(title.toLowerCase())) {
                  return ExpandableCard(
                    title: plantTitle,
                    description: mainDesc1,
                    imagePath: firstImg,
                    onTapMore: () {
                      Get.to(() => ShowPlantAllDetails(
                            collectionName: widget.collectionName,
                            plantTitle: plantTitle,
                            mainDesc: mainDesc,
                            howToDesc: howToDesc,
                            fertiDesc: fertiDesc,
                            images: images,
                          ));
                    },
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
