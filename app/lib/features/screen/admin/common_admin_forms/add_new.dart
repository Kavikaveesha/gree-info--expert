import 'dart:io';
import 'package:app/common/widgets/snack_bar/snack_bar.dart';
import 'package:app/common/widgets/text_inputs/text_input_field.dart';
import 'package:app/utils/validators/validation.dart';
import 'package:path/path.dart' as Path;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';

class AddNew extends StatefulWidget {
  const AddNew({
    required this.pageTitle,
    required this.collectionName,
  });

  final String pageTitle;
  final String collectionName;

  @override
  _AddNewState createState() => _AddNewState();
}

class _AddNewState extends State<AddNew> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController mainParaController = TextEditingController();
  final TextEditingController secondParaController = TextEditingController();
  final TextEditingController thirdParaController = TextEditingController();
  List<XFile> _imageFiles = [];
  final picker = ImagePicker();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _pickImages() async {
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _imageFiles.addAll(pickedFiles);
      });
    }
  }

  Future<void> _uploadData() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    try {
      // Initialize a list to hold image data
      List<Map<String, dynamic>> imageList = [];

      // Upload images to Firebase Storage and add data to Firestore
      for (var imageFile in _imageFiles) {
        File file = File(imageFile.path);
        String fileName = Path.basename(file.path);

        // Upload image to Firebase Storage
        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('images/$fileName');
        await ref.putFile(file);
        String downloadURL = await ref.getDownloadURL();

        // Construct data for each image
        Map<String, dynamic> imageData = {
          'url': downloadURL,
          'fileName': fileName,
        };

        // Add image data to the list
        imageList.add(imageData);
      }

      // Add the list of image data to Firestore under 'images' field
      await FirebaseFirestore.instance
          .collection(widget.collectionName)
          .doc()
          .set({
        'title': titleController.text.trim(),
        'mainPara': mainParaController.text.trim(),
        'secondPara': secondParaController.text.trim(),
        'thirdPara': thirdParaController.text.trim(),
        'images': imageList,
      });
      SnackbarHelper.showSnackbar(
          title: 'Success', message: 'Successfully added item');
      setState(() {
        _imageFiles.clear();
        titleController.clear();
        mainParaController.clear();
        secondParaController.clear();
        thirdParaController.clear();
      });
    } catch (error) {
      SnackbarHelper.showSnackbar(
          title: 'Error',
          message: error.toString(),
          backgroundColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          widget.pageTitle,
          style: Theme.of(context).textTheme.headlineSmall,
        )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Add Images',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              SizedBox(
                height: 200,
                child: GridView.builder(
                  itemCount: _imageFiles.length + 1,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemBuilder: (context, index) {
                    if (index == _imageFiles.length) {
                      return Center(
                        child: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: _pickImages,
                        ),
                      );
                    } else {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _imageFiles.removeAt(index);
                          });
                        },
                        child: Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image:
                                      FileImage(File(_imageFiles[index].path)),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.red,
                                child: Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Add Other Deatils',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    InputField(
                      labelText: 'Enter Title',
                      controller: titleController,
                    ),
                    InputField(
                      labelText: 'Enter Main Paragraph',
                      controller: mainParaController,
                      maxLines: 8,
                    ),
                    InputField(
                      labelText: 'Enter Second Paragraph',
                      controller: secondParaController,
                      maxLines: 15,
                    ),
                    InputField(
                      labelText: 'Enter Third Paragraph',
                      controller: thirdParaController,
                      maxLines: 15,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: SizedBox(
                  child: ElevatedButton(
                    onPressed: _uploadData,
                    child: Text('Upload Data'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
