import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:frontend/api_calls/data.dart';
import 'package:frontend/models/search_model.dart';
import 'package:frontend/widgets/negative_popup.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'chatroom.dart';
import 'contacts.dart';
import 'feed.dart';
import 'self_profile_view.dart';
import '../main.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _url = 'https://www.etherapp.org/post/privacy-policy';
  void _launchURL() async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';
  @override
  void initState() {
    super.initState();
    for (var i = 0;
        i < Provider.of<Data>(context, listen: false).roomId.length;
        i++) {
      Provider.of<Data>(context, listen: false)
          .getRoomMessage(Provider.of<Data>(context, listen: false).roomId[i]);
    }
    var initialzationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initialzationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              icon: android.smallIcon,
            ),
          ),
        );
        if (notification.title == 'New Connection') {
          Provider.of<Data>(context, listen: false).getContacts();
        }
      }
    });
    getToken();
    Provider.of<Data>(context, listen: false).connect();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ether.',
                  style: TextStyle(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFEB1555),
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      child: Icon(
                        Icons.search,
                        size: 30.r,
                      ),
                      onTap: () {
                        showSearch(
                          context: context,
                          delegate: ContactSearch(),
                        );
                      },
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert,
                        size: 30.r,
                        color: Color(0xFFEB1555),
                      ),
                      onSelected: (value) {
                        if (value == 'Edit Profile') {
                          Navigator.pushNamed(context, '/profileEdit');
                        }
                        if (value == 'Karma levels') {
                          Navigator.pushNamed(context, '/karmalevels');
                        }
                        if (value == 'Privacy Policy') {
                          _launchURL();
                        }

                        if (value == 'Log-out') {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => NegativePopup(
                              popuptext: 'Do you want to log out',
                              onPresseedPopup: () {
                                Provider.of<Data>(context, listen: false)
                                    .signOutGoogle();
                                Provider.of<Data>(context, listen: false)
                                    .deleteNotifToken();
                                Provider.of<Data>(context, listen: false)
                                    .storage
                                    .deleteAll();
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/welcome',
                                    (Route<dynamic> route) => false);
                              },
                              negativeTitle: 'Close Sesame',
                              action: 'log-out',
                            ),
                          );
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem(
                            child: Text('Edit Profile'),
                            value: "Edit Profile",
                          ),
                          PopupMenuItem(
                            child: Text('Karma levels'),
                            value: "Karma levels",
                          ),
                          PopupMenuItem(
                            child: Text('Log-out'),
                            value: "Log-out",
                          ),
                          PopupMenuItem(
                            child: Text('Privacy Policy'),
                            value: "Privacy Policy",
                          ),
                        ];
                      },
                      color: Color(0xFF0A0E21),
                    )
                  ],
                )
              ],
            ),
            bottom: TabBar(
              labelStyle: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w300,
              ),
              indicatorColor: Color(0xFFEB1555),
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Tab(
                  text: 'Feed',
                ),
                Tab(
                  text: 'Connections',
                ),
                Tab(
                  text: 'Chat rooms',
                ),
                Tab(
                  text: 'Profile',
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              QuestionFeed(),
              ContactPage(),
              ChatRoomContactPage(),
              SelfProfileView(),
            ],
          ),
        ),
      ),
    );
  }
}
