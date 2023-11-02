import 'package:bstable/ui/styles/colors.dart';
import 'package:bstable/ui/styles/iconlist.dart';
import 'package:bstable/ui/styles/icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../ui/components/appBar.dart';

class ExpenseCategory extends StatefulWidget {
  ExpenseCategory({super.key});

  @override
  State<ExpenseCategory> createState() => _ExpenseCategoryState();
}

class _ExpenseCategoryState extends State<ExpenseCategory> {
  List<String> titles = [
    "Food",
    "Restaurent",
    "Cafe",
    "Transport",
    "Grocery",
    "Housing",
    "Shopping",
    "Internet",
    "Loan",
    "Entertainment",
    "Expense",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Column(
            children: [
              MyAppBar(name: "Category", back: true),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: titles.length,
                  itemBuilder: (context, index) {
                    //List data = [
                    //  titles[index], //title
                    //  get(titles[index]), //icon
                    //  get_color(color[index])
                    //];
                    List data = [
                      titles[index], //title
                      IconsList.get_icon(titles[index]), //icon
                      IconsList.get_color(titles[index])
                    ];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        onTap: () {
                          final result = data[0].toString();
                          Navigator.pop(context, result);
                        },
                        title: Text(
                          titles[index]=="Expense"?"Other":titles[index].tr,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        leading: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Icon(data[1], color:titles[index]=="Expense"?MyColors.iconColor:data[2]),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
