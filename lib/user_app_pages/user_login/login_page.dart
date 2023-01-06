// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:me_cuadra_users/providers/user_provider.dart';
import 'package:me_cuadra_users/services/notifications/fcm_firebase_notification/fcm_service.dart';
import 'package:me_cuadra_users/user_app_pages/welcome_pages/forgot_my_password_page.dart';
import 'package:provider/provider.dart';

import '../../../models/user_model.dart';
import '../../../widgets/simple_error_dialog_widget.dart';
import '../../colors/colors_data.dart';
import '../../controllers/facebook_button.dart';
import '../../controllers/google_button.dart';
import '../../preferences/user_preference.dart';
import '../../services/const/firebase_constants.dart';
import '../../services/firebase/user_crud.dart';
import '../profile_views/profile_pages/profile_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final userController = TextEditingController();
  final passwordController = TextEditingController();
  UserModel user = UserModel();
  bool _isVisible = false;
  bool isLoading = false;
  String? mtoken = " ";

  @override
  void dispose() {
    userController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    //FirebaseAuth.instance.signOut();
    super.initState();
    if (authInstance.currentUser == null) {
      userController.text == '';
      passwordController.text == '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamedAndRemoveUntil(
            context, 'home_page', (route) => false);

        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _getAppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _welcomeText(),
                _inputsForm(),
                _loginButton(),
                const SizedBox(height: 6),
                _forgetPassword(),
                const SizedBox(height: 80),
                _registerText(),
                Container(
                  width: double.maxFinite,
                  height: 5,
                  color: MyColors.grey.withOpacity(0.1),
                ),
                _loginWithGoogle()
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _getAppBar() {
    return AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, 'home_page', (route) => false);
            },
            icon: SvgPicture.asset(
              'assets/Icons/Flecha Atras.svg',
              width: 25,
              height: 25,
              color: Colors.white,
            )),
        centerTitle: true,
        title: SvgPicture.asset(
          'assets/Icons/LogoSVG.svg',
          width: 30,
          height: 30,
          color: MyColors.blue2,
        ));
  }

  Widget _welcomeText() {
    return Column(
      children: [
        Text('Bienvenido',
            style: GoogleFonts.montserrat(
                color: MyColors.blue2,
                fontSize: 28,
                fontWeight: FontWeight.w700),
            textAlign: TextAlign.center),
        const SizedBox(height: 15),
        Text('Accede a tu cuenta usando  usando tu correo electrónico',
            style: GoogleFonts.montserrat(
                color: MyColors.blue2,
                fontSize: 16,
                fontWeight: FontWeight.w400),
            textAlign: TextAlign.center),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _inputsForm() {
    return Column(children: [
      Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(27), color: MyColors.whiteBox),
        child: TextField(
          controller: userController,
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
              color: MyColors.grey, fontSize: 18, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            hintText: 'Correo Electrónico',
            hintStyle: GoogleFonts.montserrat(
                color: MyColors.grey,
                fontSize: 18,
                fontWeight: FontWeight.w600),
            border: InputBorder.none,
            counterText: '',
          ),
          maxLength: 50,
        ),
      ),
      const SizedBox(height: 10),
      Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(27), color: MyColors.whiteBox),
        child: TextField(
          obscureText: !_isVisible,
          controller: passwordController,
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
              color: MyColors.grey, fontSize: 18, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            suffixIcon: GestureDetector(
                onTap: () {
                  if (_isVisible) {
                    _isVisible = false;
                  } else {
                    _isVisible = true;
                  }
                  setState(() {});
                },
                child: _isVisible
                    ? const Icon(
                        Icons.visibility,
                        color: MyColors.blue2,
                      )
                    : const Icon(Icons.visibility_off, color: MyColors.blue2)),
            hintText: 'Contraseña',
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            hintStyle: GoogleFonts.montserrat(
                color: MyColors.grey,
                fontSize: 18,
                fontWeight: FontWeight.w600),
            border: InputBorder.none,
            counterText: '',
          ),
          maxLength: 50,
        ),
      ),
      const SizedBox(height: 30)
    ]);
  }

  Widget _loginButton() {
    final userProvider = Provider.of<UserProvider>(context);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 45),
          primary: MyColors.fuchsia,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0))),
      onPressed: () {
        if (userController.text.trim() == "" ||
            passwordController.text.trim() == "") {
          showDialog(
              context: context,
              builder: (context) => SimpleErrorDialogWidget(
                  description: "Recuerde llenar todos los campos"));
        } else {
          _login(userProvider);
        }
      },
      child: Text(
        'Iniciar sesión',
        style: GoogleFonts.montserrat(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
      ),
    );
  }

  _login(UserProvider userProvider) async {
    if (isLoading == false) {
      isLoading = true;
      user = await UserCrud()
          .getUserforEmail(userController.text.trim().toLowerCase());
      // ignore: unnecessary_null_comparison
      if (user.email == null) {
        isLoading = false;
        showDialog(
            context: context,
            builder: (context) => SimpleErrorDialogWidget(
                description:
                    "El usuario no ha sido encontrado en la base de datos,\n por favor registrarse..."));
      } else if (user.isVerified!) {
        try {
          await authInstance.signInWithEmailAndPassword(
              email: userController.text.trim().toLowerCase(),
              password: passwordController.text.trim());
          user.singinMethod = 'Correo';
          await getToken(user);
          await userProvider.getUserFromPreference();
          isLoading = false;
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ProfilePage(user: user, isWantedToOffer: false),
              ));
        } on FirebaseAuthException catch (e) {
          isLoading = false;
          showDialog(
              context: context,
              builder: (context) =>
                  SimpleErrorDialogWidget(description: e.message!));
        }
      } else {
        try {
          bool isEmailVerified = false;
          await authInstance.signInWithEmailAndPassword(
              email: userController.text.trim().toLowerCase(),
              password: passwordController.text.trim());
          isEmailVerified = authInstance.currentUser!.emailVerified;

          if (isEmailVerified) {
            user.isVerified = true;
            user.singinMethod = 'Correo';
            await getToken(user);
            await userProvider.getUserFromPreference();
            isLoading = false;
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProfilePage(user: user, isWantedToOffer: false),
                ));
          } else {
            final fireUser = authInstance.currentUser!;
            await fireUser.sendEmailVerification();
            isLoading = false;
            showDialog(
                context: context,
                builder: (context) => Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      child: _verifiedDialog(context),
                    ));
          }
        } on FirebaseAuthException catch (e) {
          isLoading = false;
          showDialog(
              context: context,
              builder: (context) =>
                  SimpleErrorDialogWidget(description: e.message!));
        }
      }
    }
  }

  _verifiedDialog(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(17),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Usuario no verificado",
                  style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24.0),
                CircleAvatar(
                  radius: 105,
                  backgroundColor: MyColors.fuchsia.withOpacity(0.4),
                  child: MaterialButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ));
                      },
                      child: Container(
                        height: 180,
                        width: 180,
                        decoration: BoxDecoration(
                            color: MyColors.fuchsia.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(110),
                            boxShadow: [
                              BoxShadow(
                                color: MyColors.grey.withOpacity(1),
                                offset: const Offset(5, 6),
                                blurRadius: 6,
                              )
                            ]),
                        child: const Icon(
                          Icons.priority_high_rounded,
                          color: Colors.white,
                          size: 140,
                        ),
                      )),
                ),
                const SizedBox(height: 24.0),
                Text(
                  "Se ha enviado un correo de verificación... \n Recuerda revisar tu bandeja de spam",
                  style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 60.0),
              ],
            )),
      ],
    );
  }

  Widget _forgetPassword() {
    return TextButton(
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ForgotMyPassword()));
      },
      child: Text(
        'He olvidado mi contraseña',
        style: GoogleFonts.montserrat(
            color: MyColors.blue2, fontSize: 13, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _registerText() {
    return Column(
      children: [
        Text('¿No tienes cuenta?',
            style: GoogleFonts.montserrat(
                color: MyColors.blue2,
                fontSize: 13,
                fontWeight: FontWeight.w400),
            textAlign: TextAlign.center),
        TextButton(
          onPressed: () {
            authInstance.signOut();
            Navigator.pushNamed(context, 'register_page');
          },
          child: Text('Registrate Aquí',
              style: GoogleFonts.montserrat(
                  color: MyColors.blue2,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
              textAlign: TextAlign.center),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _loginWithGoogle() {
    return Column(
      children: [
        const SizedBox(height: 20),
        GoogleButton(),
        const SizedBox(height: 20),
        const FacebookButton()
      ],
    );
  }
}
