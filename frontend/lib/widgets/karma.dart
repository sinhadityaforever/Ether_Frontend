import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// This is the individual block for each contact after a match and it shows up on the home page
// its a dynamic file that takes name, image_url, last message and chatroute as its parameters

class KarmaListTile extends StatefulWidget {
  final String name;
  final String path;
  final String levelName;

  KarmaListTile({
    required this.name,
    required this.path,
    required this.levelName,
  });
  @override
  _KarmaState createState() => _KarmaState();
}

class _KarmaState extends State<KarmaListTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          style: TextButton.styleFrom(
            primary: Colors.white,
          ),
          onPressed: () {},
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(widget.path),
                    radius: 28.r,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.shortestSide * 0.05,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: TextStyle(
                          fontSize: 17.sp,
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        widget.levelName,
                        style: TextStyle(
                          fontSize: 25.sp,
                          color: Color(0xFFA9AAAC),
                          fontWeight: FontWeight.w300,
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
