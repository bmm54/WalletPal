import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../styles/colors.dart';
import '../styles/icons.dart';

class MyAppBar extends StatefulWidget {
  String name;
  bool back;
  MyAppBar({super.key, required this.name, required this.back});

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Stack(
          alignment: AlignmentDirectional.centerStart,
          children: [
            widget.back == true
                ? InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        border:
                            Border.all(color: Theme.of(context).secondaryHeaderColor, width: 3.0),
                      ),
                      child: const Icon(MyIcons.back),
                    ),
                  )
                : Container(),
            Align(
                alignment: Alignment.center,
                child: Text(
                  widget.name.tr,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.displayLarge!.color,
                      fontSize: 20),
                )),
          ],
        ),
      ),
    );
  }
}
