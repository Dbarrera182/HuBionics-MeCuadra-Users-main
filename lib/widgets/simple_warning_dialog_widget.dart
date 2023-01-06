// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../colors/colors_data.dart';

// ignore: must_be_immutable
class SimpleWarningDialogWidget extends StatelessWidget {
  String description;
  SimpleWarningDialogWidget({Key? key, required this.description})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(0),
      child: _dialogContent(context),
    );
  }

  _dialogContent(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
              width: size.width,
              height: size.height,
              decoration: const BoxDecoration(
                color: MyColors.grey,
                shape: BoxShape.rectangle,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 105,
                      backgroundColor: MyColors.fuchsia.withOpacity(0.4),
                      child: const CircleAvatar(
                        radius: 90,
                        backgroundColor: MyColors.fuchsia,
                        child: Icon(
                          Icons.priority_high_rounded,
                          color: Colors.white,
                          size: 140,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    Text(
                      description,
                      style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )),
        ),
      ],
    );
  }
}
