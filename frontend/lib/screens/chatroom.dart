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
          String aboutValue = '';
          int chatRoomsIndex = index;
          switch (chatRoomsIndex) {
            case 0:
              {
                aboutValue =
                    "\u2022Welcome to the Entrepreneurship room\n\n\u2022This chat-room can serve a lot of purpose like finding co-founder, free promotion of your product and brainstorming on topics regarding startups and products.\n\n\u2022We request you share great videos that you learn over here so that people can grow together\n\n\u2022If You have any thoughts in your regarding any topic feel free to question no one is judging you for anything\n\n\u2022Let's build India's smartest community and don't forget to scroll down and learn from the handpicked specially curated content just for you,\n\n\u2022Do not forget to share the app with your friends because it's always fun to learn and grow together";
              }
              break;
            case 1:
              {
                aboutValue =
                    "\u2022Welcome to the Finance room\n\n\u2022This chat-room can serve a lot of purpose like finding co-founder, free promotion of your product and brainstorming on topics regarding personal finance, money management.\n\n\u2022We request you share great videos that you learn over here so that people can grow together\n\n\u2022If You have any thoughts in your regarding any topic feel free to question no one is judging you for anything\n\n\u2022Let's build India's smartest community and don't forget to scroll down and learn from the handpicked specially curated content just for you,\n\n\u2022Do not forget to share the app with your friends because it's always fun to learn and grow together";
              }
              break;
            case 2:
              {
                aboutValue =
                    "\u2022Welcome to the Online-presence room\n\n\u2022This chat-room can serve a lot of purpose like finding co-founder, free promotion of your product and brainstorming on topics regarding the presence of an online presence.\n\n\u2022We request you share great videos that you learn over here so that people can grow together\n\n\u2022If You have any thoughts in your regarding any topic feel free to question no one is judging you for anything\n\n\u2022Let's build India's smartest community and don't forget to scroll down and learn from the handpicked specially curated content just for you,\n\n\u2022Do not forget to share the app with your friends because it's always fun to learn and grow together";
              }
              break;
            case 3:
              {
                aboutValue =
                    "\u2022Welcome to the Coding room\n\n\u2022This chat-room can serve a lot of purpose like finding co-founder, free promotion of your product and brainstorming on regarding your coding projects and placements and all fun stuff.\n\n\u2022We request you share great videos that you learn over here so that people can grow together\n\n\u2022If You have any thoughts in your regarding any topic feel free to question no one is judging you for anything\n\n\u2022Let's build India's smartest community and don't forget to scroll down and learn from the handpicked specially curated content just for you,\n\n\u2022Do not forget to share the app with your friends because it's always fun to learn and grow together";
              }
              break;
            case 4:
              {
                aboutValue =
                    "\u2022Welcome to the Expand your brain room\n\n\u2022This chat-room can serve a lot of purpose like finding co-founder, free promotion of your product and brainstorming on topics regarding Books, productivity, spirituality and mediataion.\n\n\u2022We request you share great videos that you learn over here so that people can grow together\n\n\u2022If You have any thoughts in your regarding any topic feel free to question no one is judging you for anything\n\n\u2022Let's build India's smartest community and don't forget to scroll down and learn from the handpicked specially curated content just for you,\n\n\u2022Do not forget to share the app with your friends because it's always fun to learn and grow together";
              }
              break;
            case 5:
              {
                aboutValue =
                    "\u2022Welcome to the Design room\n\n\u2022This chat-room can serve a lot of purpose like finding co-founder, free promotion of your product and brainstorming on topics regarding anything and everything about designing.\n\n\u2022We request you share great videos that you learn over here so that people can grow together\n\n\u2022If You have any thoughts in your regarding any topic feel free to question no one is judging you for anything\n\n\u2022Let's build India's smartest community and don't forget to scroll down and learn from the handpicked specially curated content just for you,\n\n\u2022Do not forget to share the app with your friends because it's always fun to learn and grow together";
              }
              break;
          }
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
                  aboutRoom: aboutValue,
                ),
              );
            },
          );
        });
  }
}
