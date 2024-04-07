import 'package:app/common/widgets/common_plant_card/common_plant_card.dart';
import 'package:app/utils/constants/image_strings.dart';
import 'package:app/utils/constants/mediaQuery.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app/common/widgets/search_bar/search_bar.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/colors.dart';
import '../chat/chat_page.dart';
import '../show_plant_all_details/show_plant_all_details.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _auth = FirebaseAuth.instance;
  final List<String> collections = [
    'fertilizers', // Initial title
    'vegitable plants', // Add all titles here
    'fruits plants',
    'indoor plants',
    'bedding plants'
  ];
  List<Map<String, dynamic>> filteredData = [];

  final TextEditingController _searchController = TextEditingController();
  String? selectedCollection;
  void filterData() {
    setState(() {
      if (selectedCollection != null) {
        // Access the Firebase collection based on the selected collection
        CollectionReference collectionRef =
            FirebaseFirestore.instance.collection(selectedCollection!);

        // Apply filter based on search criteria (case-insensitive)
        collectionRef
            .where(
              'title',
              isGreaterThanOrEqualTo: _searchController.text,
            )
            .where(
              'title',
              isLessThanOrEqualTo: _searchController.text + '\uf8ff',
            )
            .get()
            .then((QuerySnapshot querySnapshot) {
          // Clear existing filtered data
          filteredData.clear();

          // Add the filtered documents to filteredData (with type safety)
          for (var doc in querySnapshot.docs) {
            filteredData.add(doc.data() as Map<String, dynamic>);
          }
          _searchController.clear();
        }).catchError((error) {
          print("Error getting documents: $error");
          // Handle error gracefully
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('An error occurred while searching.')),
          );
        });
      } else {
        // Handle case where no collection is selected
        filteredData.clear(); // Clear existing data
        // Optionally show a message or snackbar asking the user to select a collection
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: MyColors.appPrimaryColor,
        title: Center(
          child: Text(
            'Search and find!',
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: Colors.white),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQueryUtils.getHeight(context) * .05,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Category',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    clipBehavior: Clip.none,
                    children: collections.map((collection) {
                      return FilterChip(
                        label: Text(collection),
                        selected: selectedCollection == collection,
                        onSelected: (isSelected) {
                          setState(() {
                            if (isSelected) {
                              selectedCollection = collection;
                            } else {
                              selectedCollection = null;
                            }
                            filterData();
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            CustomSearchBar(
                controller: _searchController,
                onTap: () {
                  setState(() {
                    filterData();
                  });
                }),
            filteredData.isEmpty
                ? Center(
                    child: Column(
                    children: [
                      Image(
                        image: AssetImage(MyImages.noData),
                        width: MediaQueryUtils.getWidth(context) * .4,
                      ),
                      Text('No results found.'),
                    ],
                  ))
                : SizedBox(
                    height: MediaQueryUtils.getHeight(context),
                    child: ListView.builder(
                        itemCount: filteredData.length,
                        itemBuilder: (context, index) {
                          final document = filteredData[index];

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

                          return ExpandableCard(
                            title: plantTitle,
                            description: mainDesc1,
                            imagePath: firstImg,
                            onTapMore: () {
                              Get.to(() => ShowPlantAllDetails(
                                    plantTitle: plantTitle,
                                    firstImg: firstImg,
                                    secondImg: secondImg,
                                    thirdImg: thirdImg,
                                    mainDesc: mainDesc,
                                    howToDesc: howToDesc,
                                    fertiDesc: fertiDesc,
                                  ));
                            },
                          );
                        }),
                  ),
          ],
        ),
      ),
    );
  }
}
