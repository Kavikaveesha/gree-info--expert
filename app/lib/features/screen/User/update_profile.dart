import 'package:app/common/widgets/CustomeContainer/Custom_container.dart';
import 'package:app/utils/constants/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/profileDetailField/profile_detail_field.dart';
import '../../../utils/constants/lists/custom_lists.dart';
import '../../../utils/constants/mediaQuery.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  // this is get current user from firebaseauth
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

  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: Border.all(style: BorderStyle.none),
              backgroundColor: Colors.grey[900],
              title: Text(
                'Edit $field',
                style: const TextStyle(color: Colors.white),
              ),
              content: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Enter  new $field",
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: InputBorder.none, // Remove the border
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                onChanged: (value) {
                  newValue = value;
                },
              ),
              actions: [
                // cancel button
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    )),

                // save button
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ));

    // update firestore dtabase
    if (newValue.trim().isNotEmpty) {
      await userCollection.doc(_currentUser!.email).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.appPrimaryColor,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        backgroundColor: MyColors.appPrimaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text(
                'Update User Profile',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(color: Colors.white),
              ),
            ),
            CurvedCustomContainer(
              topHeight: MediaQueryUtils.getHeight(context) * .05,
              containerHeight: MediaQueryUtils.getHeight(context),
              child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(_currentUser?.email)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Show a loading indicator while fetching data
                      return CircularProgressIndicator();
                    } else {
                      if (snapshot.hasData && snapshot.data!.exists) {
                        // Data exists for the user, populate the fields
                        final data =
                            snapshot.data!.data() as Map<String, dynamic>;

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              SizedBox(
                                  height:
                                      MediaQueryUtils.getHeight(context) * .05),
                              Align(
                                alignment: Alignment.center,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQueryUtils.getHeight(context) *
                                              .65,
                                      child: ListView.builder(
                                        itemCount: data.length,
                                        itemBuilder: (context, index) {
                                          // Retrieve data from the DocumentSnapshot
                                          String fullName =
                                              snapshot.data!['fullName'] ?? '';
                                          String email =
                                              snapshot.data!['email'] ?? '';
                                          String address =
                                              snapshot.data!['address'] ?? '';
                                          String mobile =
                                              snapshot.data!['mobileNumber'] ??
                                                  '';

                                          List<String> details = [
                                            '$fullName',
                                            '$email',
                                            '$mobile',
                                            '$address'
                                          ];

                                          if (index < details.length) {
                                            return DataDisplayCard(
                                                labelText: CustomLists
                                                        .profileDetailsLabels[
                                                    index],
                                                detailtext: details[index],
                                                edit: 'Edit',
                                                onTapEdit: () => editField(
                                                    CustomLists
                                                            .profileDetailsFields[
                                                        index]));
                                          } else {
                                            // Handle the case where the index is out of range
                                            return SizedBox(); // Return an empty SizedBox or handle it accordingly
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        // No data exists for the user, show add button and message
                        return Column(
                          children: [
                            SizedBox(
                                height:
                                    MediaQueryUtils.getHeight(context) * .05),
                            Align(
                              alignment: Alignment.center,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 15),
                                    child: Text(
                                      'User Profile',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQueryUtils.getHeight(context) *
                                        .65,
                                    child: ListView.builder(
                                      itemCount: CustomLists
                                          .profileDetailsLabels.length,
                                      itemBuilder: (context, index) {
                                        return DataDisplayCard(
                                          labelText: CustomLists
                                              .profileDetailsLabels[index],
                                          detailtext: 'No Data Added Still',
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
