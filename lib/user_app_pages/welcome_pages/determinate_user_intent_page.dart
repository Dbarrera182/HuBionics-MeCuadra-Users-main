// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:me_cuadra_users/models/user_model.dart';
import 'package:me_cuadra_users/providers/user_provider.dart';
import 'package:me_cuadra_users/user_app_pages/profile_views/send_property_request.dart';
import 'package:me_cuadra_users/user_app_pages/welcome_pages/home_page.dart';
import 'package:provider/provider.dart';

import '../../colors/colors_data.dart';

class DeterminateUserIntent extends StatefulWidget {
  UserModel user;
  DeterminateUserIntent({Key? key, required this.user}) : super(key: key);

  @override
  State<DeterminateUserIntent> createState() => _DeterminateUserIntentState();
}

class _DeterminateUserIntentState extends State<DeterminateUserIntent> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final userProvider = Provider.of<UserProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('¿Estas seguro?'),
                content: const Text('¿Quieres salir de MeCuadra?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () =>
                        Navigator.of(context).pop(false), //<-- SEE HERE
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.of(context).pop(true), // <-- SEE HERE
                    child: const Text('Si'),
                  ),
                ],
              ),
            ) ??
            false;
      },
      child: Scaffold(
        appBar: getAppBar(),
        body: SizedBox(
          height: size.height,
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  flex: 35,
                  child: Container(
                    width: double.maxFinite,
                    height: double.maxFinite,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                              'assets/building.webp',
                            ),
                            fit: BoxFit.cover)),
                  )),
              const SizedBox(height: 15),
              Expanded(
                flex: 65,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      Text(
                        '¿Por donde quieres comenzar?',
                        style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: MyColors.blue2)),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(60),
                            primary: MyColors.whiteBox,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0))),
                        onPressed: () async {
                          await userProvider.getUserFromPreference();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()),
                              (route) => false);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Buscar\nPropiedades',
                                style: GoogleFonts.montserrat(
                                    textStyle: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                        color: MyColors.grey)),
                                textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(60),
                            primary: MyColors.whiteBox,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0))),
                        onPressed: () async {
                          await userProvider.getUserFromPreference();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SendPropertyRequest(user: widget.user),
                              ),
                              (route) => false);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Ofertar\nMi propiedad',
                                style: GoogleFonts.montserrat(
                                    textStyle: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                        color: MyColors.grey)),
                                textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar getAppBar() {
    return AppBar(
      centerTitle: true,
      title: SvgPicture.asset(
        'assets/Icons/LogoSVG.svg',
        width: 30,
        height: 30,
        color: MyColors.blue2,
      ),
    );
  }
}
