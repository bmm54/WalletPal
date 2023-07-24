import 'package:bstable/firebase_options.dart';
import 'package:bstable/ui/styles/colors.dart';
import 'package:bstable/ui/themes/dark.dart';
import 'package:bstable/ui/themes/light.dart';
import 'package:bstable/ui/themes/notifier.dart';
import 'package:bstable/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
        darkTheme: darkTheme,
        theme: lightTheme,
        themeMode:Get.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
      ),
    );
  }
}
