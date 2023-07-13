// ignore_for_file: unused_import

import 'package:bstable/firebase_options.dart';
import 'package:bstable/screens/Home/Home.dart';
import 'package:bstable/screens/Home/add.dart';
import 'package:bstable/screens/Home/calculator.dart';
import 'package:bstable/screens/Home/settings.dart';
import 'package:bstable/sql/getData.dart';
import 'package:bstable/sql/sql_helper.dart';
import 'package:bstable/ui/components/card.dart';
import 'package:bstable/ui/styles/colors.dart';
import 'package:bstable/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    //SQLHelper.deleteAllActivities();
    //SQLHelper.deleteAllAccount();
    return SafeArea(
      child: GetMaterialApp(
        theme: ThemeData(
            fontFamily: 'Gilory',
            scaffoldBackgroundColor: Colors.white,
            iconTheme: IconThemeData(color: MyColors.iconColor, size: 30),),
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
      ),
    );
  }
}
