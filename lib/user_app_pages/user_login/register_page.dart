// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../colors/colors_data.dart';
import '../../../models/user_model.dart';
import '../../services/const/firebase_constants.dart';
import '../../services/firebase/user_crud.dart';
import '../../widgets/simple_dialog_success_widget.dart';
import '../../widgets/simple_error_dialog_widget.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final mailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  UserModel user = UserModel();
  bool isLoading = false;
  bool isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _getAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _registerText(),
              _inputsForm(),
              _conditionsText(),
              const SizedBox(height: 20),
              _registerButton(),
              const SizedBox(height: 30),
              _goLoginButton()
            ],
          ),
        ),
      ),
    );
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

  Widget _registerText() {
    return Column(
      children: [
        Text('Crear Cuenta',
            style: GoogleFonts.montserrat(
                color: MyColors.blue2,
                fontSize: 28,
                fontWeight: FontWeight.w700),
            textAlign: TextAlign.center),
        const SizedBox(height: 15),
        Text('Crea tu nueva cuenta usando tu correo electrónico',
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
          controller: mailController,
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
          obscureText: false,
          controller: phoneNumberController,
          keyboardType: TextInputType.phone,
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
              color: MyColors.grey, fontSize: 18, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            hintText: 'Teléfono Móvil',
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
      const SizedBox(height: 40),
      Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(27), color: MyColors.whiteBox),
        child: TextField(
          obscureText: false,
          controller: userNameController,
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
              color: MyColors.grey, fontSize: 18, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            hintText: 'Nombre de Usuario',
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
      const SizedBox(height: 10),
      Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(27), color: MyColors.whiteBox),
        child: TextField(
          obscureText: !isPasswordVisible,
          controller: passwordController,
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
              color: MyColors.grey, fontSize: 18, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            hintText: 'Contraseña',
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
                  isPasswordVisible = !isPasswordVisible;
                  setState(() {});
                },
                child: isPasswordVisible
                    ? const Icon(
                        Icons.visibility,
                        color: MyColors.blue2,
                      )
                    : const Icon(Icons.visibility_off, color: MyColors.blue2)),
          ),
          maxLength: 50,
        ),
      ),
      const SizedBox(height: 40)
    ]);
  }

  Widget _conditionsText() {
    return Text(
        'Al hacer clic en "Crear cuenta", aceptas nuestra Política de privacidad de datos y la Política de cookies.',
        style: GoogleFonts.montserrat(
            color: MyColors.grey7070,
            fontSize: 12,
            fontWeight: FontWeight.w400),
        textAlign: TextAlign.center);
  }

  Widget _registerButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 45),
          primary: MyColors.fuchsia,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0))),
      onPressed: () {
        _registerUser();
      },
      child: Text(
        'Crear Cuenta',
        style: GoogleFonts.montserrat(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
      ),
    );
  }

  void _registerUser() async {
    if (isLoading == false) {
      isLoading = true;
      if (mailController.text.trim() != "" &&
          passwordController.text.trim() != "" &&
          phoneNumberController.text.trim() != "" &&
          userNameController.text.trim() != "") {
        user.userName = userNameController.text.trim();
        user.email = mailController.text.toLowerCase().trim();
        user.phoneNumber = phoneNumberController.text.trim();
        user.photoURL =
            "https://0.soompi.io/wp-content/uploads/sites/8/2018/09/22235702/an%C3%B3nimo.jpg?s=900x600&e=t";
        try {
          final modelUser = await UserCrud().getUserforEmail(user.email!);
          if (modelUser.email == null) {
            await authInstance.createUserWithEmailAndPassword(
                email: user.email!, password: passwordController.text);
            user.id = authInstance.currentUser!.uid;
            user.isVerified = false;
            UserCrud().addUser(user);
            await userAuth!.sendEmailVerification();
            isLoading = false;
            Navigator.pop(context);
            showDialog(
                context: context,
                builder: (context) => SimpleSuccessDialogWidget(
                    description:
                        'Se ha enviado un correo para verificar tu cuenta.\n\nRecuerda revisar tu bandeja de spam'));
          } else {
            isLoading = false;
            showDialog(
                context: context,
                builder: (context) =>
                    SimpleErrorDialogWidget(description: "Usuario ya existe"));
          }
        } on FirebaseAuthException catch (e) {
          isLoading = false;
          // ignore: avoid_print
          showDialog(
              context: context,
              builder: (context) =>
                  SimpleErrorDialogWidget(description: "Error: ${e.message}"));
        }
      } else {
        isLoading = false;
        showDialog(
            context: context,
            builder: (context) => SimpleErrorDialogWidget(
                description: "Recuerde llenar todos los campos"));
      }
    }
  }

  Widget _goLoginButton() {
    return Column(
      children: [
        Text('¿Ya tienes cuenta?',
            style: GoogleFonts.montserrat(
                color: MyColors.blue2,
                fontSize: 14,
                fontWeight: FontWeight.w400),
            textAlign: TextAlign.center),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Ingresa Aquí',
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
}
