import 'package:custom_splash/custom_splash.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:job_seekar_app/globle.dart';
import 'package:job_seekar_app/instagram_home.dart';
import 'package:job_seekar_app/loginScreen.dart';
import 'package:job_seekar_app/providers_data.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'insta_home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // fcm.requestNotificationPermissions(
  //     const IosNotificationSettings(
  //         sound: true, badge: true, alert: true));
  // fcm.onIosSettingsRegistered
  //     .listen((IosNotificationSettings settings) {
  //   print("Settings registered: $settings");
  // });
  // Here's where I pass it to the rest of the app
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Globle.username = prefs.getString('username');
  Globle.password = prefs.getString('password');
  Globle.image = prefs.getString('image');
  Globle.id = prefs.getString('user_id');
  Globle.name = prefs.getString('name');
  Globle.bio = prefs.getString('bio');
  Globle.token = prefs.getString('token');
  Globle.field = prefs.getString('field');
  // runApp(MaterialApp(home: email == null ? Login() : Home()));
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();

}
class _MyAppState extends State<MyApp> {
  String textValue = 'Hello World!';
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  new FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    // widget.fcm.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     print("onMessage: $message");
    //     showOverlayNotification((context) {
    //       return Card(
    //         margin: const EdgeInsets.symmetric(horizontal: 4),
    //         child: SafeArea(
    //           child: ListTile(
    //             leading: SizedBox.fromSize(
    //                 size: const Size(40, 40),
    //                 child: ClipOval(
    //                     child: Container(
    //                       color: Colors.black,
    //                     ))),
    //             title: Text(message['notification']['title']),
    //             subtitle: Text(message['notification']['body']),
    //             trailing: IconButton(
    //                 icon: Icon(Icons.close),
    //                 onPressed: () {
    //                   OverlaySupportEntry.of(context).dismiss();
    //                 }),
    //           ),
    //         ),
    //       );
    //     }, duration: Duration(milliseconds: 4000));
    //
    //     print(message['notification']['title']);
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print("onLaunch: $message");
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     print("onResume: $message");
    //   },
    //
    // );
    super.initState();

    var android = new AndroidInitializationSettings('mipmap/ic_launcher');
    var ios = new IOSInitializationSettings();
    var platform = new InitializationSettings(android: android, iOS: ios);
    flutterLocalNotificationsPlugin.initialize(platform);

    firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> msg) async {
        print(" onLaunch called ${(msg)}");
      },
      onResume: (Map<String, dynamic> msg) async {
        print(" onResume called ${(msg)}");
      },
      onMessage: (Map<String, dynamic> msg) async {
        showOverlayNotification((context) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: SafeArea(
                    child: ListTile(
                      leading: SizedBox.fromSize(
                          size: const Size(40, 40),
                          child: ClipOval(
                              child: Container(
                                child: Icon(Icons.add_alert_rounded),
                                color: Colors.black,
                              ))),
                      title: Text(msg['notification']['title']),
                      subtitle: Text(msg['notification']['body']),
                      trailing: IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            OverlaySupportEntry.of(context).dismiss();
                          }),
                    ),
                  ),
                );
              }, duration: Duration(milliseconds: 4000));

        showNotification(msg);
        print(" onMessage called ${(msg)}");
      },
    );
    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, alert: true, badge: true));
    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings setting) {
      print('IOS Setting Registed');
    });
    firebaseMessaging.getToken().then((token) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);
      Globle.token = token;

    });
  }

  showNotification(Map<String, dynamic> msg) async {
    var android = new AndroidNotificationDetails(
      msg['notification']['title'],
      msg['notification']['body'],
      "channelDescription",
    );
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(
        0, msg['notification']['title'], msg['notification']['body'], platform);

  }
  @override
  Widget build(BuildContext context) {


    return ChangeNotifierProvider(
      create: (_) => ProvidersData(),
      child: OverlaySupport(
        child: MaterialApp(
          title: 'Paper Job',
          debugShowCheckedModeBanner: false,
          theme: new ThemeData(
              primarySwatch: Colors.yellow,
              primaryColor: Colors.black,
              buttonColor: Colors.black,
              primaryIconTheme: IconThemeData(color: Colors.black),
              primaryTextTheme: TextTheme(
                  bodyText1:
                      TextStyle(color: Colors.black, fontFamily: "Aveny")),
              textTheme: TextTheme(bodyText1: TextStyle(color: Colors.black))),

          // ignore: missing_required_param
          home: CustomSplash(
            imagePath: 'assets/paper.png',
            backGroundColor: Colors.white,
            // backGroundColor: Color(0xfffc6042),
            animationEffect: 'zoom-in',
            logoSize: 300,
            home: Globle.username == null ? LoginScreen() : InstagramHome(),
            duration: 2500,
            type: CustomSplashType.StaticDuration,
          ),
        ),
      ),
    );
  }
}
