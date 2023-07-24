import 'package:bstable/ui/styles/colors.dart';
import 'package:flutter/material.dart';

class CustomDeco {
  CustomDeco._();
  static InputDecoration inputDecoration = InputDecoration(
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(15)),
      borderSide: BorderSide(
        color: MyColors.purpule,
        width: 2.0,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(15)),
      borderSide: BorderSide(
        color: MyColors.lightGrey,
        width: 2.0,
      ),
    ),
    hintStyle: TextStyle(
      color: MyColors.lightGrey,
    ),
  );
}
