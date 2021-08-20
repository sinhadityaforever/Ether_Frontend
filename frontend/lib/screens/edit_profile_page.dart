import 'package:flutter/material.dart';
import 'package:frontend/api_calls/data.dart';
import 'package:frontend/widgets/image_picker.dart';
import 'package:frontend/widgets/rounded_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    String name = Provider.of<Data>(context).nameOfUser;
    String bio = Provider.of<Data>(context).bioOfUser;
    String imageUrl = Provider.of<Data>(context, listen: false).avatarUrlOfUser;
    String firstInterest = Provider.of<Data>(context).firstinterestOfuser;
    String avatar = Provider.of<Data>(context, listen: false).avatarUrlOfUser;
    print(firstInterest);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Avatar(),
                    SizedBox(
                      height: 30.h,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.account_circle,
                          size: 30.r,
                        ),
                        SizedBox(
                          width: 20.h,
                        ),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => SingleChildScrollView(
                                child: Container(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
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
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Text(
                                              'Enter Your Name',
                                              style: TextStyle(
                                                fontSize: 17.sp,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 25, vertical: 0),
                                            child: TextField(
                                              autofocus: true,
                                              textAlign: TextAlign.center,
                                              onChanged: (newValue) {
                                                name = newValue;
                                                print(name);
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 25),
                                            // ignore: deprecated_member_use
                                            child: FlatButton(
                                              minWidth: double.infinity,
                                              height: 40.h,
                                              color: Color(0xFFEB1555),
                                              onPressed: () {
                                                Provider.of<Data>(context,
                                                        listen: false)
                                                    .updateSelf(
                                                        name, bio, avatar);
                                                Navigator.pop(context);
                                              },
                                              child: Text('Save'),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width:
                                MediaQuery.of(context).size.shortestSide * 0.72,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Name',
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.white54,
                                      ),
                                    ),
                                    Text(
                                      name.length > 12
                                          ? name.substring(0, 12) + '..'
                                          : name,
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.edit,
                                  size: 27.r,
                                  color: Color(0xFFEB1555),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Divider(
                      indent: 46.h,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.description_outlined,
                          size: 30.r,
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => SingleChildScrollView(
                                child: Container(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
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
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Text(
                                              'Tell something about you!',
                                              style: TextStyle(
                                                fontSize: 17.sp,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 25, vertical: 0),
                                            child: TextField(
                                              autofocus: true,
                                              textAlign: TextAlign.center,
                                              onChanged: (newValue) {
                                                bio = newValue;
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 25),
                                            // ignore: deprecated_member_use
                                            child: FlatButton(
                                              minWidth: double.infinity,
                                              height: 40.h,
                                              color: Color(0xFFEB1555),
                                              onPressed: () {
                                                Provider.of<Data>(context,
                                                        listen: false)
                                                    .updateSelf(
                                                        name, bio, avatar);
                                                Navigator.pop(context);
                                              },
                                              child: Text('Save'),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width:
                                MediaQuery.of(context).size.shortestSide * 0.72,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'About',
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.white54,
                                      ),
                                    ),
                                    Text(
                                      bio.length > 12
                                          ? bio.substring(0, 12) + '..'
                                          : bio,
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.edit,
                                  size: 27.r,
                                  color: Color(0xFFEB1555),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Divider(
                      indent: 46.h,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.description_outlined,
                          size: 30.r,
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/editOccupation');
                          },
                          child: Container(
                            width:
                                MediaQuery.of(context).size.shortestSide * 0.72,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Interests',
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.white54,
                                      ),
                                    ),
                                    Text(
                                      firstInterest.length > 12
                                          ? firstInterest.substring(0, 12) +
                                              '..'
                                          : firstInterest,
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.edit,
                                  size: 27.r,
                                  color: Color(0xFFEB1555),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    RoundedButton(
                      colorOfButton: Color(0xFFEB1555),
                      onPressedRoundButton: () {
                        setState(() {
                          print(avatar);
                          Provider.of<Data>(context, listen: false).updateSelf(
                            name,
                            bio,
                            imageUrl,
                          );
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/contactsPage', (Route<dynamic> route) => false);
                        });
                      },
                      textOfButton: "SAVE",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
