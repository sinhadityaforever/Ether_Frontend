import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:frontend/screens/bookmark_page.dart';
import 'package:frontend/screens/chatroompage.dart';
import 'package:frontend/screens/edit_interest_set/edit_interest.dart';
import 'package:frontend/screens/edit_interest_set/edit_occupation.dart';
import 'package:frontend/screens/entry_screen.dart';
import 'package:frontend/screens/feedCard.dart';
import 'package:frontend/screens/forgot_password_set/change_password.dart';
import 'package:frontend/screens/forgot_password_set/email_confirm.dart';
import 'package:frontend/screens/forgot_password_set/otp_password.dart';
import 'package:frontend/screens/full_screen_player.dart';
import 'package:frontend/screens/home.dart';
import 'package:frontend/screens/karma_levels.dart';
import 'package:frontend/screens/logo.dart';
import 'package:frontend/screens/my_bookmarks.dart';
import 'package:frontend/screens/photo.dart';
import 'package:frontend/screens/profile_view_page.dart';
import 'package:frontend/screens/room_profile_view.dart';
import 'package:frontend/screens/self_profile_view.dart';
import 'package:frontend/screens/welcome.dart';
import 'api_calls/data.dart';
import 'screens/edit_profile_page.dart';
import 'package:provider/provider.dart';
import 'screens/login.dart';
import 'screens/interests_page.dart';
import 'screens/chat_page.dart';
import 'screens/signup_set/signupotp.dart';
import 'screens/signup_set/otpverify.dart';
import 'screens/signup_set/confirm_account.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
  print(message.data);
  flutterLocalNotificationsPlugin.show(
    message.data.hashCode,
    message.data['title'],
    message.data['body'],
    NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        channel.description,
      ),
    ),
  );
}

FirebaseAnalytics analytics = FirebaseAnalytics();
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

void getToken() async {
  String? token = await FirebaseMessaging.instance.getToken();
  print(token);
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
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
      }
    });
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(412, 869),
      builder: () => FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ChangeNotifierProvider<Data>.value(
              value: Data(),
              child: MaterialApp(
                theme: ThemeData.dark().copyWith(
                  accentColor: Color(0xFFEB1555),
                  scaffoldBackgroundColor: Color(0xFF0A0E21),
                  primaryColor: Color(0xFF0A0E21),
                ),
                initialRoute: '/logo',
                navigatorObservers: [
                  FirebaseAnalyticsObserver(analytics: analytics),
                ],
                debugShowCheckedModeBanner: false,
                routes: {
                  '/confirmAccount': (context) => ConfirmAccount(),
                  '/otpVerify': (context) => OTPVerify(),
                  '/signupOTP': (context) => SignupOTP(),
                  '/profileEdit': (context) => Profile(),
                  '/profileView': (context) => ProfileView(),
                  '/login': (context) => LoginScreen(),
                  '/interests': (context) => InterestsPage(),
                  '/contactsPage': (context) => HomePage(),
                  '/chatPage': (context) => ChatPage(),
                  '/logo': (context) => LogoScreen(),
                  '/welcome': (context) => Welcome(),
                  '/photo': (context) => Photo(),
                  '/karmalevels': (context) => KarmaView(),
                  '/forgotPassword': (context) => EmailConfirm(),
                  '/otpPassword': (context) => OTPPassword(),
                  '/changePassword': (context) => ChangePassword(),
                  '/entryScreen': (context) => EntryScreen(),
                  '/editOccupation': (context) => OccupationEdit(),
                  '/editInterest': (context) => EditInterestAfterOccupation(),
                  '/selfProfileView': (context) => SelfProfileView(),
                  '/roomProfileView': (context) => RoomProfileView(),
                  '/chatRoomChatPage': (context) => ChatRoomPage(),
                  '/fullScreenPlayer': (context) => FullScreenPlayer(),
                  // '/feedCard': (context) => FeedCard(),
                  '/bookmarkPage': (context) => BookmarkPage(),
                  '/myBookmarks': (context) => MyBookmarks()
                },
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
