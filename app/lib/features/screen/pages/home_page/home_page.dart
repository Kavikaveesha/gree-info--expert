import 'package:app/common/widgets/custom_appbar/custom_appbar.dart';
import 'package:app/common/widgets/search_bar/search_bar.dart';
import 'package:app/common/widgets/whiteBoxContainer/white_container.dart';
import 'package:app/features/screen/pages/search_page/search_page.dart';
import 'package:app/features/screen/pages/show_plants_common/show_plants_common.dart';
import 'package:app/utils/constants/lists/custom_lists.dart';
import 'package:app/utils/constants/mediaQuery.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

// this is get current user method
  void _getCurrentUser() {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      setState(() {
        _currentUser = currentUser;
      });
    } else {}
  }

// Get all the users from databse
  final userCollection = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(_currentUser!.email)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Show a loading indicator while fetching data
                  return CircularProgressIndicator();
                } else {
                  if (snapshot.hasData && snapshot.data!.exists) {
                    // Data exists for the user, populate the fields
                    final data = snapshot.data!.data() as Map<String, dynamic>;

                    return CustomAppBar(
                      name: data['fullName'],
                      proImg: data['profilePic'],
                    );
                  } else {
                    return CustomAppBar(
                      name: 'No User SignIn',
                      proImg: '',
                    );
                  }
                }
              },
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => SearchPage());
              },
              child: CustomSearchBar(
                isEnable: false,
              ),
            ),
            SizedBox(
              height: MediaQueryUtils.getHeight(context),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 5.0,
                    mainAxisExtent: 120),
                itemCount: CustomLists.categories.length,
                itemBuilder: (BuildContext context, int index) {
                  return GridTile(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: CustomContainer(
                        width: MediaQueryUtils.getWidth(context) * .2,
                        child: InkWell(
                          onTap: () {
                            Get.to(() => ShowPlantsCommon(
                                  title: CustomLists.titles[index],
                                  collectionName: CustomLists
                                      .categories[index].collectionName,
                                ));
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 15),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: AssetImage(CustomLists
                                          .categories[index].imageUrl),
                                      radius: 30,
                                      backgroundColor: Colors.white,
                                    ),
                                    SizedBox(
                                      width: MediaQueryUtils.getWidth(context) *
                                          .02,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          CustomLists.categories[index].title,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(
                                          child: StreamBuilder<QuerySnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection(
                                                  CustomLists.categories[index]
                                                      .collectionName,
                                                )
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasError) {
                                                return Text(
                                                    'Error: ${snapshot.error}');
                                              }
                                              if (!snapshot.hasData ||
                                                  snapshot.data!.docs.isEmpty) {
                                                return Center(
                                                  child: Text('0 data'),
                                                );
                                              }

                                              int documentCount =
                                                  snapshot.data!.docs.length;

                                              return Text(
                                                  '$documentCount items');
                                            },
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
