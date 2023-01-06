// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../colors/colors_data.dart';

// ignore: must_be_immutable
class SimpleSuccessDialogWidget extends StatelessWidget {
  String description;
  SimpleSuccessDialogWidget({Key? key, required this.description})
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
              width: double.maxFinite,
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
                  children: [
                    CircleAvatar(
                      radius: 105,
                      backgroundColor: MyColors.blueMarine.withOpacity(0.4),
                      child: const CircleAvatar(
                        radius: 90,
                        backgroundColor: MyColors.blueMarine,
                        child: Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 140,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    Text(
                      description,
                      style: const TextStyle(
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
