import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/api_calls/data.dart';
import 'package:frontend/widgets/negative_popup.dart';
import 'package:frontend/widgets/popup_screen.dart';
import 'package:frontend/widgets/room_chat_bubble.dart';
import 'package:frontend/widgets/rounded_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uuid/uuid.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:swipe_to/swipe_to.dart';

class ChatRoomPageArguments {
  final String roomAvatarUrl;
  final String roomName;
  final int roomId;

  ChatRoomPageArguments({
    required this.roomAvatarUrl,
    required this.roomName,
    required this.roomId,
  });
}

class RoomChatPage extends StatefulWidget {
  @override
  _RoomChatPageState createState() => _RoomChatPageState();
}

class _RoomChatPageState extends State<RoomChatPage> {
  bool isReplying = false;
  final focusNode = FocusNode();
  ScrollController _controller1 = ScrollController();
  final storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    Timer(
        Duration(seconds: 0),
        () => _controller1
            .jumpTo(_controller1.position.maxScrollExtent + 10000.h));
    super.initState();
  }

  void replyMessage(message) {
    setState(() {
      Provider.of<Data>(context, listen: false).repliedroomMessage = message;
    });
  }

  void cancelReplyMessage(message) {
    setState(() {
      Provider.of<Data>(context, listen: false).repliedroomMessage = {};
      isReplying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    int id = Provider.of<Data>(context, listen: false).idOfUser;
    final args =
        ModalRoute.of(context)!.settings.arguments as ChatRoomPageArguments;
    String messageInField = '';
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                // ignore: deprecated_member_use
                FlatButton(
                  onPressed: () {
                    print('I got tapped');
                  },
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(args.roomAvatarUrl),
                        radius: 24,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(args.roomName),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              dragStartBehavior: DragStartBehavior.down,
              shrinkWrap: false,
              controller: _controller1,
              itemBuilder: (context, index) {
                final message = Provider.of<Data>(context).roomMessages[index];

                if (message['roomId'] == args.roomId) {
                  return SwipeTo(
                    onRightSwipe: () {
                      setState(() {
                        isReplying = true;
                        replyMessage(message);
                        focusNode.requestFocus();
                        print(
                            Provider.of<Data>(context).repliedMessage['uuid']);
                      });
                    },
                    onLeftSwipe: () {
                      setState(() {
                        if (message['senderId'] ==
                                Provider.of<Data>(context, listen: false)
                                    .idOfUser &&
                            message['isAdmin'] == false) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => NegativePopup(
                              popuptext:
                                  'Do you want to remove the evidence of this message 🧐',
                              onPresseedPopup: () {
                                setState(() {
                                  Provider.of<Data>(context, listen: false)
                                      .deleteRoomMessage(
                                          message['uuid'], args.roomId);
                                  Navigator.pop(context);
                                });
                              },
                              negativeTitle: 'Delete Message',
                              action: 'Delete',
                            ),
                          );
                        }
                      });
                    },
                    child: RoomChatBubble(
                      texto: message['message'],
                      isMe: message['senderId'] ==
                              Provider.of<Data>(context).idOfUser
                          ? true
                          : false,
                      isAdmin: message['isAdmin'],
                      isPhoto: message['isPhoto'],
                      imageUrl: message['imageUrl'],
                      senderName: message['senderName'],
                      isReply: message['isReply'],
                      replyTo: message['repliedTo'],
                      roomuuid: message['uuid'],
                      // showProfileCallback: Navigator.pushNamed(
                      //   context,
                      //   '//roomProfileView',
                      //   arguments: RoomProfileViewArgs(
                      //     name: Provider.of<Data>(context, listen: false)
                      //         .profileView[0]
                      //         .name,
                      //     imageUrl: Provider.of<Data>(context, listen: false)
                      //         .profileView[0]
                      //         .imageUrl,
                      //     aboutValue: Provider.of<Data>(context, listen: false)
                      //         .profileView[0]
                      //         .aboutValue,
                      //     interestValue: Provider.of<Data>(context, listen: false)
                      //         .contactInterestInterpolated,
                      //     level: Provider.of<Data>(context, listen: false)
                      //         .profileView[0]
                      //         .level,
                      //     karmaNumber: Provider.of<Data>(context, listen: false)
                      //         .profileView[0]
                      //         .karmaNumber,
                      //   ),
                      // ),
                    ),
                  );
                } else {
                  return SizedBox(
                    height: 0,
                  );
                }
              },
              itemCount: Provider.of<Data>(context).roomMessages.length,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        if (isReplying == true)
                          Row(
                            children: [
                              InkWell(
                                  child: Icon(Icons.close),
                                  onTap: () {
                                    setState(() {
                                      cancelReplyMessage(
                                        Provider.of<Data>(context,
                                                listen: false)
                                            .repliedroomMessage,
                                      );
                                    });
                                  }),
                              RoomChatBubble(
                                texto: Provider.of<Data>(context, listen: false)
                                            .repliedroomMessage['message']
                                            .length >
                                        25
                                    ? Provider.of<Data>(context, listen: false)
                                            .repliedroomMessage['message']
                                            .substring(0, 25) +
                                        '....'
                                    : Provider.of<Data>(context, listen: false)
                                        .repliedroomMessage['message'],
                                isMe: Provider.of<Data>(context, listen: false)
                                            .repliedroomMessage['senderId'] ==
                                        Provider.of<Data>(context,
                                                listen: false)
                                            .idOfUser
                                    ? true
                                    : false,
                                isAdmin:
                                    Provider.of<Data>(context, listen: false)
                                        .repliedroomMessage['isAdmin'],
                                isPhoto:
                                    Provider.of<Data>(context, listen: false)
                                        .repliedroomMessage['isPhoto'],
                                imageUrl:
                                    Provider.of<Data>(context, listen: false)
                                        .repliedroomMessage['imageUrl'],
                                roomuuid:
                                    Provider.of<Data>(context, listen: false)
                                        .repliedroomMessage['uuid'],
                                isReply:
                                    Provider.of<Data>(context, listen: false)
                                        .repliedroomMessage['isReply'],
                                replyTo:
                                    Provider.of<Data>(context, listen: false)
                                        .repliedroomMessage['repliedTo'],
                                senderName:
                                    Provider.of<Data>(context, listen: false)
                                        .repliedroomMessage['senderName'],
                              ),
                            ],
                          )
                        else
                          SizedBox(
                            height: 0,
                          ),
                        TextFormField(
                          controller: _controller,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xFF2A2F32),
                            hintText: 'Type a message',
                            hintStyle: TextStyle(
                              color: Color(0xFFA9AAAC),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                            suffixIcon: IconButton(
                              color: Color(0xFFEB1555),
                              icon: Icon(Icons.send),
                              onPressed: () {
                                String uuid = Uuid().v4();
                                setState(() {
                                  if (isReplying == false) {
                                    if (messageInField != '') {
                                      Provider.of<Data>(context, listen: false)
                                          .setRoomMessage(
                                        args.roomId,
                                        messageInField,
                                        Provider.of<Data>(context,
                                                listen: false)
                                            .idOfUser,
                                        false,
                                        false,
                                        'no image',
                                        Provider.of<Data>(context,
                                                listen: false)
                                            .nameOfUser,
                                        uuid,
                                        false,
                                        'no_reply',
                                      );
                                      _controller1.animateTo(
                                        _controller1.position.maxScrollExtent +
                                            100.h,
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeOut,
                                      );

                                      Provider.of<Data>(context, listen: false)
                                          .sendRoomMessage(
                                        messageInField,
                                        Provider.of<Data>(context,
                                                listen: false)
                                            .idOfUser,
                                        args.roomId,
                                        false,
                                        'no image',
                                        Provider.of<Data>(context,
                                                listen: false)
                                            .nameOfUser,
                                        uuid,
                                        false,
                                        'no_reply',
                                      );
                                      cancelReplyMessage(
                                        Provider.of<Data>(context,
                                                listen: false)
                                            .repliedroomMessage,
                                      );
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            Popup(
                                          popupTitle: "Type something bruh..😑",
                                          popuptext: "😶",
                                        ),
                                      );
                                    }
                                  } else {
                                    if (messageInField != '') {
                                      Provider.of<Data>(context, listen: false)
                                          .setRoomMessage(
                                        args.roomId,
                                        messageInField,
                                        Provider.of<Data>(context,
                                                listen: false)
                                            .idOfUser,
                                        false,
                                        false,
                                        'no image',
                                        Provider.of<Data>(context,
                                                listen: false)
                                            .nameOfUser,
                                        uuid,
                                        true,
                                        Provider.of<Data>(context,
                                                listen: false)
                                            .repliedroomMessage['uuid'],
                                      );
                                      _controller1.animateTo(
                                        _controller1.position.maxScrollExtent +
                                            100.h,
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeOut,
                                      );

                                      Provider.of<Data>(context, listen: false)
                                          .sendRoomMessage(
                                        messageInField,
                                        Provider.of<Data>(context,
                                                listen: false)
                                            .idOfUser,
                                        args.roomId,
                                        false,
                                        'no image',
                                        Provider.of<Data>(context,
                                                listen: false)
                                            .nameOfUser,
                                        uuid,
                                        true,
                                        Provider.of<Data>(context,
                                                listen: false)
                                            .repliedroomMessage['uuid'],
                                      );
                                      cancelReplyMessage(
                                        Provider.of<Data>(context,
                                                listen: false)
                                            .repliedroomMessage,
                                      );
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            Popup(
                                          popupTitle: "Type something bruh..😑",
                                          popuptext: "😶",
                                        ),
                                      );
                                    }
                                  }
                                  _controller.clear();
                                });
                              },
                            ),
                          ),
                          onChanged: (value) {
                            messageInField = value;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () async {
                  String imageUrlChanged = 'no image';

                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => SingleChildScrollView(
                      child: Container(
                        color: Color(0xFF090E11),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.r),
                              topRight: Radius.circular(20.r),
                            ),
                            color: Color(0xFF11163B),
                          ),
                          height: 250.h,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Text(
                                  'Choose a method',
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    color: Color(0xFFEB1555),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // ignore: deprecated_member_use
                                  FlatButton.icon(
                                    onPressed: () async {
                                      Provider.of<Data>(context, listen: false)
                                          .changeIndicator();
                                      final pickedFile =
                                          await _picker.pickImage(
                                        source: ImageSource.camera,
                                        imageQuality: 30,
                                      );
                                      if (pickedFile == null) {
                                        Provider.of<Data>(context,
                                                listen: false)
                                            .changeIndicator();
                                      }

                                      var snapshot = await storage
                                          .ref()
                                          .child(
                                            'messagePicture/${id}+${DateTime.now().millisecondsSinceEpoch}',
                                          )
                                          .putFile(File(pickedFile!.path));

                                      imageUrlChanged =
                                          await snapshot.ref.getDownloadURL();
                                      Provider.of<Data>(context, listen: false)
                                          .changeIndicator();
                                    },
                                    icon: Icon(
                                      Icons.camera,
                                    ),
                                    label: Text('Camera'),
                                  ),
                                  SizedBox(
                                    width: 50.w,
                                  ),
                                  // ignore: deprecated_member_use
                                  FlatButton.icon(
                                    onPressed: () async {
                                      Provider.of<Data>(context, listen: false)
                                          .changeIndicator();
                                      final pickedFile =
                                          await _picker.pickImage(
                                        source: ImageSource.gallery,
                                        imageQuality: 30,
                                      );
                                      if (pickedFile == null) {
                                        Provider.of<Data>(context,
                                                listen: false)
                                            .changeIndicator();
                                      }

                                      var snapshot = await storage
                                          .ref()
                                          .child(
                                            'messagePicture/${id}+${DateTime.now().millisecondsSinceEpoch}',
                                          )
                                          .putFile(File(pickedFile!.path));

                                      imageUrlChanged =
                                          await snapshot.ref.getDownloadURL();
                                      Provider.of<Data>(context, listen: false)
                                          .changeIndicator();
                                    },
                                    icon: Icon(
                                      Icons.image,
                                    ),
                                    label: Text('Gallery'),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              RoundedButton(
                                colorOfButton: Color(0xFFEB1555),
                                onPressedRoundButton: () async {
                                  String uuidImage = Uuid().v4();
                                  if (imageUrlChanged == 'no image') {
                                    Provider.of<Data>(context, listen: false)
                                        .showIndicator = false;
                                  } else {
                                    if (isReplying == false) {
                                      Provider.of<Data>(context, listen: false)
                                          .setRoomMessage(
                                        args.roomId,
                                        'image',
                                        Provider.of<Data>(context,
                                                listen: false)
                                            .idOfUser,
                                        false,
                                        true,
                                        imageUrlChanged,
                                        Provider.of<Data>(context,
                                                listen: false)
                                            .nameOfUser,
                                        uuidImage,
                                        false,
                                        'no_reply',
                                      );
                                      print(imageUrlChanged + '7');
                                      _controller1.animateTo(
                                        _controller1.position.maxScrollExtent +
                                            48.h,
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeOut,
                                      );
                                      _controller.clear();

                                      Provider.of<Data>(context, listen: false)
                                          .sendRoomMessage(
                                        'image',
                                        Provider.of<Data>(context,
                                                listen: false)
                                            .idOfUser,
                                        args.roomId,
                                        true,
                                        imageUrlChanged,
                                        Provider.of<Data>(context,
                                                listen: false)
                                            .nameOfUser,
                                        uuidImage,
                                        false,
                                        'no_reply',
                                      );
                                      cancelReplyMessage(
                                        Provider.of<Data>(context,
                                                listen: false)
                                            .repliedroomMessage,
                                      );
                                    } else {
                                      Provider.of<Data>(context, listen: false)
                                          .setRoomMessage(
                                        args.roomId,
                                        'image',
                                        Provider.of<Data>(context,
                                                listen: false)
                                            .idOfUser,
                                        false,
                                        true,
                                        imageUrlChanged,
                                        Provider.of<Data>(context,
                                                listen: false)
                                            .nameOfUser,
                                        uuidImage,
                                        false,
                                        'no_reply',
                                      );
                                      print(imageUrlChanged + '7');
                                      _controller1.animateTo(
                                        _controller1.position.maxScrollExtent +
                                            48.h,
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeOut,
                                      );
                                      _controller.clear();

                                      Provider.of<Data>(context, listen: false)
                                          .sendRoomMessage(
                                        'image',
                                        Provider.of<Data>(context,
                                                listen: false)
                                            .idOfUser,
                                        args.roomId,
                                        true,
                                        imageUrlChanged,
                                        Provider.of<Data>(context,
                                                listen: false)
                                            .nameOfUser,
                                        uuidImage,
                                        true,
                                        Provider.of<Data>(context,
                                                listen: false)
                                            .repliedroomMessage['uuid'],
                                      );
                                      cancelReplyMessage(
                                        Provider.of<Data>(context,
                                                listen: false)
                                            .repliedMessage,
                                      );
                                    }
                                  }
                                  Navigator.pop(context);
                                },
                                textOfButton: 'SEND',
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                icon: Icon(
                  FontAwesomeIcons.paperclip,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
