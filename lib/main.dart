// ignore_for_file: unused_import

import 'package:bstable/screens/Home/Home.dart';
import 'package:bstable/screens/Home/add.dart';
import 'package:bstable/screens/Home/calculator.dart';
import 'package:bstable/screens/Home/settings.dart';
import 'package:bstable/ui/components/card.dart';
import 'package:bstable/ui/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}
/*final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const Home();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'settings',
          builder: (BuildContext context, GoRouterState state) {
            return const Settings();
          },),
          //add more routes here
      ],

    ),
  ],
);*/

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetMaterialApp(
        theme: ThemeData(fontFamily: 'Gilory',scaffoldBackgroundColor: Colors.white,iconTheme: IconThemeData(color: MyColors.iconColor,size: 30)),
        debugShowCheckedModeBanner: false,
        home: Home(),
      ),
    );
  }
}