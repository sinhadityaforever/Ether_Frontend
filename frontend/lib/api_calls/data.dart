import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/main.dart';
import 'package:frontend/models/feed_card.dart';
import 'package:frontend/models/group_chat.dart';
import 'package:frontend/models/screening.dart';

import '../models/interestModel.dart';
import 'package:frontend/models/contacts_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Data extends ChangeNotifier {
  String uid = '';
  String ip = '192.168.0.199';
  late final User googleUser;
  var signupEmail;
  var otp;
  bool showIndicator = false;
  bool showIndicator1 = false;
  String secretPwd = 'OtherSignIn';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn(scopes: ['email']);
  final storage = FlutterSecureStorage();
  String tokenOfUser = 'NotAToken';
  int idOfUser = 0;
  String nameOfUser = '';
  String firstinterestOfuser = 'interest';
  List<ContactsModel> contacts = [];
  List<dynamic> contactInterest = [];
  List<String> contactInterestString = [];
  List<FeedCard> feedCards = [];
  List<FeedCard> bookmarkedFeedCards = [];
  String contactInterestInterpolated = '';
  List<dynamic> selfInterest = [];
  List<String> selfInterestString = [];
  String selfInterestInterpolated = '';
  int karmaNumber = 0;
  int pointsForNextLevel = 0;
  String karmaLevel = '';
  int level = 0;
  int selectedRoomId = 0;
  List<ChatRoomModel> chatRooms = [];
  // List<RoomMessageModel> roomMessages = [];
  List<int> roomId = [];
  final List<int> contactId = [];
  List<String> userInterests = [];
  List<String> userOccupation = [];
  List<InterestModel> generatedInterests = [];
  List<String> generatedInterestsText = [];
  Map<String, dynamic> repliedMessage = {};
  Map<String, dynamic> repliedroomMessage = {};
  String notifToken = '';
  String bioOfUser = '';
  int onVideoResume = 0;
  String videoId = '';
  int videoStartingPoint = 0;
  int videoEndingPoint = 3600;
  String avatarUrlOfUser =
      'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_960_720.png';
  String question = '';

  // get generateInterestsText => null;

  Future<int> loginUser(String email, String password, context) async {
    try {
      http.Response response =
          await http.post(Uri.parse('https://chat.etherapp.social/users/login'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode({'email': email, 'password': password}));
      if (response.statusCode == 200) {
        dynamic token = jsonDecode(response.body)['token'];
        String id = jsonDecode(response.body)['id'].toString();

        await storage.write(key: 'token', value: token);
        await storage.write(key: 'id', value: id);
        await readUser();
        await sendNotifToken();
        await getSelf();
        await getOccupation();
        await getInterest();
        await getSelfInterest();
        await scheduleMatches();

        await getMessage();
        await getContacts();
        await getRooms();

        Navigator.of(context).pushNamedAndRemoveUntil(
            '/contactsPage', (Route<dynamic> route) => false);
      }

      return (response.statusCode);
    } catch (e) {
      print(e);

      return (400);
    }
  }

  Future<int> signupUser(
      String email, String password, String username, context) async {
    try {
      http.Response response = await http.post(
        Uri.parse('https://chat.etherapp.social/users/signup'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
          'username': username,
        }),
      );

      if (response.statusCode == 200) {
        dynamic token = jsonDecode(response.body)['token'];
        String id = jsonDecode(response.body)['id'].toString();
        print('t0');
        await storage.write(key: 'token', value: token);
        print('t1');
        await storage.write(key: 'id', value: id);
        print('t2');
        await readUser();
        print('t3');
        await sendNotifToken();
        await getRooms();

        Navigator.of(context).pushNamedAndRemoveUntil(
            '/entryScreen', (Route<dynamic> route) => false);
      }

      return (response.statusCode);
    } catch (e) {
      print(e);
      return (400);
    }
  }

  String listFinder(String uuid, List messages) {
    var rplMsg = messages.singleWhere((element) => element['uuid'] == uuid,
        orElse: () => {'message': 'There is no evidence of this message'});
    return rplMsg['message'];
  }

  Future<void> readUser() async {
    await storage.read(key: 'token').then((value) {
      tokenOfUser = value.toString();
    });
    await storage.read(key: 'id').then((value) {
      idOfUser = int.parse(value.toString());
    });
    print(tokenOfUser);
    print(idOfUser);
  }

  Future<int> verification(context) async {
    try {
      await readUser();
      http.Response response = await http.get(
        Uri.parse('https://chat.etherapp.social/users/$idOfUser'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${tokenOfUser}',
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        await getSelf();
        await getOccupation();
        await getInterest();
        await getSelfInterest();
        await scheduleMatches();
        await getMessage();
        await getContacts();
        await getRooms();

        Navigator.of(context).pushNamedAndRemoveUntil(
            '/contactsPage', (Route<dynamic> route) => false);
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/welcome', (Route<dynamic> route) => false);
      }

      return response.statusCode;
    } catch (e) {
      print(e);
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/welcome', (Route<dynamic> route) => false);
      return (400);
    }
  }

  Future<dynamic> getSelf() async {
    http.Response response = await http.get(
      Uri.parse('https://chat.etherapp.social/users/${idOfUser}'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${tokenOfUser}',
      },
    );
    print(jsonDecode(response.body).toString());
    nameOfUser = jsonDecode(response.body)['username'];
    bioOfUser = jsonDecode(response.body)['bio'] == null
        ? 'No Bio'
        : jsonDecode(response.body)['bio'];
    avatarUrlOfUser = jsonDecode(response.body)['avatar_url'] == null
        ? 'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_960_720.png'
        : jsonDecode(response.body)['avatar_url'];
    karmaNumber = jsonDecode(response.body)['karma'];
    if (karmaNumber > 100) {
      karmaLevel = 'Intermediate';
      pointsForNextLevel = 500 - karmaNumber;
      level = 2;
    } else if (karmaNumber > 500) {
      karmaLevel = 'Professional';
      pointsForNextLevel = 1200 - karmaNumber;
      level = 3;
    } else if (karmaNumber > 1200) {
      karmaLevel = 'Expert';
      pointsForNextLevel = 3800 - karmaNumber;
      level = 4;
    } else if (karmaNumber > 3800) {
      karmaLevel = 'Master';
      pointsForNextLevel = 5000 - karmaNumber;
      level = 5;
    } else if (karmaNumber > 5000) {
      karmaLevel = 'Grand Master';
      pointsForNextLevel = 10000 - karmaNumber;
      level = 6;
    } else {
      karmaLevel = 'Novice';
      pointsForNextLevel = 100 - karmaNumber;
      level = 1;
    }
    notifyListeners();
  }

  Future<void> updateSelf(
      String newUsername, String newBio, String newAvatarUrl) async {
    try {
      await http.patch(
        Uri.parse('https://chat.etherapp.social/users/${idOfUser}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${tokenOfUser}',
        },
        body: jsonEncode(<String, String>{
          'username': newUsername,
          'bio': newBio,
          'avatar_url': newAvatarUrl,
        }),
      );
    } catch (e) {
      print(e);
    }
    await getSelf();
  }

  Future<void> updateKarma(int recieverId) async {
    try {
      await http.patch(
        Uri.parse(
            'https://chat.etherapp.social/karma/increasekarma/${idOfUser}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${tokenOfUser}',
        },
        body: jsonEncode(
          <String, int>{'contact_id': recieverId},
        ),
      );
      await getSelf();
    } catch (e) {
      print(e);
    }
  }

  Future<void> increasekarma() async {
    try {
      await http.patch(
          Uri.parse('https://chat.etherapp.social/karma/iKarma/${idOfUser}'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${tokenOfUser}',
          });
    } catch (e) {
      print(e);
    }
    await getSelf();
  }

  final List<InterestModel> interests = [];

  final List<ScreeningModel> screens = [
    ScreeningModel(
        textOfButton: 'Starting my own startup',
        iconFromModel: FontAwesomeIcons.dollarSign,
        screenedInterests: [
          InterestModel(
            textOfButton: 'Building products that people love',
          ),
          InterestModel(
            textOfButton: 'Building an MVP',
          ),
          InterestModel(
            textOfButton: 'Networking with like minded people',
          ),
          InterestModel(
            textOfButton: 'Learning best ways of marketing',
          ),
          InterestModel(
            textOfButton: 'Building an audience',
          ),
          InterestModel(
            textOfButton: 'Doing market research',
          ),
        ]),
    ScreeningModel(
        textOfButton: 'Learning to invest money',
        iconFromModel: FontAwesomeIcons.moneyBill,
        screenedInterests: [
          InterestModel(
            textOfButton: 'Studying indian markets',
          ),
          InterestModel(
            textOfButton: 'investing with fundamental analysis',
          ),
          InterestModel(
            textOfButton: 'Timing the market with technical analysis',
          ),
          InterestModel(
            textOfButton: 'Algorithimic trading',
          ),
          InterestModel(
            textOfButton: 'Creating wealth via investment',
          ),
        ]),
    ScreeningModel(
        textOfButton: 'Becoming a social media influencer',
        iconFromModel: FontAwesomeIcons.youtube,
        screenedInterests: [
          InterestModel(
            textOfButton: 'Making content for youtube',
          ),
          InterestModel(
            textOfButton: 'Writing blogs',
          ),
          InterestModel(
            textOfButton: 'Building an audience on linkldin',
          ),
          InterestModel(
            textOfButton: 'Twitter for life',
          ),
        ]),
    ScreeningModel(
        textOfButton: 'Automating mundane tasks with code',
        iconFromModel: FontAwesomeIcons.code,
        screenedInterests: [
          InterestModel(
            textOfButton: 'Practicing MERN stack',
          ),
          InterestModel(
            textOfButton: 'Acing my problem solving skills',
          ),
          InterestModel(
            textOfButton: 'Building apps',
          ),
          InterestModel(
            textOfButton: 'Making sense of data with data science and ML',
          ),
        ]),
    ScreeningModel(
        textOfButton: 'Figuring your way out by reading more',
        iconFromModel: FontAwesomeIcons.book,
        screenedInterests: [
          InterestModel(
            textOfButton: 'Self-help',
          ),
          InterestModel(
            textOfButton: 'Productivity',
          ),
          InterestModel(
            textOfButton: 'Meditation',
          ),
        ]),
    ScreeningModel(
        textOfButton: 'Struggling for inspiration for my next design',
        iconFromModel: FontAwesomeIcons.figma,
        screenedInterests: [
          InterestModel(
            textOfButton: 'UI/UX for apps',
          ),
          InterestModel(
            textOfButton: 'Graphic design',
          ),
        ]),
  ];

  void changeColorInterest(InterestModel karam) {
    karam.isSelected = true;
    notifyListeners();
  }

  void deleteColorInterest(InterestModel karam) {
    karam.isSelected = false;
    notifyListeners();
  }

  Future<void> updateToggle(List<String> karamList) async {
    try {
      await http.post(
        Uri.parse('https://chat.etherapp.social/interests/${idOfUser}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${tokenOfUser}',
        },
        body: jsonEncode(<String, List>{'interest': karamList}),
      );
    } catch (e) {
      print(e);
    }
  }

  void changeColorScreen(ScreeningModel screen) {
    screen.isSelected = true;
    notifyListeners();
  }

  void deleteScreen(ScreeningModel screen) {
    screen.isSelected = false;
    notifyListeners();
  }

  Future<void> addScreen(List<String> screenList) async {
    try {
      await http.post(
        Uri.parse('https://chat.etherapp.social/occupation/${idOfUser}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${tokenOfUser}',
        },
        body: jsonEncode(<String, List>{'occupation': screenList}),
      );
    } catch (e) {
      print(e);
    }
    await getOccupation();
  }

  Future<void> getInterest() async {
    http.Response response = await http.get(
      Uri.parse('https://chat.etherapp.social/interests/$idOfUser'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${tokenOfUser}',
      },
    );
    if (jsonDecode(response.body)['result'].length > 0) {
      userInterests.clear();
      for (var i = 0; i < jsonDecode(response.body)['result'].length; i++) {
        userInterests.add(jsonDecode(response.body)['result'][i]['interests']);
        firstinterestOfuser =
            jsonDecode(response.body)['result'][0]['interests'];
      }
    }

    notifyListeners();
  }

  // List<MessageModel> messages = [];

  List<Map<String, dynamic>> LastMessages = [];
  List<Map<String, dynamic>> messages = [];

  void setMessage(recieverId, message, senderId, isAdmin, isPhoto, imageUrl,
      uuid, isReply, repliedTo) {
    print('started Working');

    messages.add({
      'message': message,
      'recieverId': recieverId,
      'senderId': senderId,
      'isAdmin': isAdmin,
      'isPhoto': isPhoto,
      'imageUrl': imageUrl,
      'uuid': uuid,
      'isReply': isReply,
      'repliedTo': repliedTo
    });

    print('Added to list');
    LastMessages.add(isPhoto
        ? {'recieverId': recieverId, 'message': 'Photo', 'senderId': senderId}
        : {'recieverId': recieverId, 'message': message, 'senderId': senderId});
    notifyListeners();
    print('completed');
  }

  List<Map<String, dynamic>> lastRoomMessages = [];

  List<Map<String, dynamic>> roomMessages = [];
  void setRoomMessage(roomId, message, senderId, isAdmin, isPhoto, imageUrl,
      senderName, uuid, isReply, repliedTo) {
    roomMessages.add({
      'message': message,
      'roomId': roomId,
      'senderId': senderId,
      'isAdmin': isAdmin,
      'isPhoto': isPhoto,
      'imageUrl': imageUrl,
      'senderName': senderName,
      'uuid': uuid,
      'isReply': isReply,
      'repliedTo': repliedTo
    });
    print(roomMessages.toString() + 'testo1');
    lastRoomMessages.add(isPhoto
        ? {'roomId': roomId, 'message': 'Photo', 'senderId': senderId}
        : {'roomId': roomId, 'message': message, 'senderId': senderId});
    notifyListeners();
  }

  Future<void> getMessage() async {
    http.Response response = await http.get(
      Uri.parse('https://chat.etherapp.social/msg/${idOfUser}'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${tokenOfUser}',
      },
    );

    for (var i = 0; i < jsonDecode(response.body).length; i++) {
      String msgText = jsonDecode(response.body)[i]['content'].toString();
      int recieverId = jsonDecode(response.body)[i]['reciever_id'];
      int senderId = jsonDecode(response.body)[i]['sender_id'];
      bool isAdmin = jsonDecode(response.body)[i]['isAdmin'];
      bool isPhoto = jsonDecode(response.body)[i]['isPhoto'];
      String imageUrl = jsonDecode(response.body)[i]['imageUrl'];
      String uuid = jsonDecode(response.body)[i]['uuid'];

      bool isReply = jsonDecode(response.body)[i]['isReply'];
      String repliedTo = jsonDecode(response.body)[i]['repliedTo'];
      setMessage(recieverId, msgText, senderId, isAdmin, isPhoto, imageUrl,
          uuid, isReply, repliedTo);
    }
  }

  Future<void> getRoomMessage(int roomId) async {
    http.Response response = await http.get(
      Uri.parse('https://chat.etherapp.social/room/message/$roomId'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${tokenOfUser}',
      },
    );

    for (var i = 0; i < jsonDecode(response.body).length; i++) {
      String msgText = jsonDecode(response.body)[i]['content'].toString();
      int roomId = jsonDecode(response.body)[i]['room_id'];
      int senderId = jsonDecode(response.body)[i]['sender_id'];
      bool isAdmin = jsonDecode(response.body)[i]['is_admin'];
      bool isPhoto = jsonDecode(response.body)[i]['is_photo'];
      String imageUrl = jsonDecode(response.body)[i]['photo_url'];
      String senderName = jsonDecode(response.body)[i]['username'];
      String uuid = jsonDecode(response.body)[i]['uuid'];
      bool isReply = jsonDecode(response.body)[i]['is_reply'];
      String repliedTo = jsonDecode(response.body)[i]['replied_to'];

      setRoomMessage(roomId, msgText, senderId, isAdmin, isPhoto, imageUrl,
          senderName, uuid, isReply, repliedTo);
    }
  }

  late IO.Socket socket;
  void connect() {
    socket = IO.io("http://139.59.95.139:3000", //Ronit

        <String, dynamic>{
          "transports": ["websocket"],
          "autoConnect": false,
        });
    socket.connect();
    socket.emit("signin", idOfUser);
    for (var i = 0; i < roomId.length; i++) {
      socket.emit("room_entry", roomId[i]);
    }

    socket.onConnect((data) {
      print("Connected");
      socket.on("message", (msg) {
        setMessage(
            msg['reciever_id'],
            msg['message'],
            msg["sender_id"],
            false,
            msg['isPhoto'],
            msg['imageUrl'],
            msg['uuid'],
            msg['isReply'],
            msg['repliedTo']);
        print('Working fine Connect');
      });
      socket.on('room_message', (roomMsg) {
        //new
        print(roomMsg);
        setRoomMessage(
            roomMsg['room_id'],
            roomMsg['message'],
            roomMsg['sender_id'],
            false,
            roomMsg['isPhoto'],
            roomMsg['imageUrl'],
            roomMsg['sender_name'],
            roomMsg['uuid'],
            roomMsg['isReply'],
            roomMsg['repliedTo']);
        socket.on('delete_message', (data) {
          messages.removeWhere((element) => element['uuid'] == data['uuid']);
          notifyListeners();
        });
        socket.on('delete_room_message', (data) {
          roomMessages
              .removeWhere((element) => element['uuid'] == data['uuid']);
          notifyListeners();
        });
      });
    });
    print(socket.connected);
  }

  void sendRoomMessage(
    String message,
    int senderId,
    int roomId,
    bool isPhoto,
    String imageUrl,
    String senderName,
    String uuid,
    bool isReply,
    String repliedTo,
  ) {
    socket.emit("room_message", {
      "message": message,
      "sender_id": senderId,
      "room_id": roomId,
      "isPhoto": isPhoto,
      "imageUrl": imageUrl,
      "sender_name": senderName,
      'uuid': uuid,
      'isReply': isReply,
      'repliedTo': repliedTo
    });
    print(message);
  }

  void sendMessage(String message, int senderId, int recieverId, bool isPhoto,
      String imageUrl, String uuid, bool isReply, String repliedTo) {
    socket.emit("message", {
      "message": message,
      "sender_id": senderId,
      "reciever_id": recieverId,
      "isPhoto": isPhoto,
      "imageUrl": imageUrl,
      "uuid": uuid,
      "isReply": isReply,
      "repliedTo": repliedTo
    });
    print(message);
  }

  late ContactsModel selectedContact;

  void addToSelectedContact(
    name,
    imageUrl,
    lastMessage,
    contactId,
    aboutValue,
    karmaNumber,
    karmaLevel,
  ) {
    selectedContact = ContactsModel(
      imageUrl: imageUrl,
      lastMessage: lastMessage,
      name: name,
      contactId: contactId,
      aboutValue: aboutValue,
      karmaNumber: karmaNumber,
      level: karmaLevel,
    );
    getContactInterest(contactId);
  }

  late ChatRoomModel selectedRoom;
  void addToSelectedRoomContact(
    roomName,
    roomImageUrl,
    lastMessage,
    roomId,
  ) {
    selectedRoom = ChatRoomModel(
      imageUrl: roomImageUrl,
      lastMessage: lastMessage,
      name: roomName,
      roomId: roomId,
    );
    notifyListeners();
  }

  bool karmaCheck(int contactId) {
    List<Map<String, dynamic>> selectedMessage = [];
    for (var i = 0; i < messages.length; i++) {
      if (messages[i]['recieverId'] == contactId ||
          messages[i]['senderId'] == contactId) {
        selectedMessage.add(messages[i]);
      }
    }
    if (selectedMessage.length == 2) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> makeMatch() async {
    http.Response response = await http.post(
      Uri.parse('https://chat.etherapp.social/matches/${idOfUser}'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${tokenOfUser}',
      },
    );
    print('Match created');
    await getContacts();
  }

  List channelIds = [];
  Future<void> getContacts() async {
    contacts.clear();
    http.Response response = await http.get(
      Uri.parse('https://chat.etherapp.social/matches/${idOfUser}'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${tokenOfUser}',
      },
    );

    var insaan = jsonDecode(response.body)['contacts'];

    for (int i = 0; i < jsonDecode(response.body)['contacts'].length; i++) {
      contacts.add(ContactsModel(
        imageUrl: insaan[i]['avatar_url'] != null
            ? insaan[i]['avatar_url']
            : 'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_960_720.png',
        lastMessage: '',
        name: jsonDecode(response.body)['contacts'][i]['username'],
        contactId: jsonDecode(response.body)['contacts'][i]['contact_id'],
        aboutValue: insaan[i]['bio'] != null ? insaan[i]['bio'] : "No bio",
        karmaNumber: insaan[i]['karma'],
        level: levelEmitter(insaan[i]['karma']),
      ));
      channelIds.add(jsonDecode(response.body)['contacts'][i]['channel_id']);
    }
    print(4);
    notifyListeners();
  }

  List<ContactsModel> profileView = [];

  Future<void> getProfiles(int id) async {
    try {
      http.Response response = await http.get(
        Uri.parse('https://chat.etherapp.social/users/${id}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${tokenOfUser}',
        },
      );
      profileView.clear();
      profileView.add(ContactsModel(
        imageUrl: jsonDecode(response.body)['avatar_url'],
        lastMessage: '',
        name: jsonDecode(response.body)['username'],
        contactId: jsonDecode(response.body)['id'],
        aboutValue: jsonDecode(response.body)['bio'],
        karmaNumber: jsonDecode(response.body)['karma'],
        level: levelEmitter(jsonDecode(response.body)['karma']),
      ));
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  int levelEmitter(int karmaNumber) {
    if (karmaNumber > 100) {
      return 2;
    } else if (karmaNumber > 500) {
      return 3;
    } else if (karmaNumber > 1200) {
      return 4;
    } else if (karmaNumber > 3800) {
      return 5;
    } else if (karmaNumber > 5000) {
      return 6;
    } else {
      return 1;
    }
  }

  Future<void> updateMatchDate() async {
    await http.patch(
      Uri.parse('https://chat.etherapp.social/users/nextmatch/$idOfUser'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $tokenOfUser',
      },
    );
  }

  Future<void> scheduleMatches() async {
    http.Response response = await http.get(
      Uri.parse('https://chat.etherapp.social/users/nextmatch/$idOfUser'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $tokenOfUser',
      },
    );
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    DateTime fetchedDate = DateTime.parse(jsonDecode(response.body).toString());

    if (date == fetchedDate) {
      await makeMatch();
    } else if (date.isAfter(fetchedDate)) {
      await updateMatchDate();
      await makeMatch();
    } else {
      int difference = fetchedDate.difference(date).inDays;
      print('Next match in $difference days');
    }
  }

  Future<void> blockUser(int id) async {
    await http.patch(Uri.parse('https://chat.etherapp.social/users/block/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $tokenOfUser',
        },
        body: jsonEncode(<String, String>{'self_id': idOfUser.toString()}));
  }

  Future<void> interestSave(context) async {
    await getOccupation();
    await getInterest();
    await getSelf();
    await getSelfInterest();
    await scheduleMatches();
    await getMessage();
    await getRooms();
    Navigator.of(context).pushNamedAndRemoveUntil(
        '/contactsPage', (Route<dynamic> route) => false);
    notifyListeners();
  }

  Future<int> handleWithGoogle() async {
    try {
      final googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount == null) {
        return 400;
      }
      final googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User user = authResult.user!;
      print(user.email);
      print(user.displayName);
      uid = user.uid;
      googleUser = user;
      notifyListeners();
      return 200;
    } catch (e) {
      return 400;
    }
  }

  bool checkUserInterest(text) {
    if (generatedInterestsText.contains(text)) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> getContactInterest(int id) async {
    http.Response response = await http.get(
      Uri.parse('https://chat.etherapp.social/interests/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${tokenOfUser}',
      },
    );

    contactInterest.clear();
    contactInterest = jsonDecode(response.body)['result'];
    contactInterestString.clear();
    for (var i = 0; i < contactInterest.length; i++) {
      contactInterestString.add(contactInterest[i]['interests']);
    }
    contactInterestInterpolated = '';

    for (var i = 0; i < contactInterestString.length; i++) {
      contactInterestInterpolated += (contactInterestString[i] + ', ');
    }
  }

  Future<void> getSelfInterest() async {
    http.Response response = await http.get(
      Uri.parse('https://chat.etherapp.social/interests/$idOfUser'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${tokenOfUser}',
      },
    );

    selfInterest.clear();
    selfInterest = jsonDecode(response.body)['result'];
    selfInterestString.clear();
    for (var i = 0; i < selfInterest.length; i++) {
      selfInterestString.add(selfInterest[i]['interests']);
    }
    selfInterestInterpolated = '';

    for (var i = 0; i < selfInterestString.length; i++) {
      selfInterestInterpolated += (selfInterestString[i] + ', ');
    }
  }

  Future<void> getOTP(email) async {
    http.Response response =
        await http.post(Uri.parse('https://chat.etherapp.social/otp/'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({'email': email}));
    otp = jsonDecode(response.body).toString();
  }

  String getlastMessage(contactId) {
    if (LastMessages.length > 0) {
      var lastMessageMap = LastMessages.lastWhere(
          (element) => (element['recieverId'] == contactId ||
              element['senderId'] == contactId), orElse: () {
        return {'message': 'No messages'};
      });
      return lastMessageMap['message'];
    } else {
      return 'No messages';
    }
  }

  String getlastRoomMessage(roomId) {
    if (lastRoomMessages.length > 0) {
      var lastRoomMessageMap = lastRoomMessages
          .lastWhere((element) => (element['roomId'] == roomId), orElse: () {
        return {'message': 'No messages'};
      });

      return ("${lastRoomMessageMap['message']}");
    } else {
      return 'No messages';
    }
  }

  void signOutGoogle() async {
    if (uid.length > 0) {
      await googleSignIn.signOut();
      uid = '';
    }
    uid = '';
  }

  Future<void> getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    notifToken = token.toString();
  }

  Future<void> sendNotifToken() async {
    await getToken();
    // print(notifToken);
    http.Response response = await http.patch(
      Uri.parse('https://chat.etherapp.social/token/$idOfUser'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(<String, String>{'notif_token': notifToken}),
    );
    print(response.statusCode);
  }

  Future<void> deleteNotifToken() async {
    try {
      http.Response response = await http.delete(
        Uri.parse('https://chat.etherapp.social/token/$idOfUser'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> updatePoll(String answer) async {
    try {
      http.Response response = await http.get(
        Uri.parse('https://chat.etherapp.social/matches/$idOfUser'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${tokenOfUser}',
        },
      );
      question = jsonDecode(response.body)['question']['question'];
    } catch (e) {
      print(e);
    }
  }

  void changeIndicator() {
    showIndicator = !showIndicator;
    notifyListeners();
  }

  void changeIndicator1() {
    showIndicator1 = !showIndicator1;
    notifyListeners();
  }

  Future<String> checkLoginMethod(String email) async {
    http.Response response =
        await http.post(Uri.parse('https://chat.etherapp.social/users/login'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({'email': email, 'password': secretPwd}));

    if (response.statusCode == 200) {
      return 'Google';
    } else {
      return 'Email';
    }
  }

  Future<int> changePassword(email, newPassword) async {
    http.Response response = await http.patch(
        Uri.parse('https://chat.etherapp.social/secret/changepswd'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'email': email, 'newPassword': newPassword}));
    return response.statusCode;
  }

  Future<void> getOccupation() async {
    http.Response response = await http.get(
      Uri.parse('https://chat.etherapp.social/occupation/$idOfUser'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${tokenOfUser}',
      },
    );

    if (jsonDecode(response.body).length > 0) {
      userOccupation.clear();
      roomId.clear();
      for (var i = 0; i < jsonDecode(response.body).length; i++) {
        userOccupation.add(jsonDecode(response.body)[i]['content']);
        roomId.add(jsonDecode(response.body)[i]['room_id']);
      }
    }

    notifyListeners();
  }

  Future<bool> backPressedOnInterestEdit(context) async {
    generatedInterests.clear();
    generatedInterestsText.clear();
    Navigator.pushNamedAndRemoveUntil(
        context, '/contactsPage', (route) => false);
    return true;
  }

  bool occupationCheck(String occupation) {
    if (userOccupation.contains(occupation)) {
      return true;
    } else {
      return false;
    }
  }

  void generateListromOccupation() {
    for (int i = 0; i < userOccupation.length; i++) {
      for (int j = 0; j < screens.length; j++) {
        if (userOccupation[i] == screens[j].textOfButton) {
          for (int k = 0; k < screens[j].screenedInterests.length; k++) {
            generatedInterests.add(screens[j].screenedInterests[k]);
          }
        }
      }
    }
  }

  void generateInterestText() {
    for (var i = 0; i < generatedInterests.length; i++) {
      if (userInterests.contains(generatedInterests[i].textOfButton)) {
        generatedInterestsText.add(generatedInterests[i].textOfButton);
      }
    }
    print(generatedInterestsText);
  }

  Future<void> getRooms() async {
    try {
      http.Response response = await http.get(
        Uri.parse('https://chat.etherapp.social/room/$idOfUser'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${tokenOfUser}',
        },
      );
      chatRooms.clear();
      for (var i = 0; i < jsonDecode(response.body).length; i++) {
        chatRooms.add(
          ChatRoomModel(
            imageUrl: jsonDecode(response.body)[i]['room_avatar_url'],
            lastMessage: '',
            name: jsonDecode(response.body)[i]['room_name'],
            roomId: jsonDecode(response.body)[i]['room_id'],
          ),
        );
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future<String> getFeedCards() async {
    try {
      http.Response response = await http.get(
        Uri.parse('https://chat.etherapp.social/card/$idOfUser'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${tokenOfUser}',
        },
      );
      feedCards.clear();
      print(jsonDecode(response.body).toString() + 'apple');
      for (var i = 0; i < jsonDecode(response.body).length; i++) {
        feedCards.add(
          FeedCard(
            id: jsonDecode(response.body)[i]['id'],
            heading: jsonDecode(response.body)[i]['heading'],
            isVideo: jsonDecode(response.body)[i]['is_video'],
            imageUrl: jsonDecode(response.body)[i]['image_url'],
            content: jsonDecode(response.body)[i]['content'],
            desco: jsonDecode(response.body)[i]['desco'],
            occupationId: jsonDecode(response.body)[i]['occupation_id'],
            startAt: jsonDecode(response.body)[i]['start_at'],
            endAt: jsonDecode(response.body)[i]['end_at'],
          ),
        );
      }
      feedCards.shuffle();
    } catch (e) {
      print(e);
    }
    notifyListeners();
    return 'sdsdsdsd';
  }

  Future<void> deleteMessage(String uuid, int recieverId) async {
    messages.removeWhere((element) => element['uuid'] == uuid);
    try {
      await http.delete(
        Uri.parse('https://chat.etherapp.social/msg/$uuid'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${tokenOfUser}',
        },
      );
    } catch (e) {
      print(e);
    }
    socket.emit('delete_message', {"uuid": uuid, "recieverId": recieverId});
    print('sent emit request');
    notifyListeners();
  }

  Future<void> deleteRoomMessage(String uuid, int roomId) async {
    roomMessages.removeWhere((element) => element['uuid'] == uuid);
    try {
      await http.delete(
        Uri.parse('https://chat.etherapp.social/room/$uuid'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${tokenOfUser}',
        },
      );
    } catch (e) {
      print(e);
    }
    socket.emit('delete_room_message', {"uuid": uuid, "roomId": roomId});
    print('sent emit request');
    notifyListeners();
  }

  Future<bool> onVideoResumeAssign(int timestamp) async {
    onVideoResume = timestamp;
    notifyListeners();
    print(timestamp);
    print(onVideoResume);

    return true;
  }

  firstCharacterUpper(String text) {
    List arrayPieces = [];

    String outPut = '';

    text.split(' ').forEach((sepparetedWord) {
      arrayPieces.add(sepparetedWord);
    });

    arrayPieces.forEach((word) {
      word =
          "${word[0].toString().toUpperCase()}${word.toString().substring(1)} ";
      outPut += word;
    });

    return outPut;
  }

  bool isBookMark(int cardId) {
    try {
      var entry = bookmarks.any((element) => element['card_id'] == cardId);
      print(entry);
      return entry;
    } catch (e) {
      print(e);
      return false;
    }
  }

  String findNote(int cardId) {
    var bookmark = bookmarks
        .singleWhere((element) => element['card_id'] == cardId, orElse: () {
      return {'notes': 'no notes'};
    });
    print(bookmark['notes'].toString() + 'fgggfgfg');
    return bookmark['notes'];
  }

  List<Map<String, dynamic>> bookmarks = [];
  Future<void> getBookMark() async {
    try {
      http.Response response = await http.get(
        Uri.parse('https://chat.etherapp.social/bookmark/get/$idOfUser'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${tokenOfUser}',
        },
      );
      bookmarks.clear;
      bookmarkedFeedCards.clear();
      for (var i = 0; i < jsonDecode(response.body).length; i++) {
        bookmarks.add({
          "card_id": jsonDecode(response.body)[i]['card_id'],
          "notes": jsonDecode(response.body)[i]['notes'],
          "heading": jsonDecode(response.body)[i]['heading'],
          "content": jsonDecode(response.body)[i]['content'],
          "is_admin": jsonDecode(response.body)[i]['is_admin'],
          "occupation_id": jsonDecode(response.body)[i]['occupation_id'],
          "start_at": jsonDecode(response.body)[i]['start_at'],
          "end_at": jsonDecode(response.body)[i]['end_at'],
        });
        bookmarkedFeedCards.add(
          FeedCard(
            id: jsonDecode(response.body)[i]['card_id'],
            heading: jsonDecode(response.body)[i]['heading'],
            isVideo: true,
            imageUrl: 'nopes',
            content: jsonDecode(response.body)[i]['content'],
            desco: 'No Desc',
            occupationId: jsonDecode(response.body)[i]['occupation_id'],
            startAt: jsonDecode(response.body)[i]['start_at'],
            endAt: jsonDecode(response.body)[i]['end_at'],
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> postBookmark(int cardId, String notes) async {
    try {
      print('initiated');
      http.Response response = await http.post(
        Uri.parse('https://chat.etherapp.social/bookmark/post/${cardId}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${tokenOfUser}',
        },
        body: jsonEncode({
          'user_id': idOfUser,
          'notes': notes,
        }),
      );
      print('finished');
    } catch (e) {
      print(e);
    }
    await getBookMark();
    notifyListeners();
  }

  List<int> likedCardsId = [];
  Future<void> getLikedCards() async {
    try {
      http.Response response = await http.get(
        Uri.parse('https://chat.etherapp.social/likes/get/$idOfUser'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${tokenOfUser}',
        },
      );
      likedCardsId.clear;
      for (var i = 0; i < jsonDecode(response.body).length; i++) {
        likedCardsId.add(jsonDecode(response.body)[i]['card_id']);
      }
    } catch (e) {
      print(e);
    }
  }

  bool isLiked(cardId) {
    return likedCardsId.contains(cardId);
  }

  Future<void> interactWithLike(cardId) async {
    print('interact called');
    if (likedCardsId.contains(cardId)) {
      await http.delete(
          Uri.parse('https://chat.etherapp.social/likes/delete/$cardId'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${tokenOfUser}',
          },
          body: jsonEncode({'user_id': idOfUser}));
      likedCardsId.remove(cardId);
    } else {
      await http.post(
        Uri.parse('https://chat.etherapp.social/post/${cardId}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${tokenOfUser}',
        },
        body: jsonEncode({
          'user_id': idOfUser,
        }),
      );
      likedCardsId.add(cardId);
    }
  }

  List<Map<String, dynamic>> cardNotes = [];
  Future<void> getCardNotes(cardId) async {
    try {
      http.Response response = await http.get(
        Uri.parse('https://chat.etherapp.social/bookmark/geto/$cardId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${tokenOfUser}',
        },
      );
      cardNotes.clear();

      for (var i = 0; i < jsonDecode(response.body).length; i++) {
        cardNotes.add({
          "user_id": jsonDecode(response.body)[i]['user_id'],
          "notes": jsonDecode(response.body)[i]['notes'],
          "username": jsonDecode(response.body)[i]['username'],
          "avatar_url": jsonDecode(response.body)[i]['avatar_url'],
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
