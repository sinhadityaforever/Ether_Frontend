import 'package:flutter/material.dart';
import 'package:frontend/widgets/room_chatty.dart';

// This are chat bubbles that are messages basically

class RoomChatBubble extends StatelessWidget {
  RoomChatBubble({
    required this.texto,
    required this.isMe,
    required this.isAdmin,
    required this.isPhoto,
    required this.imageUrl,
    required this.senderName,
    required this.roomuuid,
    required this.isReply,
    required this.replyTo,
    // required this.showProfileCallback,
  });
  final String texto;
  final bool isMe;
  final bool isAdmin;
  final bool isPhoto;
  final String imageUrl;
  final String senderName;
  final String roomuuid;
  final bool isReply;
  final String replyTo;
  // final showProfileCallback;

  @override
  Widget build(BuildContext context) {
    return roomChatty(
      isMe: isMe,
      texto: texto,
      isAdmin: isAdmin,
      isPhoto: isPhoto,
      imageUrl: imageUrl,
      senderName: senderName,
      isReply: isReply,
      replyTo: replyTo,
      roomuuid: roomuuid,
      // showProfileCallback: showProfileCallback,
    );
  }
}
