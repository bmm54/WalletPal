import 'package:bstable/ui/styles/colors.dart';
import 'package:bstable/ui/styles/icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpenseCategory extends StatefulWidget {
  ExpenseCategory({super.key});

  @override
  State<ExpenseCategory> createState() => _ExpenseCategoryState();
}

class _ExpenseCategoryState extends State<ExpenseCategory> {
  Map<String, IconData> categories = {
    "Food": MyIcons.food,
    "Restaurent": MyIcons.restaurent,
    "Cafe": MyIcons.cafe,
    "Transport": MyIcons.transport,
    "Grocery": MyIcons.grocery,
    "Housing": MyIcons.house,
    "Shopping": MyIcons.shopping,
    "Internet": MyIcons.internet,
    "Loan": MyIcons.loan,
  };
  Map<String, Color> colors = {
    "Food": MyColors.orange,
    "Restaurent": MyColors.lightBlue,
    "Cafe": MyColors.red,
    "Transport": MyColors.blue,
    "Grocery": MyColors.orange,
    "Housing": MyColors.purpule,
    "Shopping": MyColors.blue,
    "Internet": MyColors.darkBorder,
    "Loan": MyColors.green,
  };
  get(String name) {
    return categories[name];
  }

  get_color(String name) {
    return colors[name];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Column(
            children: [Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Stack(
              alignment: AlignmentDirectional.centerStart,
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    child: Icon(MyIcons.back),
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                      border:
                          Border.all(color: MyColors.borderColor, width: 3.0),
                    ),
                  ),
                ),
                Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Expense Category",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: MyColors.iconColor,
                          fontSize: 16),
                    )),
              ],
            ),
          ),
          SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    dynamic titles = categories.keys.toList(); //list of strings
                    dynamic color = colors.keys.toList();
                    List data = [
                      titles[index], //title
                      get(titles[index]), //icon
                      get_color(color[index])
                    ];
                    return ListTile(
                      onTap: () {
                        final result = data[0];
                        Navigator.pop(context, result);
                      },
                      title: Text(data[0]),
                      leading: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: MyColors.buttonGrey,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Icon(data[1], color: data[2]),
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
