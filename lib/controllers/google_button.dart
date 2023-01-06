import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:me_cuadra_users/services/notifications/fcm_firebase_notification/fcm_service.dart';
import 'package:me_cuadra_users/user_app_pages/user_login/verify_user.dart';

import '../colors/colors_data.dart';
import '../models/user_model.dart';
import '../preferences/user_preference.dart';
import '../services/const/firebase_constants.dart';
import '../services/firebase/user_crud.dart';
import '../widgets/simple_error_dialog_widget.dart';

// ignore: must_be_immutable
class GoogleButton extends StatelessWidget {
  GoogleButton({Key? key}) : super(key: key);

  UserModel userModel = UserModel();
  Future<void> _googleSignIn(context) async {
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        try {
          await authInstance.signInWithCredential(GoogleAuthProvider.credential(
              idToken: googleAuth.idToken,
              accessToken: googleAuth.accessToken));
          userModel = await UserCrud()
              .getUserforEmail(authInstance.currentUser!.email!);
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
          }
        } on FirebaseException catch (error) {
          SimpleErrorDialogWidget(
              description: 'Un error ha ocurrido: ${error.message}');
        } catch (error) {
          SimpleErrorDialogWidget(description: 'Un error ha ocurrido: $error');
        } finally {}
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: double.maxFinite,
        height: 70,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: MyColors.whiteBox,
            boxShadow: [
              BoxShadow(
                  color: MyColors.shadow.withOpacity(0.16),
                  offset: const Offset(5, 6),
                  blurRadius: 11)
            ]),
        child: MaterialButton(
            onPressed: () async {
              _googleSignIn(context);
            },
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: SizedBox(
                      width: 50,
                      height: 50,
                      child: Image.asset('assets/Icons/googleLogo.png',
                          fit: BoxFit.cover)),
                ),
                const Expanded(
                  child: SizedBox(),
                ),
                Expanded(
                  flex: 12,
                  child: Text(
                    'Iniciar sesión con Google',
                    style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.start,
                  ),
                )
              ],
            )),
      ),
    );
  }
}
