import 'package:bstable/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../ui/styles/colors.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  void error(String e){
    Get.snackbar("Error", e,backgroundColor: const Color.fromARGB(255, 184, 227, 247));
  }
  @override
  Widget build(BuildContext context) {
    final _auth = AuthService();
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: GestureDetector(
                onTap: () {
                  _auth.signInWithGoogle((errorMessage) {
                    error(errorMessage);
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  //border
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                                TextStyle(fontSize: 20, color: MyColors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: GestureDetector(
                onTap: () {
                  _auth.signInAnon();
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  //border
                  decoration: BoxDecoration(
                    color: Colors.white,
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
            ),
          ],
        ),
      ),
    );
  }
}
