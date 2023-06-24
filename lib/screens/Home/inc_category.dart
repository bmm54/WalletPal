import 'package:bstable/ui/styles/colors.dart';
import 'package:bstable/ui/styles/iconlist.dart';
import 'package:bstable/ui/styles/icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IncomeCategory extends StatefulWidget {
  const IncomeCategory({super.key});

  @override
  State<IncomeCategory> createState() => _IncomeCategoryState();
}

class _IncomeCategoryState extends State<IncomeCategory> {
  List titles = [
    "Loan",
    "Salary"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Stack(
                  alignment: AlignmentDirectional.centerStart,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(
                              color: MyColors.borderColor, width: 3.0),
                        ),
                        child: const Icon(MyIcons.back),
                      ),
                    ),
                    const Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Income Category",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: MyColors.iconColor,
                              fontSize: 16),
                        )),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: titles.length,
                  itemBuilder: (context, index) {
                    List data = [
                      titles[index], //title
                      IconsList.get_icon(titles[index]), //icon
                      IconsList.get_color(titles[index])
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
