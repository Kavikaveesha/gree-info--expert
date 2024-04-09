import 'package:app/common/widgets/whiteBoxContainer/white_container.dart';
import 'package:app/features/models/category_card_model.dart';
import 'package:app/features/screen/admin/common_admin_forms/show_all_items.dart';
import 'package:app/features/screen/admin/display_user.dart';
import 'package:app/features/screen/authentication/logIn_screen/login_screens.dart';
import 'package:app/utils/constants/image_strings.dart';
import 'package:app/utils/constants/mediaQuery.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminHomePage extends StatelessWidget {
  final List<CategoryCard> categories = [
    CategoryCard(
        title: 'Users',
        imageUrl: MyImages.users,
        onTap: () {
          Get.to(() => AllUsersForAdmin());
        },
        collectionName: 'users'),
    CategoryCard(
        title: 'Fertilizers',
        imageUrl: MyImages.fertilizer,
        onTap: () {
          Get.to(() => ShowAllDetails(collectionName: 'fertilizers'));
        },
        collectionName: 'fertilizers'),
    CategoryCard(
        title: 'Vegitable\nPlants',
        imageUrl: MyImages.vegiplants,
        onTap: () {
          Get.to(() => ShowAllDetails(collectionName: 'vegitable plants'));
        },
        collectionName: 'vegitable plants'),
    CategoryCard(
        title: 'Fruit\nPlants',
        imageUrl: MyImages.fruitplants,
        onTap: () {
          Get.to(() => ShowAllDetails(collectionName: 'fruits plants'));
        },
        collectionName: 'fruits plants'),
    CategoryCard(
        title: 'Indoor\nPlants',
        imageUrl: MyImages.indorPlants,
        onTap: () {
          Get.to(() => ShowAllDetails(collectionName: 'indoor plants'));
        },
        collectionName: 'indoor plants'),
    CategoryCard(
        title: 'Bedding\nPlants',
        imageUrl: MyImages.bedplants,
        onTap: () {
          Get.to(() => ShowAllDetails(collectionName: 'bedding plants'));
        },
        collectionName: 'bedding plants'),
    CategoryCard(
        title: 'Flower\nPlants',
        imageUrl: MyImages.flowerPlants,
        onTap: () {
          Get.to(() => ShowAllDetails(collectionName: 'flower plants'));
        },
        collectionName: 'flower plants'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Pannel'),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => LogInScreen());
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQueryUtils.getHeight(context) * .1,
            ),
            SizedBox(
              height: MediaQueryUtils.getHeight(context),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 5.0,
                    mainAxisExtent: 120),
                itemCount:
                    categories.length, // Total number of items in the list
                itemBuilder: (BuildContext context, int index) {
                  return GridTile(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: CustomContainer(
                      width: MediaQueryUtils.getWidth(context) * .2,
                      child: InkWell(
                        onTap: categories[index].onTap,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                      backgroundImage: AssetImage(
                                          categories[index].imageUrl),
                                      radius: 30,
                                      backgroundColor: Colors.white),
                                  SizedBox(
                                    width:
                                        MediaQueryUtils.getWidth(context) * .02,
                                  ),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          categories[index].title,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(
                                          child: StreamBuilder<QuerySnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection(
                                                  categories[index]
                                                      .collectionName,
                                                )
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {}
                                              if (snapshot.hasError) {
                                                return Text(
                                                    'Error: ${snapshot.error}');
                                              }
                                              if (!snapshot.hasData ||
                                                  snapshot.data!.docs.isEmpty) {
                                                return Center(
                                                    child: Text('0 data'));
                                              }

                                              // Get the number of documents in the collection
                                              int documentCount =
                                                  snapshot.data!.docs.length;

                                              // Display the number of documents
                                              return Text(
                                                  '$documentCount items');
                                            },
                                          ),
                                        ),
                                      ])
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
