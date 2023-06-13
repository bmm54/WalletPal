import 'package:bstable/screens/Home/Home.dart';
import 'package:bstable/ui/components/card.dart';
import 'package:bstable/ui/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Gilory',scaffoldBackgroundColor: Colors.white,iconTheme: IconThemeData(color: MyColors.iconColor,size: 30)),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}