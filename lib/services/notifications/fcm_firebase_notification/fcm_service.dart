// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:me_cuadra_users/models/user_model.dart';
import 'package:me_cuadra_users/preferences/user_preference.dart';
import 'package:me_cuadra_users/services/firebase/user_crud.dart';

sendPushMessage(String token, String body, String title) async {
  try {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAAkDSm7S4:APA91bE6YmP9P2XRhVx90IYknFM0v4xKosXmnnGkG3byGI4ExnPCAGnGsHohN03wHcACYFYWYGYZBLluTaThDBHPSddgwIFfu7nCwSf-aFJOGyhkFbAjwKZI5VeGYcRJgZ1vmwAYfW8l',
      },
      body: jsonEncode(<String, dynamic>{
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'status': 'done',
          'body': body,
          'title': title,
        },
        "notification": <String, dynamic>{
          "title": title,
          "body": body,
        },
        "to": token,
      }),
    );
  } catch (e) {
    if (kDebugMode) {
      print('error push notifiication: ' + e.toString());
    }
  }
}

getToken(UserModel myUser) async {
  if (myUser.id == null) return;
  await FirebaseMessaging.instance.getToken().then((token) {
    print('My token is $token');
    saveToken(token!, myUser);
  });
}

Future<String> getTokenString(UserModel myUser) async {
  if (myUser.id == null) return '';
  String thisToken = '';
  await FirebaseMessaging.instance.getToken().then((token) {
    print('My token is $token');
    thisToken = token!;
  });
  return thisToken;
}

saveToken(String myToken, UserModel myUser) {
  if (myUser.userToken == null) {
    myUser.userToken = myToken;

    UserCrud().updateUser(myUser.id!, myUser);
    UserPreferences().saveData(myUser);
  } else if (myUser.userToken != '') {
    if (myUser.userToken != myToken) {
      myUser.userToken = myToken;

      UserCrud().updateUser(myUser.id!, myUser);
      UserPreferences().saveData(myUser);
    }
  } else {
    myUser.userToken = myToken;

    UserCrud().updateUser(myUser.id!, myUser);
    UserPreferences().saveData(myUser);
  }
}
