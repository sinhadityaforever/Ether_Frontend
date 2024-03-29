import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/api_calls/data.dart';
import 'package:frontend/screens/profile_view_page.dart';
import 'package:frontend/widgets/negative_popup.dart';
import 'package:frontend/widgets/popup_screen.dart';
import 'package:frontend/widgets/rounded_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../widgets/chat_bubble.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uuid/uuid.dart';

class ChatPageArguments {
  final String avatarUrl;
  final String recieverName;
  final int recieverId;

  ChatPageArguments({
    required this.avatarUrl,
    required this.recieverName,
    required this.recieverId,
  });
}

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool isReplying = false;
  final focusNode = FocusNode();
  ScrollController _controller1 = ScrollController();
  final storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    Provider.of<Data>(context, listen: false).connect();
    Timer(
      Duration(seconds: 0),
      () =>
          _controller1.jumpTo(_controller1.position.maxScrollExtent + 10000.h),
    );
    super.initState();
  }

  void replyMessage(message) {
    setState(() {
      Provider.of<Data>(context, listen: false).repliedMessage = message;
    });
  }

  void cancelReplyMessage(message) {
    setState(() {
      Provider.of<Data>(context, listen: false).repliedMessage = {};
      isReplying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    int id = Provider.of<Data>(context, listen: false).idOfUser;
    final args =
        ModalRoute.of(context)!.settings.arguments as ChatPageArguments;
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
                    Navigator.pushNamed(
                      context,
                      '/profileView',
                      arguments: ProfileViewArgs(
                        name: Provider.of<Data>(context, listen: false)
                            .selectedContact
                            .name,
                        imageUrl: Provider.of<Data>(context, listen: false)
                            .selectedContact
                            .imageUrl,
                        aboutValue: Provider.of<Data>(context, listen: false)
                            .selectedContact
                            .aboutValue,
                        interestValue: Provider.of<Data>(context, listen: false)
                            .contactInterestInterpolated,
                        level: Provider.of<Data>(context, listen: false)
                            .selectedContact
                            .level,
                        karmaNumber: Provider.of<Data>(context, listen: false)
                            .selectedContact
                            .karmaNumber,
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(args.avatarUrl),
                        radius: 24,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(args.recieverName),
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
                final message = Provider.of<Data>(context).messages[index];
                print(message);
                if (message['recieverId'] == args.recieverId ||
                    message['senderId'] == args.recieverId) {
                  return GestureDetector(
                    onPanUpdate: (details) {
                      // Swiping in right direction.

                      if (details.delta.dx > 0) {
                        setState(() {
                          isReplying = true;

                          replyMessage(message);

                          focusNode.requestFocus();

                          print(Provider.of<Data>(context, listen: false)
                              .repliedMessage);
                        });
                      }

                      // Swiping in left direction.

                      if (details.delta.dx < 0) {
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
                                        .deleteMessage(
                                            message['uuid'], args.recieverId);

                                    Navigator.pop(context);
                                  });
                                },
                                negativeTitle: 'Delete Message',
                                action: 'Delete',
                              ),
                            );
                          }
                        });
                      }
                    },
                    child: ChatBubble(
                      texto: message['message'],
                      isMe: message['senderId'] ==
                              Provider.of<Data>(context, listen: false).idOfUser
                          ? true
                          : false,
                      isAdmin: message['isAdmin'],
                      isPhoto: message['isPhoto'],
                      imageUrl: message['imageUrl'],
                      isReply: message['isReply'],
                      replyTo: message['repliedTo'],
                      uuid: message['uuid'],
                    ),
                  );
                } else {
                  return SizedBox(
                    height: 0,
                  );
                }
              },
              itemCount: Provider.of<Data>(context).messages.length,
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
                                            .repliedMessage,
                                      );
                                    });
                                  }),
                              ChatBubble(
                                texto: Provider.of<Data>(context, listen: false)
                                            .repliedMessage['message']
                                            .length >
                                        25
                                    ? Provider.of<Data>(context, listen: false)
                                            .repliedMessage['message']
                                            .substring(0, 25) +
                                        '....'
                                    : Provider.of<Data>(context, listen: false)
                                        .repliedMessage['message'],
                                isMe: Provider.of<Data>(context, listen: false)
                                            .repliedMessage['senderId'] ==
                                        Provider.of<Data>(context,
                                                listen: false)
                                            .idOfUser
                                    ? true
                                    : false,
                                isAdmin:
                                    Provider.of<Data>(context, listen: false)
                                        .repliedMessage['isAdmin'],
                                isPhoto:
                                    Provider.of<Data>(context, listen: false)
                                        .repliedMessage['isPhoto'],
                                imageUrl:
                                    Provider.of<Data>(context, listen: false)
                                        .repliedMessage['imageUrl'],
                                uuid: Provider.of<Data>(context, listen: false)
                                    .repliedMessage['uuid'],
                                isReply:
                                    Provider.of<Data>(context, listen: false)
                                        .repliedMessage['isReply'],
                                replyTo:
                                    Provider.of<Data>(context, listen: false)
                                        .repliedMessage['repliedTo'],
                              ),
                            ],
                          )
                        else
                          SizedBox(
                            height: 0,
                          ),
                        TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          focusNode: focusNode,
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
                                          .setMessage(
                                        args.recieverId,
                                        messageInField,
                                        Provider.of<Data>(context,
                                                listen: false)
                                            .idOfUser,
                                        false,
                                        false,
                                        'no image',
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
                                          .sendMessage(
                                        messageInField,
                                        Provider.of<Data>(context,
                                                listen: false)
                                            .idOfUser,
                                        args.recieverId,
                                        false,
                                        'no image',
                                        uuid,
                                        false,
                                        'no_reply',
                                      );
                                      cancelReplyMessage(
                                        Provider.of<Data>(context,
                                                listen: false)
                                            .repliedMessage,
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
                                          .setMessage(
                                        args.recieverId,
                                        messageInField,
                                        Provider.of<Data>(context,
                                                listen: false)
                                            .idOfUser,
                                        false,
                                        false,
                                        'no image',
                                        uuid,
                                        true,
                                        Provider.of<Data>(context,
                                                listen: false)
                                            .repliedMessage['uuid'],
                                      );
                                      _controller1.animateTo(
                                        _controller1.position.maxScrollExtent +
                                            100.h,
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeOut,
                                      );

                                      Provider.of<Data>(context, listen: false)
                                          .sendMessage(
                                        messageInField,
                                        Provider.of<Data>(context,
                                                listen: false)
                                            .idOfUser,
                                        args.recieverId,
                                        false,
                                        'no image',
                                        uuid,
                                        true,
                                        Provider.of<Data>(context,
                                                listen: false)
                                            .repliedMessage['uuid'],
                                      );
                                      cancelReplyMessage(
                                        Provider.of<Data>(context,
                                                listen: false)
                                            .repliedMessage,
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
                                  if (Provider.of<Data>(context, listen: false)
                                      .karmaCheck(args.recieverId)) {
                                    Provider.of<Data>(context, listen: false)
                                        .updateKarma(args.recieverId);
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) => Popup(
                                        popupTitle: "Leveled up karma by 10",
                                        popuptext: "You initiated the convo!!",
                                      ),
                                    );
                                  }
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
                                          .setMessage(
                                        args.recieverId,
                                        'image',
                                        Provider.of<Data>(context,
                                                listen: false)
                                            .idOfUser,
                                        false,
                                        true,
                                        imageUrlChanged,
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
                                          .sendMessage(
                                        'image',
                                        Provider.of<Data>(context,
                                                listen: false)
                                            .idOfUser,
                                        args.recieverId,
                                        true,
                                        imageUrlChanged,
                                        uuidImage,
                                        false,
                                        'no_reply',
                                      );
                                      cancelReplyMessage(
                                        Provider.of<Data>(context,
                                                listen: false)
                                            .repliedMessage,
                                      );
                                    } else {
                                      Provider.of<Data>(context, listen: false)
                                          .setMessage(
                                        args.recieverId,
                                        'image',
                                        Provider.of<Data>(context,
                                                listen: false)
                                            .idOfUser,
                                        false,
                                        true,
                                        imageUrlChanged,
                                        uuidImage,
                                        true,
                                        Provider.of<Data>(context,
                                                listen: false)
                                            .repliedMessage['uuid'],
                                      );

                                      _controller1.animateTo(
                                        _controller1.position.maxScrollExtent +
                                            48.h,
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeOut,
                                      );
                                      _controller.clear();

                                      Provider.of<Data>(context, listen: false)
                                          .sendMessage(
                                        'image',
                                        Provider.of<Data>(context,
                                                listen: false)
                                            .idOfUser,
                                        args.recieverId,
                                        true,
                                        imageUrlChanged,
                                        uuidImage,
                                        true,
                                        Provider.of<Data>(context,
                                                listen: false)
                                            .repliedMessage['uuid'],
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
