// ignore_for_file: must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:me_cuadra_users/models/user_model.dart';
import 'package:me_cuadra_users/preferences/user_preference.dart';
import 'package:me_cuadra_users/providers/user_provider.dart';
import 'package:me_cuadra_users/services/const/firebase_constants.dart';
import 'package:me_cuadra_users/services/firebase/user_crud.dart';
import 'package:me_cuadra_users/services/notifications/fcm_firebase_notification/fcm_service.dart';
import 'package:me_cuadra_users/user_app_pages/user_login/verify_user.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../colors/colors_data.dart';
import '../profile_views/profile_pages/profile_page.dart';

class RegisterPhoneNumber extends StatefulWidget {
  UserModel user;
  RegisterPhoneNumber({Key? key, required this.user}) : super(key: key);

  @override
  State<RegisterPhoneNumber> createState() => _RegisterPhoneNumberState();
}

class _RegisterPhoneNumberState extends State<RegisterPhoneNumber> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  UserModel newUser = UserModel();
  double screenHeight = 0;
  double screenWidth = 0;
  double bottom = 0;
  bool isLoading = false;
  String otpPin = " ";
  String countryDial = "+57";
  String verID = " ";

  int screenState = 0;

  Color blue = const Color(0xff8cccff);

  Future<void> verifyPhone(String number) async {
    if (isLoading == false) {
      setState(() => isLoading = true);
      await authInstance.verifyPhoneNumber(
        phoneNumber: number,
        timeout: const Duration(seconds: 20),
        verificationCompleted: (PhoneAuthCredential credential) {
          setState(() => isLoading = false);
          showSnackBarText("Verificaci??n completada!");
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() => isLoading = false);
          showSnackBarText("Verificaci??n fallida! ${e.message}");
        },
        codeSent: (String verificationId, int? resendToken) {
          isLoading = false;
          showSnackBarText("Mensaje enviado!");
          verID = verificationId;
          setState(() {
            screenState = 1;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() => isLoading = false);
          showSnackBarText("Se acabo el tiempo! ??Deseas reenviar el mensaje?");
        },
      );
    }
  }

  Future<void> verifyOTP() async {
    if (isLoading == false) {
      setState(() => isLoading = true);
      try {
        await authInstance
            .signInWithCredential(
          PhoneAuthProvider.credential(
            verificationId: verID,
            smsCode: otpPin,
          ),
        )
            .whenComplete(() async {
          setState(() => isLoading = false);
          if (authInstance.currentUser!.phoneNumber != null) {
            newUser.phoneNumber = countryDial + phoneController.text;
            if (newUser.userToken == null || newUser.userToken == '') {
              newUser.userToken = await getTokenString(newUser);
            }

            UserCrud().updateUser(newUser.id!, newUser);
            UserPreferences().saveData(newUser);

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) =>
                    ProfilePage(user: newUser, isWantedToOffer: false),
              ),
            );
          }
        });
      } on FirebaseAuthException catch (e) {
        showSnackBarText("Ha ocurrido un error: ${e.message}");
        setState(() => isLoading = false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    newUser = widget.user;
  }

  AppBar _getAppBar() {
    final userProvider = Provider.of<UserProvider>(context);
    return AppBar(
        leading: IconButton(
            onPressed: () async {
              authInstance.signOut();
              GoogleSignIn().signOut();
              UserPreferences().clearData();
              userProvider.cleanUser();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VerifyUser(user: UserModel()),
                  ),
                  (_) => false);
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

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    bottom = MediaQuery.of(context).viewInsets.bottom;

    return WillPopScope(
      onWillPop: () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => VerifyUser(user: UserModel()),
            ),
            (_) => false);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: _getAppBar(),
        backgroundColor: Colors.white,
        body: SizedBox(
          height: screenHeight,
          width: screenWidth,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: screenHeight / 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "ESTAS A UN PASO DE REGISTRARTE",
                        style: GoogleFonts.montserrat(
                          color: MyColors.blue2,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      Text(
                        "Confirma tu n??mero de tel??fono!",
                        style: GoogleFonts.montserrat(
                            color: MyColors.grey,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedContainer(
                  height: bottom > 0 ? screenHeight : screenHeight / 2,
                  width: screenWidth,
                  color: Colors.white,
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.fastLinearToSlowEaseIn,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: screenWidth / 12,
                      right: screenWidth / 12,
                      top: bottom > 0 ? screenHeight / 12 : 0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        screenState == 0 ? stateRegister() : stateOTP(),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shadowColor: Colors.black26,
                              minimumSize: const Size.fromHeight(45),
                              primary: MyColors.fuchsia,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0))),
                          onPressed: () {
                            if (screenState == 0) {
                              if (phoneController.text.isEmpty ||
                                  phoneController.text.length < 10) {
                                showSnackBarText(
                                    "Ingrese un n??mero de tel??fono valido!");
                              } else {
                                verifyPhone(countryDial + phoneController.text);
                              }
                            } else {
                              if (otpPin.length >= 6) {
                                verifyOTP();
                              } else {
                                showSnackBarText("Enter OTP correctly!");
                              }
                            }
                          },
                          child: Center(
                            child: isLoading == false
                                ? Text(
                                    'Continuar',
                                    style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                      Text(
                                        'Cargando...',
                                        style: GoogleFonts.montserrat(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showSnackBarText(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  Widget stateRegister() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 16,
        ),
        Text(
          "N??mero de tel??fono",
          style: GoogleFonts.montserrat(
              color: MyColors.blue2, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 8,
        ),
        IntlPhoneField(
          controller: phoneController,
          invalidNumberMessage: 'N??mero de tel??fono incorrecto',
          dropdownTextStyle: GoogleFonts.montserrat(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
          showCountryFlag: true,
          showDropdownIcon: true,
          initialValue: countryDial,
          style: GoogleFonts.montserrat(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
          onCountryChanged: (country) {
            setState(() {
              countryDial = "+" + country.dialCode;
            });
          },
          decoration: InputDecoration(
            counterText: '',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget stateOTP() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: "Acabamos de mandar un c??digo a ",
                style: GoogleFonts.montserrat(
                    color: MyColors.blue2,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
              TextSpan(
                text: countryDial + ' ' + phoneController.text,
                style: GoogleFonts.montserrat(
                  color: MyColors.blue2,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              TextSpan(
                text: "\nIntroduce el c??digo aqu?? para continuar!",
                style: GoogleFonts.montserrat(
                  color: MyColors.blue2,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        PinCodeTextField(
          onAutoFillDisposeAction: AutofillContextAction.commit,
          appContext: context,
          length: 6,
          onChanged: (value) {
            setState(() {
              otpPin = value;
            });
          },
          pinTheme: PinTheme(
            activeColor: blue,
            selectedColor: blue,
            inactiveColor: Colors.black26,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "??No recibiste el c??digo?  ",
                style: GoogleFonts.montserrat(
                  color: MyColors.blue2,
                  fontSize: 12,
                ),
              ),
              WidgetSpan(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      screenState = 0;
                    });
                  },
                  child: Text(
                    "Reenviar",
                    style: GoogleFonts.montserrat(
                      color: MyColors.fuchsia,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
