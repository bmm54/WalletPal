import 'package:bstable/ui/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  fontFamily: GoogleFonts.roboto().fontFamily,
  scaffoldBackgroundColor: Colors.white,
  primaryColor: MyColors.buttonGrey,
  secondaryHeaderColor: MyColors.borderColor,
  iconTheme: IconThemeData(color: MyColors.iconColor,size: 30),
  textTheme: TextTheme(
    displayLarge: TextStyle(
      color: MyColors.iconColor,
      fontSize: 30,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: TextStyle(
      color: MyColors.iconColor,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    displaySmall: TextStyle(
      color: Colors.black,
      fontSize: 15,
      fontWeight: FontWeight.bold,
    ),
  ),
);