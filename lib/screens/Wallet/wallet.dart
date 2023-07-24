import 'package:bstable/models/accounts_model.dart';
import 'package:bstable/screens/Home/Home.dart';
import 'package:bstable/ui/components/appBar.dart';
import 'package:bstable/ui/styles/decoration.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../sql/sql_helper.dart';
import '../../ui/styles/colors.dart';
import '../../ui/styles/icons.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Wallet extends StatefulWidget {
  Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  Color _accountColor = MyColors.purpule;
  Color _goalColor = MyColors.lightPurpule;
  List<Map<String, dynamic>> accounts = Accounts.getAccounts;
  List<Map<String, dynamic>> goals = [
            {},
            {
              "title": "laptop",
              "amount": 320000.0,
              "goal": 580000.0,
              "color": "0xFFCCF3FF",
              "icon": Icons.laptop_chromebook
            },
            {
              "title": "phone",
              "amount": 20000,
              "goal": 30000,
              "color": "0xFFDCC7FF",
              "icon": Icons.phone_android
            },
            {
              "title": "car",
              "amount": 3500000,
              "goal": 6000000.0,
              "color": "0xFFFFDBCC",
              "icon": Icons.car_rental_rounded
            },
            {
              "title": "car",
              "amount": 3500000,
              "goal": 6000000.0,
              "color": "0xFFBFDFD1",
              "icon": Icons.car_rental_rounded
            },
          ];
  final _accountName = TextEditingController();
  final _accountBalance = TextEditingController();
  final _goalName = TextEditingController();
  final _goalAmount = TextEditingController();
  final _goalTarget = TextEditingController();
  final _addToGoal = TextEditingController();

  _refrechPage() {
    SQLHelper.getAccounts().then((rows) {
      setState(() {
        accounts = rows;
        goals.clear();
        goals.addAll(
          [
            {},
            {
              "title": "laptop",
              "amount": 320000.0,
              "goal": 580000.0,
              "color": "0xFFCCF3FF",
              "icon": Icons.laptop_chromebook
            },
            {
              "title": "phone",
              "amount": 20000,
              "goal": 30000,
              "color": "0xFFDCC7FF",
              "icon": Icons.phone_android
            },
            {
              "title": "car",
              "amount": 3500000,
              "goal": 6000000.0,
              "color": "0xFFFFDBCC",
              "icon": Icons.car_rental_rounded
            },
            {
              "title": "car",
              "amount": 3500000,
              "goal": 6000000.0,
              "color": "0xFFBFDFD1",
              "icon": Icons.car_rental_rounded
            },
          ],
        );
      });
    });
  }

  @override
  void initState() {
    super.initState();
    //_refrechPage();
  }

  _popUpAccount() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(10.0), // Customize the border radius
          ),
          title: Text(
            'Create Account',
            style: TextStyle(color: MyColors.iconColor,fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(children: [
              SizedBox(height: 10),
             TextField(
                controller: _accountName,
                decoration: CustomDeco.inputDecoration.copyWith(hintText: 'Name',),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _accountBalance,
                keyboardType: TextInputType.number,
                decoration: CustomDeco.inputDecoration.copyWith(hintText: 'Initial balance',),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ColorPicker(
                    pickersEnabled: {
                      ColorPickerType.primary: false,
                      ColorPickerType.custom: true,
                      ColorPickerType.accent: false,
                    },
                    customColorSwatchesAndNames: {
                      ColorTools.createPrimarySwatch(MyColors.purpule):
                          "purple",
                      ColorTools.createPrimarySwatch(MyColors.lightBlue):
                          "blue",
                      ColorTools.createPrimarySwatch(MyColors.orange): "orange",
                      ColorTools.createPrimarySwatch(MyColors.green): "green",
                    },
                    enableOpacity: false,
                    color: _accountColor,
                    onColorChanged: (Color color) {
                      setState(() {
                        _accountColor = color;
                      });
                      print(_accountColor);
                    },
                    enableShadesSelection: false,
                  ),
                ],
              ),
            ]),
          ),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                elevation: MaterialStateProperty.all(0.0),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: MyColors.purpule),
              ),
            ),
            Container(
              width: 120,
              height: 40,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(MyColors.purpule),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                onPressed: () async {
                  await SQLHelper.insertAccount(
                      _accountName.text,
                      double.parse(_accountBalance.text),
                      _accountColor.value.toString());
                  _refrechPage();
                  Navigator.pop(context);
                },
                child: Text('Save'),
              ),
            ),
          ],
        );
      },
    ).then((color) {
      if (color != null) {
        // Handle the selected color
        print('Selected Color: $color');
      }
    });
  }

  _addToGoalPopUp() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(10.0), // Customize the border radius
            ),
            title: Text(
              'Add to Goal',
              style: TextStyle(color: MyColors.iconColor),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: _addToGoal,
                    decoration: CustomDeco.inputDecoration.copyWith(hintText: 'Amount',)
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent),
                  elevation: MaterialStateProperty.all(0.0),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(color: MyColors.purpule),
                ),
              ),
              Container(
                width: 120,
                height: 40,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(MyColors.purpule),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  onPressed: () async {},
                  child: Text('Save'),
                ),
              ),
            ],
          );
        });
  }

  _popUpGoals() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(10.0), // Customize the border radius
          ),
          title: Text(
            'Create Goal',
            style: TextStyle(color: MyColors.iconColor),
          ),
          content: SingleChildScrollView(
            child: Column(children: [
              SizedBox(height: 10),
              TextField(
                controller: _goalName,
                decoration:CustomDeco.inputDecoration.copyWith(hintText: 'Name',)
              ),
              SizedBox(
                height: 10,
              ),
              
              TextField(
                keyboardType: TextInputType.number,
                controller: _goalAmount,
                decoration: CustomDeco.inputDecoration.copyWith(hintText: 'Initial amount',)
              ),
              SizedBox(height: 10),
              TextField(
                keyboardType: TextInputType.number,
                controller: _goalTarget,
                decoration: CustomDeco.inputDecoration.copyWith(hintText: 'Goal amount',)
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Color :",
                  style: TextStyle(color: MyColors.iconColor),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ColorPicker(
                    pickersEnabled: {
                      ColorPickerType.primary: false,
                      ColorPickerType.custom: true,
                      ColorPickerType.accent: false,
                    },
                    customColorSwatchesAndNames: {
                      ColorTools.createPrimarySwatch(MyColors.lightPurpule):
                          "purple",
                      ColorTools.createPrimarySwatch(MyColors.lightestBlue):
                          "blue",
                      ColorTools.createPrimarySwatch(MyColors.lightOrange):
                          "orange",
                    },
                    enableOpacity: false,
                    color: _goalColor,
                    onColorChanged: (Color color) {
                      setState(() {
                        _goalColor = color;
                      });
                    },
                    enableShadesSelection: false,
                  ),
                ],
              ),
            ]),
          ),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                elevation: MaterialStateProperty.all(0.0),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: MyColors.purpule),
              ),
            ),
            Container(
              width: 120,
              height: 40,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(MyColors.purpule),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(_goalColor);
                },
                child: Text('Save'),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          MyAppBar(name: "Wallet", back: false),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Text(
              "Accounts",
              style: TextStyle(
                color: Theme.of(context).textTheme.displayMedium!.color,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 20, bottom: 10),
            child: InkWell(
              onTap: () {
                _popUpAccount();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(color: MyColors.iconColor, width: 3.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_rounded,
                      size: 40,
                      color: MyColors.iconColor,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Create New Account",
                      style: TextStyle(
                        fontSize: 20,
                        color: MyColors.iconColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ListView.builder(
              shrinkWrap: true,
              primary: false,
              scrollDirection: Axis.vertical,
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: Container(
                    height: 80,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Color(int.parse(accounts[index]['color'])),
                      borderRadius: BorderRadius.circular(
                          15.0), // Specify the border radius
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          accounts[index]['name'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.grey[300]),
                        ),
                        Text('\$ ' + accounts[index]['balance'].toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.grey[300])),
                      ],
                    ),
                  ),
                );
              }),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Text(
              "Goals",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.displayMedium!.color,
                  fontSize: 25),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.builder(
              primary: false,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 5 / 6,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
              shrinkWrap: true,
              itemCount: goals.length,
              itemBuilder: (context, index) {
                double pourcentage = index != 0
                    ? ((goals[index]['amount'] * 100) / goals[index]['goal'])
                    : 0.0;
                print(pourcentage);
                return index == 0
                    ? InkWell(
                        onTap: () {
                          _popUpGoals();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border.all(
                                color: MyColors.iconColor, width: 3.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_rounded,
                                size: 50,
                                color: MyColors.iconColor,
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Create Goal",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: MyColors.iconColor),
                              )
                            ],
                          ),
                        ),
                      )
                    : InkWell(
                        radius: 15,
                        onTap: () {},
                        onLongPress: () {},
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                            color: Color(int.parse(goals[index]['color'])),
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border.all(
                                color: MyColors.borderColor, width: 0.0),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CircularPercentIndicator(
                                        radius: 35,
                                        lineWidth: 8,
                                        percent: pourcentage / 100,
                                        center: Icon(
                                          goals[index]['icon'],
                                          size: 30,
                                          color: Colors.green,
                                        ),
                                        circularStrokeCap:
                                            CircularStrokeCap.round,
                                        progressColor: Colors.green,
                                        backgroundColor: MyColors.lightGrey,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "${goals[index]['title']}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: MyColors.iconColor),
                                      ),
                                    ]),
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "\$ ${goals[index]['amount']}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: MyColors.iconColor,
                                        fontSize: 20),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      _addToGoalPopUp();
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: MyColors.lightGrey,
                                      foregroundColor: Colors.white,
                                      radius: 30,
                                      child: Icon(Icons.add),
                                    ),
                                  ),
                                  Text(
                                    "${pourcentage.round()} %",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: MyColors.iconColor,
                                        fontSize: 30),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}
