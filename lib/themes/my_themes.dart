import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../colors/colors_data.dart';

class ThemeProvi extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}

class MyThemes {
  static const primary = MyColors.blueMarine;
  static const secundary = Colors.red;
  static const primaryColor = Colors.white;

  static final lightTheme = ThemeData(
    inputDecorationTheme: const InputDecorationTheme(
        iconColor: Colors.black,
        labelStyle: TextStyle(color: Colors.black),
        helperStyle: TextStyle(color: Colors.black)),
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(primary: primary),
    primaryColorDark: primaryColor,
    dividerColor: Colors.black,
    textTheme: GoogleFonts.montserratTextTheme(),
  );
}
