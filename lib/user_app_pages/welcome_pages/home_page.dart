// ignore_for_file: file_names, avoid_print

import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:me_cuadra_users/models/user_model.dart';
import 'package:me_cuadra_users/preferences/user_preference.dart';
import 'package:me_cuadra_users/services/firebase/user_crud.dart';
import 'package:me_cuadra_users/user_app_pages/user_login/verify_user.dart';
import 'package:provider/provider.dart';

import '../../../colors/colors_data.dart';
import '../../providers/card_provider.dart';
import '../../providers/filter_provider.dart';
import '../property_information_pages/tinder_card.dart';
import '../property_information_pages/home_filter_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Permitir Notificaciones',
                      style: GoogleFonts.montserrat(
                          color: MyColors.grey,
                          fontSize: 20,
                          fontWeight: FontWeight.w600)),
                  content: Text('MeCuadra quiere enviarte notificaciones',
                      style: GoogleFonts.montserrat(
                          color: MyColors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.w600)),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('No permitir',
                            style: GoogleFonts.montserrat(
                                color: MyColors.blue2,
                                fontSize: 18,
                                fontWeight: FontWeight.w600))),
                    TextButton(
                        onPressed: () => AwesomeNotifications()
                            .requestPermissionToSendNotifications()
                            .then((value) => Navigator.pop(context)),
                        child: Text('Permitir',
                            style: GoogleFonts.montserrat(
                                color: MyColors.blue2,
                                fontSize: 18,
                                fontWeight: FontWeight.w600))),
                  ],
                ));
      }
    });

    AwesomeNotifications().createdStream.listen((notification) {
      print('Notification created on ${notification.channelKey}');
    });

    AwesomeNotifications().actionStream.listen((notification) {
      print('Notification accepted on ${notification.channelKey}');
      if (notification.channelKey == 'scheduled_channel' && Platform.isIOS) {
        AwesomeNotifications().getGlobalBadgeCounter().then(
            (value) => AwesomeNotifications().setGlobalBadgeCounter(value - 1));
      }
    });

    AwesomeNotifications().dismissedStream.listen((notification) {
      print('Notification rejected on ${notification.channelKey}');
      if (notification.channelKey == 'scheduled_channel' && Platform.isIOS) {
        AwesomeNotifications().getGlobalBadgeCounter().then(
            (value) => AwesomeNotifications().setGlobalBadgeCounter(value - 1));
      }
    });

    requestPermission();
    loadFCM();
    listenFCM();
  }

  requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              icon: 'launch_background',
            ),
          ),
        );
      }
    });
  }

  void loadFCM() async {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
          'Personal_notifications', // id
          'Personal notifications', // title
          importance: Importance.high);

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  @override
  void dispose() {
    AwesomeNotifications().actionSink.close();
    AwesomeNotifications().createdSink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('¿Estas seguro?'),
                content: const Text('¿Quieres salir de MeCuadra?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () =>
                        Navigator.of(context).pop(false), //<-- SEE HERE
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.of(context).pop(true), // <-- SEE HERE
                    child: const Text('Si'),
                  ),
                ],
              ),
            ) ??
            false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: getAppBar(),
        body: SafeArea(
            child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(1),
                child: buildCards())),
      ),
    );
  }

  AppBar getAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          goUserProfile();
        },
        icon: SvgPicture.asset('assets/Icons/Usuario.svg',
            height: 35, width: 35, color: Colors.white),
      ),
      centerTitle: true,
      title: SvgPicture.asset(
        'assets/Icons/LogoSVG.svg',
        width: 30,
        height: 30,
        color: MyColors.blue2,
      ),
      actions: [
        IconButton(
            onPressed: () {
              showFilters();
            },
            icon: SvgPicture.asset('assets/Icons/Filtro.svg',
                height: 35, width: 35, color: Colors.white))
      ],
    );
  }

  Widget buildCards() {
    final provider = Provider.of<CardProvider>(context);
    final residencess = provider.residences;

    return residencess.isEmpty
        ? Center(
            child: ElevatedButton(
            child: const Text('Restart'),
            onPressed: () {
              final provider =
                  Provider.of<CardProvider>(context, listen: false);
              provider.resetResidences();
            },
          ))
        : Stack(
            children: residencess
                .map((residen) => TinderCard(
                      residence: residen,
                      isFront: residencess.last == residen,
                    ))
                .toList(),
          );
  }

  goUserProfile() async {
    UserModel user = await UserPreferences().loadData();
    if (user.id != '') {
      user = await UserCrud().getUser(user.id!);
    }
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => VerifyUser(user: user),
        ),
        (_) => false);
  }

  void showFilters() {
    final filterProvider = Provider.of<FilterProvider>(context, listen: false);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => HomeFilter(filterProvider: filterProvider)),
        (_) => false);
  }
}
