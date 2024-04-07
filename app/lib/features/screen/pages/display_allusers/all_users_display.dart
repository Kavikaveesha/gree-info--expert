import 'package:app/common/widgets/search_bar/search_bar.dart';
import 'package:app/features/screen/User/display_user_profile.dart';
import 'package:app/utils/constants/colors.dart';
import 'package:app/utils/constants/mediaQuery.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../chat/chat_page.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({super.key});

  @override
  State<AllUsers> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  String name = '';
  final _auth = FirebaseAuth.instance;
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.appPrimaryColor,
        title: Center(
          child: Text(
            'All Users',
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
            CustomSearchBar(
              controller: searchController,
              onChange: (val) {
                setState(() {
                  name = val;
                });
              },
            ),
            SizedBox(
                height: MediaQueryUtils.getHeight(context), child: usersList())
          ],
        ),
      ),
    );
  }

  Widget usersList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No users found'));
        }
        return ListView(
          children: snapshot.data!.docs
              .map<Widget>((doc) => userListItem(doc))
              .toList(),
        );
      },
    );
  }

  // Create user list item
  Widget userListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    String email = data['email'];
    String fullName = data['fullName'];
    String proPic = data['profilePic'];
    if (_auth.currentUser != null && _auth.currentUser!.email != email) {
      if (name.isEmpty) {
        return Container(
          margin: EdgeInsets.all(15),
          width: MediaQueryUtils.getWidth(context) * .9,
          decoration: BoxDecoration(
            color: Colors.grey[100], // Light background color
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // Simple box shadow
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(0, 2), // Shadow position
              ),
            ],
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(proPic),
            ),
            title: Text(fullName),
            trailing: IconButton(
                onPressed: () {
                  Get.to(() => ChatPage(
                        recieverEmail: email,
                        recieverfullName: fullName,
                      ));
                },
                icon: Icon(Icons.chat_bubble)),
            onTap: () {
              Get.to(() => DisplayUserProfile(email: email));
            },
          ),
        );
      }
      if (data['fullName']
          .toString()
          .toLowerCase()
          .startsWith(name.toLowerCase())) {
        return Container(
          margin: EdgeInsets.all(15),
          width: MediaQueryUtils.getWidth(context) * .9,
          decoration: BoxDecoration(
            color: Colors.grey[100], // Light background color
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // Simple box shadow
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(0, 2), // Shadow position
              ),
            ],
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(proPic),
            ),
            title: Text(fullName),
            trailing: IconButton(
                onPressed: () {
                  Get.to(() => ChatPage(
                        recieverEmail: email,
                        recieverfullName: fullName,
                      ));
                },
                icon: Icon(Icons.chat_bubble)),
            onTap: () {
              Get.to(() => ChatPage(
                    recieverEmail: email,
                    recieverfullName: fullName,
                  ));
            },
          ),
        );
      }
    }
    return Container(); // Or any other widget if needed
  }
}
