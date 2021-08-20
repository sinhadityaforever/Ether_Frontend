import 'package:flutter/material.dart';
import 'chatty.dart';
// This are chat bubbles that are messages basically

class ChatBubble extends StatelessWidget {
  ChatBubble({
    required this.texto,
    required this.isMe,
    required this.isAdmin,
    required this.isPhoto,
    required this.imageUrl,
  });
  final String texto;
  final bool isMe;
  final bool isAdmin;
  final bool isPhoto;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return chatty(
      isMe: isMe,
      texto: texto,
      isAdmin: isAdmin,
      isPhoto: isPhoto,
      imageUrl: imageUrl,
    );
  }
}
