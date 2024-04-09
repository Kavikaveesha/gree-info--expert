import 'package:app/common/widgets/search_bar/search_bar.dart';
import 'package:app/common/widgets/snack_bar/snack_bar.dart';
import 'package:app/features/screen/User/display_user_profile.dart';
import 'package:app/utils/constants/colors.dart';
import 'package:app/utils/constants/mediaQuery.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllUsersForAdmin extends StatefulWidget {
  const AllUsersForAdmin({super.key});

  @override
  State<AllUsersForAdmin> createState() => _AllUsersForAdminState();
}

class _AllUsersForAdminState extends State<AllUsersForAdmin> {
  String name = '';
  final _auth = FirebaseAuth.instance;
  final TextEditingController searchController = TextEditingController();

  Future<void> deleteUserByEmail(String email) async {
    try {
      // 1. Query Firestore to find the user document
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final docId = querySnapshot.docs.first.id;

        // 2. Delete user document from Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(docId)
            .delete();

        SnackbarHelper.showSnackbar(
          title: 'Success',
          message: 'User account with email $email successfully deleted.',
        );
      } else {
        SnackbarHelper.showSnackbar(
          backgroundColor: Colors.red,
          title: 'Error',
          message: 'User with email $email not found.',
        );
      }
    } catch (e) {
      print('Error deleting user account: $e');
      // Handle errors and display appropriate messages
    }
  }

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
                deleteUserByEmail(email);
              },
              icon: Icon(Icons.delete)),
          onTap: () {
            Get.to(() => DisplayUserProfile(email: email));
          },
        ),
      );
    }
    if (data['fullName'].toString().toLowerCase().startsWith(name)) {
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
                deleteUserByEmail(email);
              },
              icon: Icon(Icons.delete)),
          onTap: () {
            Get.to(() => DisplayUserProfile(email: email));
          },
        ),
      );
    }
    return Container(); // Or any other widget if needed
  }
}
