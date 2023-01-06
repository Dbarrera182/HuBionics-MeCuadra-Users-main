// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:me_cuadra_users/services/const/firebase_constants.dart';
import 'package:me_cuadra_users/services/firebase/user_crud.dart';
import 'package:me_cuadra_users/user_app_pages/user_login/register_phonenumber.dart';

import '../../models/user_model.dart';
import '../../preferences/user_preference.dart';
import '../profile_views/profile_pages/profile_page.dart';
import 'login_page.dart';

class VerifyUser extends StatefulWidget {
  UserModel user;
  VerifyUser({Key? key, required this.user}) : super(key: key);

  @override
  State<VerifyUser> createState() => _VerifyUserState();
}

class _VerifyUserState extends State<VerifyUser> {
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

    return user;
  }

  @override
  Widget build(BuildContext context) {
    return widget.user.email == null || widget.user.email == ''
        ? FutureBuilder(
            future: getUser(),
            builder: ((context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done &&
                  user.email != null &&
                  user.email != '') {
                if (user.phoneNumber != '') {
                  UserPreferences().saveData(user);
                  //userProvider.setUser(user);
                  return ProfilePage(
                    user: user,
                    isWantedToOffer: false,
                  );
                } else {
                  return RegisterPhoneNumber(
                    user: user,
                  );
                }
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return const LoginPage();
              }
            }))
        : widget.user.phoneNumber != null && widget.user.phoneNumber != ''
            ? ProfilePage(
                user: widget.user,
                isWantedToOffer: false,
              )
            : RegisterPhoneNumber(
                user: widget.user,
              );
  }
}
