import 'package:bstable/screens/Home/calculator.dart';
import 'package:bstable/ui/styles/icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../ui/styles/colors.dart';

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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
                      border:
                          Border.all(color: MyColors.borderColor, width: 3.0),
                    ),
                    child: const Icon(MyIcons.back),
                  ),
                ),
                const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Add",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: MyColors.iconColor,
                          fontSize: 16),
                    )),
              ],
            ),
          ),
          const SizedBox(
            height: 0,
          ),
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                  15), //adjust the border radius as per your requirement
              border: Border.all(color: MyColors.iconGrey, width: 1),
              color: Colors.white, //set your desired color
            ),
            width: screenWidth*0.9,
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
                tabs: const [
                  Tab(child: Text("Expense")),
                  Tab(child: Text("Income")),
                ]),
          ),
          Expanded(
            child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _controller,
                children: [
                  CalculatorScreen(type:"expense"),
                  CalculatorScreen(type:"income"),
                ]),
          ),
        ],
      ),
    );
  }
}
