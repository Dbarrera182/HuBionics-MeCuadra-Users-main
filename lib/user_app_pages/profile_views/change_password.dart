import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:me_cuadra_users/colors/colors_data.dart';
import 'package:me_cuadra_users/models/user_model.dart';
import 'package:me_cuadra_users/preferences/user_preference.dart';
import 'package:me_cuadra_users/providers/user_provider.dart';
import 'package:me_cuadra_users/services/const/firebase_constants.dart';
import 'package:me_cuadra_users/services/firebase/crud_employee.dart';
import 'package:me_cuadra_users/services/firebase/user_crud.dart';
import 'package:me_cuadra_users/widgets/simple_dialog_success_widget.dart';
import 'package:me_cuadra_users/widgets/simple_error_dialog_widget.dart';
import 'package:provider/provider.dart';

class ChangePassword extends StatefulWidget {
  UserModel user;
  ChangePassword({Key? key, required this.user}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final sb30 = const SizedBox(height: 30);
  final sb15 = const SizedBox(height: 15);
  TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = true;

  TextEditingController newPasswordController = TextEditingController();
  bool isNewPasswordVisible = true;
  TextEditingController confirmNewPasswordController = TextEditingController();
  bool isConfirmPasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _getAppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              _initText(),
              sb30,
              sb15,
              _informationInputs(),
              sb30,
              sb30,
              sb30,
              _saveButton(),
              sb30,
              sb30,
              _finalMessage()
            ]),
          ),
        ));
  }

  AppBar _getAppBar() {
    return AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
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

  Widget _initText() {
    return Column(
      children: [
        Text('Nueva contraseña',
            style: GoogleFonts.montserrat(
                color: MyColors.blue2,
                fontSize: 28,
                fontWeight: FontWeight.w700),
            textAlign: TextAlign.center),
        sb15,
        Text(
            'Para cambiar la contraseña de tu perfil, por favor ingresa tu contraseña anterior',
            style: GoogleFonts.montserrat(
                color: MyColors.blue2,
                fontSize: 16,
                fontWeight: FontWeight.w400),
            textAlign: TextAlign.center)
      ],
    );
  }

  Widget _informationInputs() {
    return Column(children: [
      Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(27), color: MyColors.whiteBox),
        child: TextField(
          obscureText: isPasswordVisible,
          controller: passwordController,
          textAlign: TextAlign.left,
          style: GoogleFonts.montserrat(
              color: MyColors.grey, fontSize: 18, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            hintText: 'Contraseña',
            hintStyle: GoogleFonts.montserrat(
                color: MyColors.grey,
                fontSize: 18,
                fontWeight: FontWeight.w600),
            border: InputBorder.none,
            counterText: '',
            suffixIcon: GestureDetector(
                onTap: () {
                  isPasswordVisible = !isPasswordVisible;
                  setState(() {});
                },
                child: !isPasswordVisible
                    ? const Icon(
                        Icons.visibility,
                        color: MyColors.blue2,
                      )
                    : const Icon(Icons.visibility_off, color: MyColors.blue2)),
          ),
          maxLength: 50,
        ),
      ),
      sb30,
      sb15,
      Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(27), color: MyColors.whiteBox),
        child: TextField(
          obscureText: isNewPasswordVisible,
          controller: newPasswordController,
          textAlign: TextAlign.left,
          style: GoogleFonts.montserrat(
              color: MyColors.grey, fontSize: 18, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            hintText: 'Nueva contraseña',
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            hintStyle: GoogleFonts.montserrat(
                color: MyColors.grey,
                fontSize: 18,
                fontWeight: FontWeight.w600),
            border: InputBorder.none,
            counterText: '',
            suffixIcon: GestureDetector(
                onTap: () {
                  isNewPasswordVisible = !isNewPasswordVisible;
                  setState(() {});
                },
                child: !isNewPasswordVisible
                    ? const Icon(
                        Icons.visibility,
                        color: MyColors.blue2,
                      )
                    : const Icon(Icons.visibility_off, color: MyColors.blue2)),
          ),
          maxLength: 50,
        ),
      ),
      sb15,
      Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(27), color: MyColors.whiteBox),
        child: TextField(
          obscureText: isConfirmPasswordVisible,
          controller: confirmNewPasswordController,
          textAlign: TextAlign.left,
          style: GoogleFonts.montserrat(
              color: MyColors.grey, fontSize: 18, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            suffixIcon: GestureDetector(
                onTap: () {
                  isConfirmPasswordVisible = !isConfirmPasswordVisible;
                  setState(() {});
                },
                child: !isConfirmPasswordVisible
                    ? const Icon(
                        Icons.visibility,
                        color: MyColors.blue2,
                      )
                    : const Icon(Icons.visibility_off, color: MyColors.blue2)),
            hintText: 'Confirmar contraseña',
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
    ]);
  }

  Widget _saveButton() {
    final userProvider = Provider.of<UserProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(45),
            primary: MyColors.blueMarine,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0))),
        onPressed: () async {
          if (newPasswordController.text == confirmNewPasswordController.text) {
            await changedPassword();
            userProvider.getUserFromPreference();
          } else {
            showDialog(
                context: context,
                builder: (context) => SimpleErrorDialogWidget(
                    description: 'La nueva contraseña no coincide'));
          }
        },
        child: Text(
          'Cambiar contraseña',
          style: GoogleFonts.montserrat(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  changedPassword() async {
    try {
      await userAuth!.updatePassword(newPasswordController.text);
      UserCrud().updateUser(widget.user.id!, widget.user);
      UserPreferences().saveData(widget.user);

      showDialog(
          context: context,
          builder: (context) => SimpleSuccessDialogWidget(
              description: "Tu contraseña ha sido actualizada"));
    } catch (e) {
      print('Error in the changed of password $e');
    }
  }

  Widget _finalMessage() {
    return Column(children: [
      Text('¿Haz olvidado tu contraseña?',
          style: GoogleFonts.montserrat(
              color: MyColors.blue2, fontSize: 14, fontWeight: FontWeight.w400),
          textAlign: TextAlign.center),
      TextButton(
        onPressed: () {},
        child: Text(
          'Click aquí para recordar',
          style: GoogleFonts.montserrat(
              color: MyColors.blue2, fontSize: 20, fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),
      ),
      const SizedBox(height: 10),
    ]);
  }
}
