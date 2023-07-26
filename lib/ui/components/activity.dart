// ignore_for_file: prefer_const_constructors

import 'package:bstable/ui/styles/colors.dart';
import 'package:flutter/material.dart';

class Activity extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String date;
  final double amount;
  final String category;
  final String? option;
  const Activity(
      {super.key,
      required this.title,
      required this.icon,
      required this.color,
      required this.date,
      required this.amount,
      required this.category,
      this.option
      });

  @override
  State<Activity> createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          onTap: () {},
          leading: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Icon(
              widget.icon,
              color: widget.color,
            ),
          ),
          title: Text(
            widget.title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.displayMedium!.color),
          ),
          subtitle: Text(
            widget.date,
            style: TextStyle(
                color: MyColors.lightGrey, fontWeight: FontWeight.bold),
          ),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.category == 'income'
                    ? '+\$ ${widget.amount.toString()}'
                    : '-\$ ${widget.amount.toString()}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:
                      widget.category == 'income' ? MyColors.green : MyColors.red,
                ),
              ),
              widget.option!=null? Text(widget.option!,style: TextStyle(
                  fontSize: 12,
                  
                ),):SizedBox()
            ],
          ),
        ));
  }
}
