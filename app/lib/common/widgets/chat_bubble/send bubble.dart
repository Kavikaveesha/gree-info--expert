import 'package:flutter/material.dart';

class MessageContainer extends StatelessWidget {
  final Widget child;
  final Color color;
  final bool isUser;

  const MessageContainer(
      {super.key,
      required this.color,
      required this.isUser,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16.0),
          topRight: const Radius.circular(16.0),
          bottomLeft: isUser ? const Radius.circular(16.0) : Radius.zero,
          bottomRight: isUser ? Radius.zero : const Radius.circular(16.0),
        ),
      ),
      padding: const EdgeInsets.all(12.0),
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: child,
    );
  }
}
