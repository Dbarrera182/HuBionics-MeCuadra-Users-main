// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:me_cuadra_users/providers/user_provider.dart';
import 'package:me_cuadra_users/services/notifications/fcm_firebase_notification/fcm_service.dart';
import 'package:me_cuadra_users/user_app_pages/profile_views/profile_pages/profile_page.dart';
import 'package:me_cuadra_users/user_app_pages/welcome_pages/init_register_phone_number.dart';
import 'package:provider/provider.dart';

import '../colors/colors_data.dart';
import '../models/user_model.dart';
import '../preferences/user_preference.dart';
import '../services/const/firebase_constants.dart';
import '../services/firebase/user_crud.dart';
import '../widgets/simple_error_dialog_widget.dart';

class InitFacebookButton extends StatefulWidget {
  const InitFacebookButton({Key? key}) : super(key: key);

  @override
  State<InitFacebookButton> createState() => _InitFacebookButtonState();
}

UserModel userModel = UserModel();
String? mtoken = ' ';
Future<void> _facebookSignIn(context) async {
  final facebookLoginResult = await FacebookAuth.instance.login();
  await FacebookAuth.instance.getUserData();

  final facebookAuthCredential =
      FacebookAuthProvider.credential(facebookLoginResult.accessToken!.token);

  try {
    await authInstance.signInWithCredential(facebookAuthCredential);
    userModel =
        await UserCrud().getUserforEmail(authInstance.currentUser!.email!);
    if (userModel.email != null) {
      userModel.singinMethod = 'Facebook';
      UserPreferences().saveData(userModel);
      if (userModel.phoneNumber != null && userModel.phoneNumber != '') {
        getToken(userModel);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ProfilePage(user: userModel, isWantedToOffer: true)),
            (route) => false);
      } else {
        getToken(userModel);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InitRegisterPhoneNumber(user: userModel),
            ));
      }
    } else {
      userModel = UserModel().emptyModel();
      userModel.userName = authInstance.currentUser!.displayName;
      userModel.isVerified = true;
      userModel.email = authInstance.currentUser!.email;
      userModel.photoURL = authInstance.currentUser!.photoURL;
      userModel.id = authInstance.currentUser!.uid;
      userModel.singinMethod = 'Facebook';
      UserCrud().addUser(userModel);
      UserPreferences().saveData(userModel);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InitRegisterPhoneNumber(user: userModel),
          ));
      // MaterialPageRoute(
      //   builder: (context) => ProfilePage(user: userModel),
      // );
    }
  } on FirebaseException catch (error) {
    SimpleErrorDialogWidget(
        description: 'Un error ha ocurrido: ${error.message}');
  } catch (error) {
    SimpleErrorDialogWidget(description: 'Un error ha ocurrido: $error');
  } finally {}
}

class _InitFacebookButtonState extends State<InitFacebookButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 60,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: MyColors.blueFB,
          boxShadow: [
            BoxShadow(
                color: MyColors.shadow.withOpacity(0.16),
                offset: const Offset(5, 6),
                blurRadius: 11,
                spreadRadius: 1)
          ]),
      child: MaterialButton(
          onPressed: () async {
            _facebookSignIn(context);
          },
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: SizedBox(
                    height: 50,
                    // decoration: BoxDecoration(color: Colors.blue),
                    child: Image.asset('assets/Icons/Facebook_logo.png',
                        fit: BoxFit.cover)),
              ),
              const Expanded(
                child: SizedBox(),
              ),
              Expanded(
                flex: 12,
                child: Text(
                  'Iniciar sesión con Facebook',
                  style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                  textAlign: TextAlign.start,
                ),
              )
            ],
          )),
    );
  }
}
