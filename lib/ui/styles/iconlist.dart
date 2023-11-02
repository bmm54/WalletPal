import 'package:bstable/ui/styles/colors.dart';
import 'package:bstable/ui/styles/icons.dart';
import 'package:flutter/material.dart';

class IconsList {
  static Map<String, IconData> categories = {
    "Food": MyIcons.food,
    "Restaurent": MyIcons.restaurent,
    "Cafe": MyIcons.cafe,
    "Transport": MyIcons.transport,
    "Grocery": MyIcons.grocery,
    "Housing": MyIcons.house,
    "Shopping": MyIcons.shopping,
    "Internet": MyIcons.internet,
    "Loan": MyIcons.loan,
    "Salary": MyIcons.cashin,
    "Sent":Icons.output_rounded,
    "Received":Icons.input_rounded,
    "Expense":MyIcons.bag,
    "Income":MyIcons.bag,
    "Entertainment":MyIcons.gamepad,
  };
  static Map<String, Color> colors = {
    "Food": MyColors.orange,
    "Restaurent": MyColors.lightBlue,
    "Cafe": MyColors.red,
    "Transport": MyColors.blue,
    "Grocery": MyColors.orange,
    "Housing": MyColors.purpule,
    "Shopping": MyColors.blue,
    "Internet": MyColors.darkBorder,
    "Loan": Colors.lightGreen,
    "Salary": MyColors.green,
    "Sent":Colors.redAccent,
    "Received":Colors.greenAccent,
    "Expense":MyColors.red,
    "Income":MyColors.green,
    "Entertainment":Colors.cyanAccent,
  };
  static get_icon(String name) {
    return categories[name];
  }

  static get_color(String name) {
    return colors[name];
  }
}

