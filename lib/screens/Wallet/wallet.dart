import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../sql/sql_helper.dart';
import '../../ui/styles/colors.dart';
import '../../ui/styles/icons.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

class Wallet extends StatefulWidget {
  Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  Color _selectedColor = Colors.red;
  List<Map<String, dynamic>> accounts = [];
  List<Map<String, dynamic>> goals = [];
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  _refrechPage() {
    SQLHelper.getAccounts().then((rows) {
      setState(() {
        accounts = rows;
        goals = [
          {},
          {"title": "phone", "amount": 20000, "color": "0xFFCCF3FF"},
          {"title": "phone", "amount": 20000, "color": "0xFFDCC7FF"},
          {"title": "phone", "amount": 20000, "color": "0xFFFFDBCC"},
        ];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _refrechPage();
  }

  _popUpAccount() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(10.0), // Customize the border radius
          ),
          title: Text(
            'Create Account',
            style: TextStyle(color: MyColors.iconColor),
          ),
          content: SingleChildScrollView(
            child: Column(children: [
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Account Name :",
                  style: TextStyle(color: MyColors.iconColor),
                ),
              ),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  //hintText: "Account name",
                  focusColor: MyColors.purpule,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Initial balance :",
                  style: TextStyle(color: MyColors.iconColor),
                ),
              ),
              TextField(
                controller: _balanceController,
                decoration: InputDecoration(
                  //hintText: "Initial balance",
                  focusColor: MyColors.purpule,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
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
                      ColorTools.createPrimarySwatch(MyColors.purpule):
                          "purple",
                      ColorTools.createPrimarySwatch(MyColors.lightBlue):
                          "blue",
                      ColorTools.createPrimarySwatch(MyColors.orange): "orange",
                      ColorTools.createPrimarySwatch(MyColors.green): "green",
                    },
                    enableOpacity: false,
                    color: _selectedColor,
                    onColorChanged: (Color color) {
                      setState(() {
                        _selectedColor = color;
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
                  Navigator.of(context).pop(_selectedColor);
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

  _popUpGoals() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
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
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Goal Name :",
                  style: TextStyle(color: MyColors.iconColor),
                ),
              ),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  //hintText: "Account name",
                  focusColor: MyColors.purpule,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Initial amount :",
                  style: TextStyle(color: MyColors.iconColor),
                ),
              ),
              TextField(
                controller: _balanceController,
                decoration: InputDecoration(
                  //hintText: "Initial balance",
                  focusColor: MyColors.purpule,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
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
                    color: _selectedColor,
                    onColorChanged: (Color color) {
                      setState(() {
                        _selectedColor = color;
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
                  Navigator.of(context).pop(_selectedColor);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Stack(
              alignment: AlignmentDirectional.centerStart,
              children: [
                const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Wallet",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: MyColors.iconColor,
                          fontSize: 16),
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Text(
              "Accounts",
              style: TextStyle(color: MyColors.iconColor, fontSize: 25),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 20, bottom: 10),
            child: InkWell(
              onTap: () {
                _popUpGoals();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: MyColors.iconGrey,
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
                      style: TextStyle(fontSize: 20, color: MyColors.iconColor),
                    )
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
                          style:
                              TextStyle(fontSize: 20, color: Colors.grey[300]),
                        ),
                        Text('\$ ' + accounts[index]['balance'].toString(),
                            style: TextStyle(
                                fontSize: 20, color: Colors.grey[300])),
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
              style: TextStyle(color: MyColors.iconColor, fontSize: 25),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.builder(
              primary: false,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
              shrinkWrap: true,
              itemCount:goals.length,
              itemBuilder: (context, index) {
                return index == 0
                    ? InkWell(
                        onTap: () {
                          _popUpGoals();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                            color: MyColors.iconGrey,
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
                                    fontSize: 20, color: MyColors.iconColor),
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
                              Row(children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Icon(
                                      Icons.phone_android_rounded,
                                      size: 30,
                                    ),
                                    Icon(
                                      Icons.circle_outlined,
                                      size: 70,
                                    ),
                                  ],
                                ),
                                Text(
                                  "Phone",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: MyColors.iconColor),
                                ),
                              ]),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "\$ 200000",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: MyColors.iconColor,
                                        fontSize: 20),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "59 %",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: MyColors.iconColor,
                                        fontSize: 25),
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
