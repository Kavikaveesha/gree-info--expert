import 'package:app/features/controller/chat_controller/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../common/widgets/chat_bubble/send bubble.dart';

class ChatPage extends StatefulWidget {
  final String recieverfullName;
  final String recieverEmail;

  const ChatPage({
    super.key,
    required this.recieverfullName,
    required this.recieverEmail,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessages(
          widget.recieverEmail, _messageController.text.trim());
    }
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF11302E),
      appBar: AppBar(
        title: Text(widget.recieverfullName),
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessagesList(screenSize)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: _buildMessageInput(screenSize),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildMessagesList(Size screenSize) {
    return StreamBuilder(
        stream: _chatService.getMessages(
            widget.recieverEmail, _firebaseAuth.currentUser!.email!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No chat found'));
          }
          return ListView(
            children: snapshot.data!.docs
                .map((document) => _buildMessageItem(document))
                .toList(),
          );
        });
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    bool isCurrentUser = data['senderId'] == _firebaseAuth.currentUser!.email;
    Color bubbleColor = isCurrentUser
        ? const Color(0xFFACB1A8)
        : const Color.fromARGB(255, 152, 171, 197);
    MainAxisAlignment mainAxisAlignment =
        isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start;
    CrossAxisAlignment crossAxisAlignment =
        isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    return Container(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MessageContainer(
          isUser: isCurrentUser,
          color: bubbleColor,
          child: Column(
            crossAxisAlignment: crossAxisAlignment,
            mainAxisAlignment: mainAxisAlignment,
            children: [
              Text(data['message']),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput(Size screenSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: TextField(
            controller: _messageController,
            obscureText: false,
            decoration: InputDecoration(
              hintText: 'Enter message',
              fillColor: Colors.white, // Set the input color to white
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: const Color(0xFFACB1A8),
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: IconButton(
            onPressed: sendMessage,
            icon: const Icon(
              Icons.arrow_forward,
              size: 40,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
