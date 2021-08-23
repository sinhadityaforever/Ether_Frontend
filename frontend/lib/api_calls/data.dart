import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/models/feed_card.dart';
import 'package:frontend/models/group_chat.dart';
import 'package:frontend/models/option.dart';
import 'package:frontend/models/room_message_model.dart';
import 'package:frontend/models/screening.dart';
import '../models/interestModel.dart';
import 'package:frontend/models/contacts_model.dart';
import '../models/messageModel.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:uuid/uuid.dart';

class Data extends ChangeNotifier {
  String ip = '192.168.0.194';
  String uid = '';
  late final User googleUser;
  var signupEmail;
  var otp;
  bool showIndicator = false;
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
  List<RoomMessageModel> roomMessages = [];
  List<int> roomId = [];
  final List<int> contactId = [];
  List<String> userInterests = [];
  List<String> userOccupation = [];
  List<InterestModel> generatedInterests = [];
  List<String> generatedInterestsText = [];
  String notifToken = '';
  String bioOfUser = '';
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
          body: jsonEncode(
              {'email': email, 'password': password, 'username': username}));

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
        print('t4');

        Navigator.of(context).pushNamedAndRemoveUntil(
            '/entryScreen', (Route<dynamic> route) => false);
      }

      return (response.statusCode);
    } catch (e) {
      print(e);
      return (400);
    }
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
            textOfButton: 'Learning best ways of marketting',
          ),
          InterestModel(
            textOfButton: 'Building an audience',
          ),
          InterestModel(
            textOfButton: 'Doing market rescearch',
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
    // messages.add(
    //   MessageModel(
    //     message: message,
    //     recieverId: recieverId,
    //     senderId: senderId,
    //     isAdmin: isAdmin,
    //     isPhoto: isPhoto,
    //     imageUrl: imageUrl,
    //   ),
    // );
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

  void setRoomMessage(
      roomId, message, senderId, isAdmin, isPhoto, imageUrl, senderName) {
    roomMessages.add(
      RoomMessageModel(
        message: message,
        roomId: roomId,
        senderId: senderId,
        isAdmin: isAdmin,
        isPhoto: isPhoto,
        imageUrl: imageUrl,
        senderName: senderName,
      ),
    );
    notifyListeners();
  }

  Future<void> getMessage() async {
    http.Response response = await http.get(
      Uri.parse('http://$ip:5000/msg/${idOfUser}'),
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
      bool isReply = jsonDecode(response.body)[i]['is_reply'];
      String repliedTo = jsonDecode(response.body)[i]['replied_to'];
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

      setRoomMessage(
        roomId,
        msgText,
        senderId,
        isAdmin,
        isPhoto,
        imageUrl,
        senderName,
      );
    }
  }

  late IO.Socket socket;
  void connect() {
    socket = IO.io("http://${ip}:3000", //Ronit

        <String, dynamic>{
          "transports": ["websocket"],
          "autoConnect": false,
        });
    socket.connect();
    socket.emit("signin", idOfUser);
    socket.emit("room_entry", roomId[0]); //new
    socket.emit("room_entry", roomId[1]); //new
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
            msg['uid'],
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
        );
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
  ) {
    print(roomId.toString() +
        "fdfdfdfdfdfedfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfd");
    socket.emit("room_message", {
      "message": message,
      "sender_id": senderId,
      "room_id": roomId,
      "isPhoto": isPhoto,
      "imageUrl": imageUrl,
      "sender_name": senderName,
    });
    print('working fine0123 sendRoomMessage');
  }

  void sendMessage(String message, int senderId, int recieverId, bool isPhoto,
      String imageUrl, String uuid, bool isReply, String repliedTo) {
    // String uuid = Uuid().v4();
    print('working fine sendMessage');
    socket.emit("message", {
      "message": message,
      "sender_id": senderId,
      "reciever_id": recieverId,
      "isPhoto": isPhoto,
      "imageUrl": imageUrl,
      "uuid": uuid,
      "is_reply": isReply,
      "replied_to": repliedTo
    });
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

  void interestSave(context) async {
    await getOccupation();
    await getInterest();
    await getSelf();
    await getSelfInterest();
    await scheduleMatches();
    await getMessage();
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
    print(jsonDecode(response.body));
    contactInterest.clear();
    contactInterest = jsonDecode(response.body)['result'];
    contactInterestString.clear();
    for (var i = 0; i < contactInterest.length; i++) {
      contactInterestString.add(contactInterest[i]['interests']);
    }
    contactInterestInterpolated = '';
    print(contactInterestString);
    for (var i = 0; i < contactInterestString.length; i++) {
      contactInterestInterpolated += (contactInterestString[i] + ', ');
    }
    print(contactInterestInterpolated);
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
    print(jsonDecode(response.body));
    selfInterest.clear();
    selfInterest = jsonDecode(response.body)['result'];
    selfInterestString.clear();
    for (var i = 0; i < selfInterest.length; i++) {
      selfInterestString.add(selfInterest[i]['interests']);
    }
    selfInterestInterpolated = '';
    print(selfInterestString);
    for (var i = 0; i < selfInterestString.length; i++) {
      selfInterestInterpolated += (selfInterestString[i] + ', ');
    }
    print(selfInterestInterpolated);
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
      for (var i = 0; i < jsonDecode(response.body).length; i++) {
        print(jsonDecode(response.body)[i]['room_id'].toString() + "fuck ya");
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

  Future<void> getFeedCards() async {
    try {
      http.Response response = await http.get(
        Uri.parse('http://$ip:5000/card/$idOfUser'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${tokenOfUser}',
        },
      );
      feedCards.clear();
      for (var i = 0; i < jsonDecode(response.body).length; i++) {
        feedCards.add(
          FeedCard(
            id: jsonDecode(response.body)[i]['id'],
            heading: jsonDecode(response.body)[i]['heading'],
            isQuestion: jsonDecode(response.body)[i]['is_question'],
            imageUrl: jsonDecode(response.body)[i]['image_url'],
            content: jsonDecode(response.body)[i]['content'],
          ),
        );
      }
      feedCards.shuffle();
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  List<Optionsfero> options = [];
  Future<void> getOptions(int questionId) async {
    try {
      http.Response response = await http.get(
        Uri.parse('http://$ip:5000/card/options/$questionId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${tokenOfUser}',
        },
      );
      for (var i = 0; i < jsonDecode(response.body).length; i++) {
        options.add(
          Optionsfero(
            questionId: questionId,
            option: jsonDecode(response.body)[i]['option'],
            isAnswer: jsonDecode(response.body)[i]['is_answer'],
          ),
        );
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future<void> deleteMessage(String uuid) async {
    messages.removeWhere((element) => element['uuid'] == uuid);
    try {
      await http.delete(
        Uri.parse('http://$ip:5000/msg/$uuid'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${tokenOfUser}',
        },
      );
    } catch (e) {
      print(e);
      ;
    }
    notifyListeners();
  }

  // void checkAnswer(Optionsfero option, bool isAnswer) {
  //   if (isAnswer == true) {
  //     option.isAnswer = 1;
  //   } else {
  //     option.isAnswer = 2;
  //   }
  //   notifyListeners();
  // }
}
