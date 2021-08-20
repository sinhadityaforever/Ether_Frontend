class RoomMessageModel {
  final String message;
  final int senderId;
  final int roomId;
  final bool isAdmin;
  final bool isPhoto;
  final String imageUrl;
  final String senderName;

  RoomMessageModel({
    required this.message,
    required this.roomId,
    required this.senderId,
    required this.isAdmin,
    required this.isPhoto,
    required this.imageUrl,
    required this.senderName,
  });
}
