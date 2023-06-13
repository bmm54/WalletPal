// ignore_for_file: prefer_const_constructors

import 'package:bstable/ui/styles/colors.dart';
import 'package:bstable/ui/styles/icons.dart';
import 'package:flutter/material.dart';

class Activity extends StatefulWidget {
  const Activity({super.key});

  @override
  State<Activity> createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          onTap: () {
            print("object");
          },
          leading: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: MyColors.buttonGrey,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Icon(MyIcons.food),
          ),
          title: Text(
            "Food",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: MyColors.iconColor),
          ),
          subtitle: Text(
            "12.01.2020",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: MyColors.lightGrey),
          ),
          trailing: Text(
            "+ \$2.00",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ));
  }
}
