// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:me_cuadra_users/models/user_model.dart';
import 'package:me_cuadra_users/preferences/user_preference.dart';
import 'package:me_cuadra_users/services/const/firebase_constants.dart';
import 'package:me_cuadra_users/services/firebase/user_crud.dart';
import 'package:me_cuadra_users/services/notifications/fcm_firebase_notification/fcm_service.dart';
import 'package:me_cuadra_users/user_app_pages/welcome_pages/home_page.dart';
import 'package:me_cuadra_users/user_app_pages/welcome_pages/init_register_phone_number.dart';
import 'package:me_cuadra_users/user_app_pages/welcome_pages/welcome_page.dart';

class VerifyLoginUser extends StatelessWidget {
  VerifyLoginUser({Key? key}) : super(key: key);
  UserModel user = UserModel();

  getUser() async {
    if (authInstance.currentUser != null) {
      if (authInstance.currentUser!.email != null &&
          authInstance.currentUser!.email != '') {
        user =
            await UserCrud().getUserforEmail(authInstance.currentUser!.email!);
      } else {
        user = await UserPreferences().loadData();
      }
    }
    getToken(user);
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUser(),
        builder: ((context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done &&
              user.email != null) {
            if (user.phoneNumber != '') {
              if (user.isVerified!) {
                return const HomePage();
              } else {
                return const WelcomePage();
              }
            } else {
              return InitRegisterPhoneNumber(
                user: user,
              );
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const WelcomePage();
          }
        }));
  }
}
