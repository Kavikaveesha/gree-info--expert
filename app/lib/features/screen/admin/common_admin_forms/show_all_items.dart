import 'package:app/common/widgets/snack_bar/snack_bar.dart';
import 'package:app/features/screen/admin/common_admin_forms/add_new.dart';
import 'package:app/features/screen/admin/common_admin_forms/update_items.dart';
import 'package:app/utils/constants/image_strings.dart';
import 'package:app/utils/constants/mediaQuery.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowAllDetails extends StatefulWidget {
  final String collectionName;

  const ShowAllDetails({Key? key, required this.collectionName})
      : super(key: key); // Add key parameter
  @override
  State<ShowAllDetails> createState() => _ShowAllDetailsState();
}

class _ShowAllDetailsState extends State<ShowAllDetails> {
  final _auth = FirebaseAuth.instance;

  // Delete Item
  Future<void> deleteDocument(String collectionName, String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(documentId)
          .delete();
      SnackbarHelper.showSnackbar(
          title: 'Success', message: 'Successfully Delete');
    } catch (error) {
      SnackbarHelper.showSnackbar(
          title: 'Error', message: 'Error! Not Deleted');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('All Details'),
                  ElevatedButton(
                      onPressed: () {
                        Get.to(() => AddNew(
                            pageTitle: 'Add New',
                            collectionName: widget.collectionName));
                      },
                      child: Text('Add New'))
                ],
              ),
            ),
            SizedBox(
              height: MediaQueryUtils.getHeight(context),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection(widget.collectionName)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return ListItem(snapshot.data!.docs[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget ListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    String documentId = document.id;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(widget.collectionName)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No data found'));
        }

        return ItemContainer(
          title: data['title'],
          firstImageUrl:
              data['images'].isNotEmpty && data['images'][0]['url'] != null
                  ? data['images'][0]['url'] ?? ''
                  : '',
          deleteItem: () {
            deleteDocument(widget.collectionName, documentId);
          },
          updateItem: () {
            Get.to(() => UpdateItem(
                  pageTitle: 'Update Item',
                  collectionName: widget.collectionName,
                  documentId: documentId,
                ));
          },
        );
      },
    );
  }
}

class ItemContainer extends StatelessWidget {
  const ItemContainer({
    Key? key,
    required this.title,
    required this.firstImageUrl,
    required this.deleteItem,
    required this.updateItem,
  }) : super(key: key);

  final String title, firstImageUrl;
  final VoidCallback deleteItem, updateItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 245, 244, 244),
            border: Border.all(color: Colors.black45)),
        margin: EdgeInsets.only(bottom: 10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              firstImageUrl.isNotEmpty
                  ? Image.network(
                      width: MediaQueryUtils.getWidth(context) * .2,
                      height: MediaQueryUtils.getWidth(context) * .2,
                      firstImageUrl,
                      fit: BoxFit.cover,
                    )
                  : SizedBox(), // or display a placeholder image

              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title.length > 20 ? title.replaceAll(' ', '\n') : title,
                      style: Theme.of(context).textTheme.headlineSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: updateItem,
                          child: Text(
                            'Update',
                            style: TextStyle(color: Colors.green, fontSize: 15),
                          ),
                        ),
                        TextButton(
                          onPressed: deleteItem,
                          child: Text(
                            'Delete',
                            style: TextStyle(color: Colors.red, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
