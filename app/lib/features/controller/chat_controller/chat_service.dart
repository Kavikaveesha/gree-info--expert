// Add necessary imports
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../models/message_model.dart';

// Define ChatService class
class ChatService extends GetxController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // Method to send messages
  Future<void> sendMessages(String receiverEmail, String message) async {
    try {
      final String currentUserEmail =
          _firebaseAuth.currentUser!.email.toString();
      final Timestamp timestamp = Timestamp.now();
      Message newMessage = Message(
        senderId: currentUserEmail,
        senderEmail: currentUserEmail,
        receiverId: receiverEmail,
        message: message,
        timestamp: timestamp,
      );
      List<String> ids = [currentUserEmail, receiverEmail];
      ids.sort();
      String chatRoomId = ids.join("_");

      await _firebaseFirestore
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .add(newMessage.toMap());
    } catch (error) {
      print('Error sending message: $error');
      rethrow; // Rethrow the error to propagate it to the caller
    }
  }

  // Method to retrieve messages
  Stream<QuerySnapshot> getMessages(String userEmail, String otherUserEmail) {
    try {
      List<String> ids = [userEmail, otherUserEmail];
      ids.sort();
      String chatRoomId = ids.join("_");

      return _firebaseFirestore
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .orderBy('timestamp', descending: false)
          .snapshots();
    } catch (error) {
      print('Error getting messages: $error');
      throw error; // Throw the error to notify the caller
    }
  }
}
