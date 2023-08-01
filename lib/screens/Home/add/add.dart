import 'package:bstable/screens/Home/add/calculator.dart';
import 'package:bstable/ui/styles/icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../ui/components/appBar.dart';
import '../../../ui/styles/colors.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({super.key});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final _controller = TabController(vsync: this, length: 2);
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          MyAppBar(name: "Add", back: true),
          const SizedBox(
            height: 0,
          ),
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                  15), //adjust the border radius as per your requirement
              border: Border.all(color: MyColors.lightPurpule, width: 1),
              //set your desired color
            ),
            width: screenWidth * 0.9,
            height: 50,
            child: TabBar(
                indicator: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: MyColors.purpule,
                ),
                labelColor: Colors.white,
                unselectedLabelColor: MyColors.iconColor,
                labelStyle:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                controller: _controller,
                tabs:  [
                  Tab(child: Text("Expense".tr)),
                  Tab(child: Text("Income".tr)),
                ]),
          ),
          Expanded(
            child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _controller,
                children: [
                  CalculatorScreen(type: "expense"),
                  CalculatorScreen(type: "income"),
                ]),
          ),
        ],
      ),
    );
  }
}
