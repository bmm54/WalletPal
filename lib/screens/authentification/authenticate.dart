import 'package:bstable/services/auth.dart';
import 'package:bstable/services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../ui/styles/colors.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  void error(String e){
    Get.snackbar("Error", e,backgroundColor: Theme.of(context).primaryColor);
  }
  @override
  Widget build(BuildContext context) {
    final _auth = AuthService();
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Transform.rotate(
                        angle: 90 * 3.14 / 180, child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 50,horizontal: 10),
                          child: Text("Wel\nCome.",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 70,color:ThemeService().getThemeMode()==ThemeMode.dark?Colors.white:MyColors.logoColor,),),
                        )),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40,horizontal: 20),
                      child: SvgPicture.asset(
                        'lib/assets/images/logo.svg',
                        width: 50, // Set the width of the SVG image
                        height: 50, // Set the height of the SVG image
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Stack(
              alignment:Alignment.bottomCenter,
              children: [
                Stack(
                  children: [
                    SvgPicture.asset(
                      'lib/assets/images/vector1.svg',
                      colorFilter:ThemeService().getThemeMode()==ThemeMode.dark?ColorFilter.mode(Colors.white, BlendMode.srcIn):ColorFilter.mode(MyColors.logoColor, BlendMode.srcIn),
                      width: Get.width, // Set the width of the SVG image
                      height: Get.width, // Set the height of the SVG image
                    ),
                    SvgPicture.asset(
                      'lib/assets/images/vector2.svg',
                      width: Get.width, // Set the width of the SVG image
                      height: Get.width, // Set the height of the SVG image
                    ),
                  ],
                ),
                Align(
                  child: Column(
                    children: [
                  GestureDetector(
                    onTap: () {
                      _auth.signInWithGoogle((errorMessage) {
                        error(errorMessage);
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      //border
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: MyColors.blue,
                          width: 2,
                        ),
                      ),
                      height: 60,
                      width: Get.width * 0.9,
                      child: Center(
                        child: Stack(
                          alignment: AlignmentDirectional.centerStart,
                          children: [
                            Container(
                                height: 50,
                                width: 50,
                                child: Image.asset(
                                    "lib/assets/images/google_logo.png")),
                            Align(
                              child: Text(
                                "Sign in With Google",
                                style:
                                    TextStyle(fontWeight: FontWeight.bold,fontSize: 20, color: MyColors.blue),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                      GestureDetector(
                        onTap: () {
                          _auth.signInAnon();
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          //border
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: MyColors.lightGrey,
                              width: 2,
                            ),
                          ),
                          height: 60,
                          width: Get.width * 0.9,
                          child: Center(
                            child: Stack(
                              alignment: AlignmentDirectional.centerStart,
                              children: [
                                Container(
                                    height: 50,
                                    width: 50,
                                    child: Icon(Icons.person,color: MyColors.lightGrey,size: 40,)),
                                Align(
                                  child: Text(
                                    "Sign in Anonymously",
                                    style:
                                        TextStyle(fontSize: 20, color: MyColors.lightGrey),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
