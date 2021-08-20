class ChatRoomModel {
  String name;
  String imageUrl;
  String lastMessage;
  int roomId;

  ChatRoomModel({
    required this.imageUrl,
    required this.lastMessage,
    required this.name,
    required this.roomId,
  });
}
