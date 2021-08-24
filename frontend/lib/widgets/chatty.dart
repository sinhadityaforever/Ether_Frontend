import 'package:flutter/material.dart';
import 'package:frontend/api_calls/data.dart';
import 'package:frontend/screens/photo.dart';
import 'package:linkable/linkable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class chatty extends StatelessWidget {
  const chatty({
    required this.uuid,
    required this.isReply,
    required this.replyTo,
    required this.isMe,
    required this.texto,
    required this.isAdmin,
    required this.isPhoto,
    required this.imageUrl,
  });

  final bool isMe;
  final String texto;
  final bool isAdmin;
  final bool isPhoto;
  final String imageUrl;
  final String uuid;
  final bool isReply;
  final String replyTo;

  @override
  Widget build(BuildContext context) {
    if (isPhoto) {
      return GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/photo',
            arguments: PhotoArguments(imageUrl: imageUrl),
          );
        },
        child: Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Container(
              decoration: BoxDecoration(
                color: isMe ? Color(0xFF94002C) : Color(0xFFEB1555),
                borderRadius: BorderRadius.circular(10),
              ),
              height: MediaQuery.of(context).size.height / 3.0,
              width: MediaQuery.of(context).size.width / 1.8,
              child: Card(
                color: Color(0xFF0A0E21),
                margin: EdgeInsets.all(3.r),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: isAdmin
                        ? Radius.circular(10.0.r)
                        : isMe
                            ? Radius.circular(10.0.r)
                            : Radius.circular(0),
                    topRight: isAdmin
                        ? Radius.circular(10.0.r)
                        : isMe
                            ? Radius.circular(0)
                            : Radius.circular(10.0.r),
                    bottomLeft: Radius.circular(10.0.r),
                    bottomRight: Radius.circular(10.0.r),
                  ),
                ),
                child: Image(
                  image: NetworkImage(imageUrl),
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
          crossAxisAlignment: isAdmin == true
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.end,
          textDirection: isMe ? TextDirection.ltr : TextDirection.rtl,
          children: [
            if (isReply == true)
              InkWell(
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isAdmin
                        ? Color(0xFF056162)
                        : isMe
                            ? Color(0xFF862E48)
                            : Color(0xFF2A2F32),
                    borderRadius: BorderRadius.only(
                      bottomRight: isAdmin
                          ? Radius.circular(10.0.r)
                          : isMe
                              ? Radius.circular(0)
                              : Radius.circular(10.0.r),
                      topLeft: Radius.circular(10.0.r),
                      topRight: Radius.circular(10.0.r),
                    ),
                  ),
                  child: Text(
                    Provider.of<Data>(context, listen: false)
                        .messages
                        .singleWhere(
                            (element) => element['uuid'] == replyTo)['message'],
                  ),
                ),
              ),
            Material(
              borderRadius: BorderRadius.only(
                topLeft: isAdmin
                    ? Radius.circular(10.0.r)
                    : isMe
                        ? Radius.circular(10.0.r)
                        : Radius.circular(0),
                topRight: isAdmin
                    ? Radius.circular(10.0.r)
                    : isMe
                        ? Radius.circular(0)
                        : Radius.circular(10.0.r),
                bottomLeft: Radius.circular(10.0.r),
                bottomRight: Radius.circular(10.0.r),
              ),
              elevation: 5.0,
              color: isAdmin
                  ? Color(0xFF056162)
                  : isMe
                      ? Color(0xFF94002C)
                      : Color(0xFF131C21),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 20.0,
                ),
                child: Linkable(
                  text: texto,
                  textColor: Colors.white,
                  linkColor: isMe ? Colors.black : Color(0xFFEB1555),
                  style: TextStyle(
                    fontSize: 17.0.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
