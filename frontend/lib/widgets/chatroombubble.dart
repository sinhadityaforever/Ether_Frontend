import 'package:flutter/material.dart';
import 'package:frontend/widgets/room_chatty.dart';

// This are chat bubbles that are messages basically

class ChatRoomBubble extends StatelessWidget {
  ChatRoomBubble({
    required this.texto,
    required this.isMe,
    required this.isAdmin,
    required this.isPhoto,
    required this.imageUrl,
    required this.uuid,
    required this.isReply,
    required this.replyTo,
    required this.senderName,
  });
  final String texto;
  final bool isMe;
  final bool isAdmin;
  final bool isPhoto;
  final String imageUrl;
  final String uuid;
  final bool isReply;
  final String replyTo;
  final String senderName;

  @override
  Widget build(BuildContext context) {
    return roomChatty(
      isMe: isMe,
      texto: texto,
      isAdmin: isAdmin,
      isPhoto: isPhoto,
      imageUrl: imageUrl,
      isReply: isReply,
      replyTo: replyTo,
      uuid: uuid,
      senderName: senderName,
    );
  }
}
