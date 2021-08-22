import 'package:flutter/material.dart';
import 'package:frontend/widgets/popup_screen.dart';
import 'package:frontend/widgets/profile_view_tile.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoomProfileViewArgs {
  final String name;
  final String imageUrl;
  final String aboutValue;
  final String interestValue;
  final int level;
  final int karmaNumber;

  RoomProfileViewArgs({
    required this.name,
    required this.imageUrl,
    required this.aboutValue,
    required this.interestValue,
    required this.level,
    required this.karmaNumber,
  });
}

class RoomProfileView extends StatelessWidget {
  String karmaLevel = '';
  int pointsForNextLevel = 0;
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as RoomProfileViewArgs;
    if (args.level == 1) {
      karmaLevel = 'Novice';
      pointsForNextLevel = 100 - args.karmaNumber;
    } else if (args.level == 2) {
      karmaLevel = 'Intermediate';
      pointsForNextLevel = 500 - args.karmaNumber;
    } else if (args.level == 3) {
      karmaLevel = 'Professional';
      pointsForNextLevel = 1200 - args.karmaNumber;
    } else if (args.level == 4) {
      karmaLevel = 'Expert';
      pointsForNextLevel = 3800 - args.karmaNumber;
    } else if (args.level == 5) {
      karmaLevel = 'Master';
      pointsForNextLevel = 5000 - args.karmaNumber;
    } else {
      karmaLevel = 'Grand Master';
      pointsForNextLevel = 10000 - args.karmaNumber;
    }
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 70.r,
                        backgroundImage: NetworkImage(args.imageUrl),
                      ),
                      Positioned(
                        bottom: 10.h,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/karmalevels');
                          },
                          child: CircleAvatar(
                            backgroundImage:
                                AssetImage('images/badge-${args.level}.png'),
                            radius: 25.r,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 40.w,
                  ),
                  Expanded(
                    child: Text(
                      args.name,
                      style: TextStyle(
                        fontSize: 25.sp,
                        color: Color(0xFFEB1555),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  InkWell(
                    child: CircleAvatar(
                      backgroundImage: AssetImage('images/early_bird.png'),
                      radius: 15.r,
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => Popup(
                          popupTitle: "Hey Early Bird",
                          popuptext:
                              "Thanks for being one of our early users we are delightful to have you",
                        ),
                      );
                    },
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
              value: args.aboutValue,
            ),
            Divider(
              indent: 25.h,
              thickness: 0.8.w,
            ),
            profileViewTile(
              title: 'Interests :',
              value: args.interestValue,
            ),
            Divider(
              indent: 25.h,
              thickness: 0.8.w,
            ),
            profileViewTile(
              title: 'Karma',
              value:
                  '${karmaLevel} -- ${pointsForNextLevel} more to go to the next level',
            ),
          ],
        ),
      ),
    );
  }
}
