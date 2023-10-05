// ignore_for_file: prefer_const_constructors

import 'package:bstable/services/currency.dart';
import 'package:bstable/ui/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Activity extends StatefulWidget {
  final String title;
  final IconData? icon;
  final Image? image;
  final Color? color;
  final String date;
  final double amount;
  final String category;
  final String? option;
  const Activity(
      {super.key,
      required this.title,
      this.icon,
      this.image,
      this.color,
      required this.date,
      required this.amount,
      required this.category,
      this.option});

  @override
  State<Activity> createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  @override
  Widget build(BuildContext context) {
    CurrencyController currencyController = Get.find();
    final currency = currencyController.getSelectedCurrency();
    return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          onLongPress: () {
            showModalBottomSheet(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      20.0), // Customize the border radius
                ),
                isScrollControlled: true,
                context: context,
                builder: (_) => Container(
                    padding: EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: 10,
                      bottom: 20,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 10,
                          width: 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.grey),
                        ),
                        Container(
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
                        Text(
                          widget.title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .color),
                        ),
                      ],
                    )));
          },
          leading: widget.option != null
              ? Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: widget.image!.image),
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(100),
                  ),
                )
              : Container(
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
            widget.title.tr,
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
                (widget.category == 'income'|| widget.category == 'Received')
                    ? '+ ${'$currency ${widget.amount}'}'
                    : '- ${'$currency ${widget.amount}'}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: (widget.category == 'income'|| widget.category == 'Received')
                      ? MyColors.green
                      : MyColors.red,
                ),
              ),
              widget.option != null
                  ? Text(
                      widget.option!,
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    )
                  : SizedBox()
            ],
          ),
        ));
  }
}
