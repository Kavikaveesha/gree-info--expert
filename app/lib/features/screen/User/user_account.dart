import 'dart:io';
import 'dart:typed_data';

import 'package:app/common/widgets/profile_details_card/profile_details_card.dart';
import 'package:app/features/screen/User/change_password/change_password.dart';
import 'package:app/features/screen/User/privacy&policy.dart';
import 'package:app/features/screen/User/update_profile.dart';
import 'package:app/features/screen/authentication/logIn_screen/login_screens.dart';
import 'package:app/utils/constants/mediaQuery.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../common/widgets/profileDetailField/profile_detail_field.dart';
import '../../../utils/constants/colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Uint8List? _image;
  File? selectedImage;
  // current user
  final currentUser = FirebaseAuth.instance.currentUser!;

  //  All Users
  final userCollection = FirebaseFirestore.instance.collection("users");

  Future<void> uploadProfileImage(File imgFile) async {
    try {
      final Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images/${DateTime.now().millisecondsSinceEpoch}');
      final uploadTask = storageRef.putFile(imgFile);
      final TaskSnapshot downloadUrl = await uploadTask;
      final String imageUrl = await downloadUrl.ref.getDownloadURL();

      // Get the current user
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'No user found.',
        );
      }

      // Update Firestore database
      final userCollection = FirebaseFirestore.instance.collection('users');
      final userDoc = await userCollection.doc(currentUser.email).get();
      if (!userDoc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User Not Found')),
        );
      }

      if (userDoc.data()!.containsKey('profilePic')) {
        await userCollection
            .doc(currentUser.email)
            .update({'profilePic': imageUrl});
      } else {
        await userCollection.doc(currentUser.email).set({
          'profilePic': imageUrl,
        }, SetOptions(merge: true));
      }
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Exception: ${e.message}');
    } on FirebaseException catch (e) {
      print('Firebase Exception: ${e.message}');
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(currentUser.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData ||
              snapshot.data == null ||
              snapshot.data!.data() == null) {
            FirebaseAuth.instance.signOut();
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          String fullName = userData['fullName'];

          String? imageUrl = userData.containsKey('profilePic')
              ? userData['profilePic']
              : null;

          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: MyColors.appPrimaryColor,
              title: Center(
                child: Text(
                  '$fullName \'s profile',
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: SizedBox(
                      width: MediaQueryUtils.getWidth(context),
                      height: MediaQueryUtils.getHeight(context) * .3,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          snapshot.hasData
                              ? CircleAvatar(
                                  radius: 80,
                                  backgroundColor: Colors.white,
                                  backgroundImage: NetworkImage(imageUrl!),
                                )
                              : const CircleAvatar(
                                  radius: 80,
                                  backgroundColor: Colors.white,
                                ),
                          Positioned(
                            bottom: 10,
                            left: 200,
                            child: IconButton(
                              onPressed: () {
                                showImagePickerOption(context);
                              },
                              icon: const Icon(
                                Icons.add_a_photo,
                                size: 40,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ProfileDetailsCard(
                          text: 'Accouct Details',
                          onTap: () {
                            Get.to(() => UserProfile());
                          },
                          icon: Icons.account_circle),
                      ProfileDetailsCard(
                          text: 'Password Reset',
                          onTap: () {
                            Get.to(() => ChangePassword());
                          },
                          icon: Icons.password),
                      ProfileDetailsCard(
                          text: 'Privacy and Policy',
                          onTap: () {
                            Get.to(() => PrivacyPolicyPage());
                          },
                          icon: Icons.privacy_tip),
                      ProfileDetailsCard(
                          text: 'Log Out',
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Confirmation'),
                                  content: const Text("Do you want to Exit?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: const Text('NO'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        FirebaseAuth.instance.signOut();
                                        Get.to(() => const LogInScreen());
                                      },
                                      child: const Text('Yes'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: Icons.logout)
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  void showImagePickerOption(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.lightGreen,
      context: context,
      builder: (builder) {
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 5,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _pickImageFromGallery();
                    },
                    child: const SizedBox(
                      child: Column(
                        children: [
                          Icon(
                            Icons.image,
                            size: 70,
                          ),
                          Text("Gallery")
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _pickImageFromCamera();
                    },
                    child: const SizedBox(
                      child: Column(
                        children: [
                          Icon(
                            Icons.camera_alt,
                            size: 70,
                          ),
                          Text("Camera")
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Gallery
  Future<void> _pickImageFromGallery() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return;
    final File imageFile = File(pickedImage.path);
    final Uint8List bytes = await imageFile.readAsBytes();
    setState(() {
      selectedImage = imageFile;
      _image = bytes;
    });
    uploadProfileImage(selectedImage!);
    Navigator.of(context).pop();
  }

  // Camera
  Future<void> _pickImageFromCamera() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedImage == null) return;
    final File imageFile = File(pickedImage.path);
    final Uint8List bytes = await imageFile.readAsBytes();
    setState(() {
      selectedImage = imageFile;
      _image = bytes;
    });
    Navigator.of(context).pop();
  }
}

//                         icon: Icons.logout,


 // Text(
                      //   'Account Details',
                      //   style: Theme.of(context).textTheme.headlineMedium,
                      // ),
                      // Column(
                      //   children: [
                      //     ProfileDetailField(
                      //         labelIcon: Icons.man,
                      //         labelText: 'Full Name',
                      //         detailtext: '',
                      //         onTapEdit: () {}),
                      //     ProfileDetailField(
                      //         labelIcon: Icons.man,
                      //         labelText: 'Full Name',
                      //         detailtext: '',
                      //         onTapEdit: () {}),
                      //     ProfileDetailField(
                      //         labelIcon: Icons.man,
                      //         labelText: 'Full Name',
                      //         detailtext: '',
                      //         onTapEdit: () {}),
                      //     ProfileDetailField(
                      //         labelIcon: Icons.man,
                      //         labelText: 'Full Name',
                      //         detailtext: '',
                      //         onTapEdit: () {}),
                      //   ],
                      // ),
                      // Text(
                      //   'Privacy and Policy',
                      //   style: Theme.of(context).textTheme.headlineMedium,
                      // ),