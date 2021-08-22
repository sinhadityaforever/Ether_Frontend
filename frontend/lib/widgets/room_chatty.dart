import 'package:flutter/material.dart';
import 'package:frontend/screens/photo.dart';
import 'package:linkable/linkable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class roomChatty extends StatefulWidget {
  const roomChatty({
    required this.isMe,
    required this.texto,
    required this.isAdmin,
    required this.isPhoto,
    required this.imageUrl,
    required this.senderName,
    // required this.showProfileCallback,
  });

  final bool isMe;
  final String texto;
  final bool isAdmin;
  final bool isPhoto;
  final String imageUrl;
  final String senderName;
  // final showProfileCallback;

  @override
  _roomChattyState createState() => _roomChattyState();
}

class _roomChattyState extends State<roomChatty> {
  @override
  Widget build(BuildContext context) {
    if (widget.isPhoto) {
      return GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/photo',
            arguments: PhotoArguments(imageUrl: widget.imageUrl),
          );
        },
        child: Align(
          alignment: widget.isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Container(
              decoration: BoxDecoration(
                color: widget.isMe ? Color(0xFF94002C) : Color(0xFFEB1555),
                borderRadius: BorderRadius.circular(10),
              ),
              height: MediaQuery.of(context).size.height / 3.0,
              width: MediaQuery.of(context).size.width / 1.8,
              child: Card(
                color: Color(0xFF0A0E21),
                margin: EdgeInsets.all(3.r),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: widget.isAdmin
                        ? Radius.circular(10.0.r)
                        : widget.isMe
                            ? Radius.circular(10.0.r)
                            : Radius.circular(0),
                    topRight: widget.isAdmin
                        ? Radius.circular(10.0.r)
                        : widget.isMe
                            ? Radius.circular(0)
                            : Radius.circular(10.0.r),
                    bottomLeft: Radius.circular(10.0.r),
                    bottomRight: Radius.circular(10.0.r),
                  ),
                ),
                child: Image(
                  image: NetworkImage(widget.imageUrl),
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: widget.isAdmin == true
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.end,
          textDirection: widget.isMe ? TextDirection.ltr : TextDirection.rtl,
          children: [
            Material(
              borderRadius: BorderRadius.only(
                topLeft: widget.isAdmin
                    ? Radius.circular(10.0.r)
                    : widget.isMe
                        ? Radius.circular(10.0.r)
                        : Radius.circular(0),
                topRight: widget.isAdmin
                    ? Radius.circular(10.0.r)
                    : widget.isMe
                        ? Radius.circular(0)
                        : Radius.circular(10.0.r),
                bottomLeft: Radius.circular(10.0.r),
                bottomRight: Radius.circular(10.0.r),
              ),
              elevation: 5.0,
              color: widget.isAdmin
                  ? Color(0xFF056162)
                  : widget.isMe
                      ? Color(0xFF94002C)
                      : Color(0xFF131C21),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 20.0,
                ),
                child: Column(
                  crossAxisAlignment: widget.isMe
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        if (widget.isMe)
                          Text(
                            'Me',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white60,
                            ),
                          )
                        else
                          InkWell(
                            onTap: () {
                              // widget.showProfileCallback;
                            },
                            child: Text(
                              widget.senderName,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white60,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Linkable(
                      text: widget.texto,
                      textColor: Colors.white,
                      linkColor: widget.isMe ? Colors.black : Color(0xFFEB1555),
                      style: TextStyle(
                        fontSize: 17.0.sp,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
