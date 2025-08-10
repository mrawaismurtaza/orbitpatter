import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  final Object? extra;
  const Chat({super.key, this.extra});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Chat Screen'),
    );
  }
}