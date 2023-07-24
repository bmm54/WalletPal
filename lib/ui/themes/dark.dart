import 'package:bstable/ui/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  dropdownMenuTheme: DropdownMenuThemeData(
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: MyColors.darkBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: MyColors.darkBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: MyColors.darkBorder),
      ),
      labelStyle: TextStyle(color: MyColors.lightGrey),
      hintStyle: TextStyle(color: MyColors.lightGrey),
    ),
  ),
  secondaryHeaderColor: MyColors.darkBorder,
  fontFamily: GoogleFonts.roboto().fontFamily,
  scaffoldBackgroundColor: MyColors.darkPurple,
  primaryColor: MyColors.buttonDark,
  iconTheme: IconThemeData(color: MyColors.lightGrey, size: 30),
  textTheme: TextTheme(
    displayLarge: TextStyle(
      color: MyColors.lightGrey,
      fontSize: 30,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    displaySmall: TextStyle(
      color: Colors.white,
      fontSize: 15,
      fontWeight: FontWeight.bold,
    ),
  ),
);
