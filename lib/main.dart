// @dart=2.9

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:me_cuadra_users/providers/card_provider.dart';
import 'package:me_cuadra_users/providers/filter_provider.dart';
import 'package:me_cuadra_users/providers/user_provider.dart';
import 'package:me_cuadra_users/routes/routes.dart';
import 'package:me_cuadra_users/themes/my_themes.dart';
import 'package:me_cuadra_users/user_app_pages/welcome_pages/check_login_user_page.dart';
import 'package:provider/provider.dart';

import 'colors/colors_data.dart';
import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  AwesomeNotifications().initialize(
      'resource://drawable/res_notification_app_icon',
      [
        NotificationChannel(
            channelKey: "basic_channel",
            playSound: true,
            soundSource: 'resource://raw/res_custom_notification',
            channelName: "Basic Notifications",
            channelDescription: "Notification channel for basic test",
            importance: NotificationImportance.High,
            defaultColor: MyColors.blue2,
            channelShowBadge: true,
            ledColor: MyColors.blue2,
            defaultRingtoneType: DefaultRingtoneType.Notification),
        NotificationChannel(
          channelKey: 'scheduled_channel',
          channelName: 'Scheduled Notifications',
          soundSource: 'resource://raw/res_custom_notification',
          channelDescription: 'Notifications with schedule functionality',
          defaultColor: MyColors.blue2,
          playSound: true,
          locked: false,
          channelShowBadge: true,
          ledColor: MyColors.blue2,
          importance: NotificationImportance.High,
        )
      ],
      debug: true);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CardProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => FilterProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        title: 'MeCuadra App',
        theme: MyThemes.lightTheme,
        routes: getApplicationRoute(),
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) => VerifyLoginUser());
          //TinderCard(residences: residences));
        },
      ),
    );
  }
}
