import 'package:flutter/material.dart';
import 'package:frontend/api_calls/data.dart';
import 'package:frontend/widgets/profile_view_tile.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoomViewArgs {
  final String aboutRoom;
  final int index;

  RoomViewArgs({
    required this.aboutRoom,
    required this.index,
  });
}

class RoomProfileView extends StatefulWidget {
  @override
  _RoomProfileViewState createState() => _RoomProfileViewState();
}

class _RoomProfileViewState extends State<RoomProfileView> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as RoomViewArgs;
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                            Provider.of<Data>(context, listen: false)
                                .chatRooms[args.index]
                                .imageUrl,
                          ),
                          radius: 100.r,
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          Provider.of<Data>(context, listen: false)
                              .chatRooms[args.index]
                              .name,
                          style: TextStyle(
                            fontSize: 25.sp,
                            color: Color(0xFFEB1555),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    indent: 25.h,
                    thickness: 0.8.w,
                  ),
                  profileViewTile(
                    title: 'About :',
                    value: args.aboutRoom,
                  ),
                  Divider(
                    indent: 25.h,
                    thickness: 0.8.w,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
