import 'package:app/features/screen/admin/controller/ad_fruitsplants_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path; // Import Path for basename

class AddImagePage extends StatefulWidget {
  @override
  State<AddImagePage> createState() => _AddImagePageState();
}

class _AddImagePageState extends State<AddImagePage> {
  final ImagePicker picker = ImagePicker();
  late firebase_storage.Reference ref;
  late List<File> images = [];
  late CollectionReference imgRef;
  final FruitPlantController fruitPlantController =
      Get.put(FruitPlantController());

  @override
  Widget build(BuildContext context) {
    double calculateGridViewHeight() {
      final double spacing = 3; // adjust as needed
      final int crossAxisCount = 3; // adjust as needed
      final double itemHeight =
          MediaQuery.of(context).size.width / crossAxisCount;
      final int rowCount = ((images.length + 1) / crossAxisCount).ceil();
      return rowCount * (itemHeight + spacing);
    }

    return SizedBox(
        height: calculateGridViewHeight(),
        child: GridView.builder(
          itemCount: images.length + 1,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemBuilder: (context, index) {
            return index == 0
                ? Center(
                    child: Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            chooseImage();
                          },
                          icon: Icon(Icons.add),
                        ),
                        Text('Add Images')
                      ],
                    ),
                  )
                : Container(
                    margin: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(images[index - 1]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
          },
        ));
  }

  Future<void> chooseImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      images.add(File(pickedFile.path));
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('fruitplants/${Path.basename(pickedFile.path)}');
    }
  }

  // Add a new fruit plant
  Future<void> addFruitPlant(
    BuildContext context, // Access context using GetX
    String title,
    String category,
    String mainpara,
    String secondpara,
    String lastpara,
  ) async {
    try {
      for (var img in images) {
        final storageTask = ref.putFile(img);
        await storageTask;
        final downloadUrl = await ref.getDownloadURL();

        // Reference to the "fruitplant" document
        DocumentReference fruitplantRef =
            FirebaseFirestore.instance.collection('fruitplant').doc();

        // Access the "images" subcollection within the "fruitplant" document
        CollectionReference imagesRef = fruitplantRef.collection('images');

        // Create a new document within the "images" subcollection
        DocumentReference newImageDocRef = imagesRef.doc();
        await newImageDocRef.set({
          'url': downloadUrl,
        });

        await fruitplantRef.set({
          'title': title,
          'category': category,
          'mainpara': mainpara,
          'secondpara': secondpara,
          'lastpara': lastpara,
        });
      }

      images.clear();

      // Show success message using snackbar
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        // Access context using GetX
        SnackBar(content: Text('Images uploaded successfully')),
      );
    } catch (error) {
      // Show error message using snackbar
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        // Access context using GetX
        SnackBar(content: Text('Error uploading images: $error')),
      );
    }
  }
}
