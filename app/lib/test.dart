import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MultipleImagePicker extends StatefulWidget {
  final MultipleImagePickerController controller;

  MultipleImagePicker({Key? key, required this.controller}) : super(key: key);

  @override
  _MultipleImagePickerState createState() => _MultipleImagePickerState();
}

class _MultipleImagePickerState extends State<MultipleImagePicker> {
  final List<XFile> _imageFiles = [];
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            itemCount: _imageFiles.length + 1,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemBuilder: (context, index) {
              return index == _imageFiles.length
                  ? Center(
                      child: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: _pickImages,
                      ),
                    )
                  : Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: FileImage(File(_imageFiles[index].path)),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              _removeImage(index);
                            },
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.red,
                              child: Icon(Icons.close, size: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    );
            },
          ),
        ),
        ElevatedButton(
          onPressed: _uploadImages,
          child: Text('Upload Images'),
        ),
      ],
    );
  }

  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _imageFiles.addAll(pickedFiles);
        widget.controller.images.addAll(pickedFiles.map((file) => File(file.path)).toList());
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _imageFiles.removeAt(index);
      widget.controller.images.removeAt(index);
    });
  }

  Future<void> _uploadImages() async {
    // Implement your upload logic here
  }
}

class MultipleImagePickerController {
  List<File> images = [];
}
