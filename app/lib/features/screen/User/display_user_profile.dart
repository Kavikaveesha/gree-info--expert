import 'package:app/utils/constants/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../common/widgets/profileDetailField/profile_detail_field.dart';
import '../../../utils/constants/lists/custom_lists.dart';
import '../../../utils/constants/mediaQuery.dart';

class DisplayUserProfile extends StatelessWidget {
  const DisplayUserProfile({super.key, required this.email});
  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.appPrimaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
          child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(email)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Show a loading indicator while fetching data
                  return CircularProgressIndicator();
                } else {
                  if (snapshot.hasData && snapshot.data!.exists) {
                    // Data exists for the user, populate the fields
                    final data = snapshot.data!.data() as Map<String, dynamic>;
                    // Retrieve data from the DocumentSnapshot
                    String fullName = snapshot.data!['fullName'] ?? '';

                    String email = snapshot.data!['email'] ?? '';
                    String address = snapshot.data!['address'] ?? '';
                    String mobile = snapshot.data!['mobileNumber'] ?? '';
                    String proPic = snapshot.data!['profilePic'] ?? '';
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          SizedBox(
                              height: MediaQueryUtils.getHeight(context) * .05),
                          Align(
                            alignment: Alignment.center,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(proPic),
                                    radius: 50,
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQueryUtils.getHeight(context) * .65,
                                  child: ListView.builder(
                                    itemCount: data.length,
                                    itemBuilder: (context, index) {
                                      List<String> details = [
                                        '$fullName',
                                        '$email',
                                        '$mobile',
                                        '$address'
                                      ];

                                      if (index < details.length) {
                                        return DataDisplayCard(
                                          labelText: CustomLists
                                              .profileDetailsLabels[index],
                                          detailtext: details[index],
                                        );
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
                    return Container();
                  }
                }
              })),
    );
  }
}
