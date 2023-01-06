import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:me_cuadra_users/services/notifications/fcm_firebase_notification/fcm_service.dart';
import 'package:me_cuadra_users/user_app_pages/user_login/verify_user.dart';

import '../colors/colors_data.dart';
import '../models/user_model.dart';
import '../preferences/user_preference.dart';
import '../services/const/firebase_constants.dart';
import '../services/firebase/user_crud.dart';
import '../widgets/simple_error_dialog_widget.dart';

class FacebookButton extends StatefulWidget {
  const FacebookButton({Key? key}) : super(key: key);

  @override
  State<FacebookButton> createState() => _FacebookButtonState();
}

UserModel userModel = UserModel();
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
      getToken(userModel);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => VerifyUser(
            user: userModel,
          ),
        ),
      );
    } else {
      userModel = UserModel().emptyModel();
      userModel.userName = authInstance.currentUser!.displayName;
      userModel.isVerified = true;
      userModel.email = authInstance.currentUser!.email;
      userModel.photoURL = authInstance.currentUser!.photoURL;
      userModel.id = authInstance.currentUser!.uid;
      getToken(userModel);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => VerifyUser(
            user: userModel,
          ),
        ),
      );
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

class _FacebookButtonState extends State<FacebookButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 70,
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
