import 'package:flutter/material.dart';
import 'package:frontend/api_calls/data.dart';
import 'package:frontend/widgets/chat_list_tile.dart';
import 'package:provider/provider.dart';

import 'chatroompage.dart';

class ChatRoomContactPage extends StatefulWidget {
  @override
  _ChatRoomContactPageState createState() => _ChatRoomContactPageState();
}

class _ChatRoomContactPageState extends State<ChatRoomContactPage> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: Provider.of<Data>(context).chatRooms.length,
        itemBuilder: (context, index) {
          final chatRoom = Provider.of<Data>(context).chatRooms[index];
          return ChatListTile(
            name: chatRoom.name,
            imageUrl: chatRoom.imageUrl,
            lastMessage:
                Provider.of<Data>(context).getlastRoomMessage(chatRoom.roomId),
            recieverId: 0,
            onPressedChatTile: () {
              Provider.of<Data>(context, listen: false)
                  .addToSelectedRoomContact(
                chatRoom.name,
                chatRoom.imageUrl,
                chatRoom.lastMessage,
                chatRoom.roomId,
              );
              Provider.of<Data>(context, listen: false).selectedRoomId =
                  chatRoom.roomId;

              Navigator.pushNamed(
                context,
                '/chatRoomChatPage',
                arguments: ChatRoomPageArguments(
                  roomAvatarUrl: chatRoom.imageUrl,
                  chatRoomName: chatRoom.name,
                  roomId: chatRoom.roomId,
                ),
              );
            },
          );
        });
  }
}
