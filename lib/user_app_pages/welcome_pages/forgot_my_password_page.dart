import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:me_cuadra_users/colors/colors_data.dart';
import 'package:me_cuadra_users/widgets/simple_dialog_success_widget.dart';
import 'package:me_cuadra_users/widgets/simple_error_dialog_widget.dart';

class ForgotMyPassword extends StatefulWidget {
  const ForgotMyPassword({Key? key}) : super(key: key);

  @override
  State<ForgotMyPassword> createState() => _ForgotMyPasswordState();
}

class _ForgotMyPasswordState extends State<ForgotMyPassword> {
  TextEditingController emailController = TextEditingController();
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Form(
          key: _formKey,
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            const SizedBox(height: 20),
            Text(
                'Ingrese su correo eléctronico y le enviaremos un enlace para restablecer su contraseña',
                style: GoogleFonts.montserrat(
                    color: MyColors.blue2,
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.center),
            const SizedBox(height: 40),
            Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(27),
                  color: MyColors.whiteBox),
              child: TextFormField(
                controller: emailController,
                textCapitalization: TextCapitalization.sentences,
                validator: (String? value) {
                  if (value!.isEmpty ||
                      value.length < 8 ||
                      value.length > 50 ||
                      !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}')
                          .hasMatch(value)) {
                    return 'Ingrese un correo válido';
                  } else {
                    return null;
                  }
                },
                textAlign: TextAlign.start,
                style: const TextStyle(
                    color: MyColors.blue2,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  hintText: 'Correo Electrónico',
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  hintStyle: GoogleFonts.montserrat(
                      color: MyColors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                  border: InputBorder.none,
                  counterText: '',
                ),
                maxLength: 100,
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 7, horizontal: 45),
                  primary: MyColors.fuchsia,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0))),
              onPressed: () {
                if (isLoading == false) {
                  isLoading = true;
                  if (emailController.text.trim() == "") {
                    isLoading = false;
                    showDialog(
                        context: context,
                        builder: (context) => SimpleErrorDialogWidget(
                            description:
                                "Recuerde ingresar su correo electrónico"));
                  } else if (_formKey.currentState!.validate()) {
                    passwordReset();
                  } else {
                    isLoading = false;
                    showDialog(
                        context: context,
                        builder: (context) => SimpleErrorDialogWidget(
                            description:
                                "Ingrese un correo electrónico valido"));
                  }
                }
              },
              child: Text(
                'Restablecer',
                style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  AppBar _getAppBar() {
    return AppBar(
        centerTitle: true,
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
        title: SvgPicture.asset(
          'assets/Icons/LogoSVG.svg',
          width: 30,
          height: 30,
          color: MyColors.blue2,
        ));
  }

  passwordReset() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: emailController.text.trim().toLowerCase());
      isLoading = false;
      showDialog(
          context: context,
          builder: (context) => SimpleSuccessDialogWidget(
                description:
                    'Se ha enviado un mensaje para restablecer tu contraseña \n\nRecuerda revidar tu bandeja de spam',
              ));
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      showDialog(
          context: context,
          builder: (context) =>
              SimpleErrorDialogWidget(description: e.message!));
    }
  }
}
