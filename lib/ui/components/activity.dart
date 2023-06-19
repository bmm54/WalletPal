// ignore_for_file: prefer_const_constructors

import 'package:bstable/ui/styles/colors.dart';
import 'package:bstable/ui/styles/icons.dart';
import 'package:flutter/material.dart';

class Activity extends StatefulWidget {
  String title;
  IconData icon;
  Color color;
  String date;
  double amount;
  String category;
  Activity(
      {super.key,
      required this.title,
      required this.icon,
      required this.color,
      required this.date,
      required this.amount,
      required this.category});

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
            print(widget.title + widget.date);
          },
          leading: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: MyColors.buttonGrey,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Icon(
              widget.icon,
              color: widget.color,),
          ),
          title: Text(
            widget.title,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: MyColors.iconColor),
          ),
          subtitle: Text(
            widget.date,
            style: TextStyle( color: MyColors.lightGrey),
          ),
          trailing: Text(
            widget.category == 'income'
                ? '+\$ ${widget.amount.toString()}'
                : '-\$ ${widget.amount.toString()}',
            style: TextStyle(fontWeight: FontWeight.bold,color: 
            widget.category == 'income'
                ?Colors.green 
                : Colors.red,
            ),
          ),
        ));
  }
}
