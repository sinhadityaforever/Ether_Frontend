import 'package:flutter/material.dart';
import 'package:frontend/api_calls/data.dart';
import 'package:frontend/widgets/popup_screen.dart';
import 'package:frontend/widgets/profile_view_tile.dart';
import 'package:frontend/widgets/rounded_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelfProfileView extends StatefulWidget {
  @override
  _SelfProfileViewState createState() => _SelfProfileViewState();
}

class _SelfProfileViewState extends State<SelfProfileView> {
  @override
  Widget build(BuildContext context) {
    int level = Provider.of<Data>(context, listen: false).level;
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
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                Provider.of<Data>(context, listen: false)
                                    .avatarUrlOfUser,
                              ),
                              radius: 70.r,
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
                                      AssetImage('images/badge-${level}.png'),
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
                            Provider.of<Data>(context, listen: false)
                                .nameOfUser,
                            style: TextStyle(
                              fontSize: 25.sp,
                              color: Color(0xFFEB1555),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        InkWell(
                          child: CircleAvatar(
                            backgroundImage:
                                AssetImage('images/early_bird.png'),
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
                    value: Provider.of<Data>(context, listen: false).bioOfUser,
                  ),
                  Divider(
                    indent: 25.h,
                    thickness: 0.8.w,
                  ),
                  profileViewTile(
                    title: 'Interests :',
                    value: Provider.of<Data>(context, listen: false)
                        .selfInterestInterpolated,
                  ),
                  Divider(
                    indent: 25.h,
                    thickness: 0.8.w,
                  ),
                  profileViewTile(
                    title: 'Karma Level',
                    value:
                        '${(Provider.of<Data>(context, listen: false).karmaLevel)} -- ${(Provider.of<Data>(context, listen: false).pointsForNextLevel)} more to go to the next level',
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Start a convo level up by 10 points!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: Colors.white60,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: RoundedButton(
                    colorOfButton: Color(0xFFEB1555),
                    onPressedRoundButton: () {
                      setState(() {
                        Navigator.pushNamed(context, '/profileEdit');
                      });
                    },
                    textOfButton: "Change your look",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
