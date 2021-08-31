import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// This is the individual block for each contact after a match and it shows up on the home page
// its a dynamic file that takes name, image_url, last message and chatroute as its parameters

class CardNoteTile extends StatefulWidget {
  final String name;
  final String imageUrl;
  final String note;
  final onPressedChatTile;
  final int userId;

  CardNoteTile({
    required this.onPressedChatTile,
    required this.name,
    required this.imageUrl,
    required this.note,
    required this.userId,
  });
  @override
  _CardNoteTile createState() => _CardNoteTile();
}

class _CardNoteTile extends State<CardNoteTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          style: TextButton.styleFrom(
            primary: Colors.white,
          ),
          onPressed: widget.onPressedChatTile,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.imageUrl),
                    radius: 37.r,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.shortestSide * 0.05,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name.length > 17
                            ? widget.name.substring(0, 17)
                            : widget.name,
                        style: TextStyle(
                          fontSize: 17.sp,
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        widget.note,
                        maxLines: null,
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: Color(0xFFA9AAAC),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 140.w,
                  ),
                ],
              ),
            ),
          ),
        ),
        Divider(
          color: Color(0xFFA9AAAC),
          thickness: .1.w,
          indent: 92.h,
        )
      ],
    );
  }
}
