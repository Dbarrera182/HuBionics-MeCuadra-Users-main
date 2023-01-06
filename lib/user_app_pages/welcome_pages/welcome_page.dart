import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../colors/colors_data.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('¿Estas seguro?'),
                content: const Text('¿Quieres salir de MeCuadra?'),
                actions: [
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
      child: Material(
        color: MyColors.blueMarine,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
              width: size.width,
              height: size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(height: size.height * 0.22),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/LogoM.svg',
                        width: 50,
                        height: 50,
                        color: MyColors.blue2,
                      ),
                      Text(
                        'MeCuadra',
                        style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: MyColors.blue2)),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.18),
                  Text(
                    'Bienvenido',
                    style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: MyColors.blue2)),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Descubre todo lo que puedes hacer en nuestra aplicación, iniciando un recorrido rápido por nuestras funciones',
                    style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: MyColors.blue2)),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(45),
                          primary: MyColors.fuchsia,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0))),
                      onPressed: () {
                        Navigator.pushNamed(context, 'intro_pages');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Iniciar recorrido',
                            style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 10),
                          SvgPicture.asset(
                            'assets/Icons/Next.svg',
                            width: 20,
                            height: 20,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
