class ContactsModel {
  String name;
  String imageUrl;
  String lastMessage;
  int contactId;
  String aboutValue;
  int karmaNumber;
  int level;

  ContactsModel({
    required this.imageUrl,
    required this.lastMessage,
    required this.name,
    required this.contactId,
    required this.aboutValue,
    required this.karmaNumber,
    required this.level,
  });
  void onPressCallback() {}
}
