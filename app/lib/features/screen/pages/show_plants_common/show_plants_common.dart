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
            PlantBox(),
          ],
        ),
      ),
    );
  }

  Widget PlantBox() {
    return SizedBox(
      height: MediaQueryUtils.getHeight(context) * .75,
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
            // Filter documents based on search query
            final filteredDocuments = documents.where((document) {
              final plantTitle = document['title'].toString().toLowerCase();
              return title.isEmpty ||
                  plantTitle.contains(title.toLowerCase()) ||
                  plantTitle.startsWith(title.toLowerCase());
            }).toList();

            return ListView.builder(
              itemCount: filteredDocuments.length,
              itemBuilder: (context, index) {
                final document = filteredDocuments[index];
                final List<dynamic> images = document['images'];
                final String firstImg =
                    images.isNotEmpty ? images[0]['url'] : '';
                final String plantTitle = document['title'];
                final String mainDesc = document['mainPara'];
                final String mainDesc1 = mainDesc.length > 50
                    ? mainDesc.substring(0, 100) + '...'
                    : mainDesc;

                return ExpandableCard(
                  title: plantTitle,
                  description: mainDesc1,
                  imagePath: firstImg,
                  onTapMore: () {
                    Get.to(() => ShowPlantAllDetails(
                          collectionName: widget.collectionName,
                          plantTitle: plantTitle,
                          mainDesc: mainDesc,
                          howToDesc: document['secondPara'],
                          fertiDesc: document['thirdPara'],
                          images: images,
                        ));
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
