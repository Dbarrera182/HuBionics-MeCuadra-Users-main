// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../colors/colors_data.dart';

class IntroPageWidget extends StatelessWidget {
  String assetImage;
  String title;
  String subtitle;
  String description;
  IntroPageWidget(
      {Key? key,
      required this.assetImage,
      required this.title,
      required this.subtitle,
      required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: size.height * 0.5,
            decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage(assetImage))),
          ),
          Text(
            title,
            style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: MyColors.blue2)),
            textAlign: TextAlign.center,
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              TextSpan(
                  text: subtitle,
                  style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: MyColors.blue2))),
              TextSpan(
                  text: description,
                  style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: MyColors.blue2))),
            ]),
          )
        ],
      ),
    );
  }
}
