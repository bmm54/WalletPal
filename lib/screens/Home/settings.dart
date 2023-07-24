import 'dart:math';

import 'package:bstable/services/auth.dart';
import 'package:bstable/ui/components/setting_tile.dart';
import 'package:bstable/ui/styles/icons.dart';
import 'package:bstable/ui/themes/dark.dart';
import 'package:bstable/ui/themes/light.dart';
import 'package:bstable/ui/themes/notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../sql/sql_helper.dart';
import '../../ui/components/appBar.dart';
import '../../ui/components/card.dart';
import '../../ui/styles/colors.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  var selectedCurrency = '\$';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Column(
            children: [
              MyAppBar(name: "Settings", back: true),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: ListView(
                  primary: false,
                  shrinkWrap: true,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text("General Settings",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .color,
                              fontSize: 16)),
                    ),
                    TileButton(
                      name: "Language",
                      icon: Icons.language,
                      ontap: () {},
                    ),
                    TileButton(
                      name: "Currency",
                      icon: Icons.attach_money,
                      ontap: () {},
                      option: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            border: Border.all(
                                width: 3,
                                color: Theme.of(context).secondaryHeaderColor),
                            borderRadius: BorderRadius.circular(15)),
                        child: DropdownButton<String>(
                          dropdownColor: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10),
                          underline: Container(
                            height: 0,
                          ),
                          value: selectedCurrency,
                          style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .color,
                              fontWeight: FontWeight.bold),
                          alignment: Alignment.center,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedCurrency = newValue!;
                            });
                          },
                          items:
                              <String>['\$', 'MRO', 'TND'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    TileButton(
                      name: "Theme",
                      icon: Icons.color_lens,
                      ontap: () {},
                      option: InkWell(
                        onTap: () {
                          Get.changeThemeMode(Get.isDarkMode
                              ? ThemeMode.light
                              : ThemeMode.dark);
                        },
                        child: Container(
                          height: 50,
                          width:50,
                          padding: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            border: Border.all(
                                width: 3,
                                color: Theme.of(context).secondaryHeaderColor),
                            borderRadius: BorderRadius.circular(15)),
                          child: Icon(Get.isDarkMode
                              ? Icons.wb_sunny
                              : Icons.brightness_3,color:Theme.of(context).iconTheme.color),
                        ),
                      ),
                    ),
                    TileButton(
                      name: "Notification",
                      icon: Icons.notifications,
                      ontap: () {},
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text("Account & Informations",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .color,
                              fontSize: 16)),
                    ),
                    TileButton(
                      name: "Profile",
                      icon: MyIcons.profile,
                      ontap: () {},
                    ),
                    TileButton(
                      name: "Accounts",
                      icon: MyIcons.wallet,
                      ontap: () {
                        Get.to(() => ManageAccounts());
                      },
                    ),
                    TileButton(
                      name: "Backup & Restore",
                      icon: Icons.backup,
                      ontap: () {},
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text("About",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .color,
                              fontSize: 16)),
                    ),
                    TileButton(
                      name: "About",
                      icon: Icons.info,
                      ontap: () {},
                    ),
                    TileButton(
                      name: "Rate us",
                      icon: Icons.star,
                      ontap: () {},
                    ),
                    TileButton(
                      name: "Bug report",
                      icon: Icons.bug_report,
                      ontap: () {},
                    ),
                    TileButton(
                      name: "Contact us",
                      icon: Icons.contact_mail,
                      ontap: () {},
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TileButton(
                      name: "Logout",
                      icon: Icons.logout,
                      color: Color.fromARGB(255, 188, 66, 57),
                      ontap: () {
                        AuthService().signOut();
                        Get.back();
                      },
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ManageAccounts extends StatefulWidget {
  ManageAccounts({super.key});

  @override
  State<ManageAccounts> createState() => _ManageAccountsState();
}

int color = 0xFF8438FF;
final _avColors = [
  0xFF8438FF,
  0xFFFF7438,
  0xFF38CFFF,
];

class _ManageAccountsState extends State<ManageAccounts> {
  List<Map<String, dynamic>> accounts = [];
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  _refrechPage() {
    SQLHelper.getAccounts().then((rows) {
      setState(() {
        accounts = rows;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _refrechPage();
  }

  _buildColors(int Mycolor) {
    return Container(
      child: Stack(children: [
        Icon(
          Icons.check,
          size: 20,
          color: color == Mycolor ? Color(Mycolor) : Colors.transparent,
        ),
        IconButton(
          icon: Icon(
            Icons.circle,
            size: 30,
            color: Color(Mycolor),
          ),
          onPressed: () {
            setState(() {
              color = Mycolor;
              print("here");
            });
          },
        )
      ]),
    );
  }

  Widget _colorPicker() {
    return Row(children: [
      for (var i = 0; i < 3; i++) _buildColors(_avColors[i]),
    ]);
  }

  _showSheet() {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) => Container(
        padding: EdgeInsets.only(
            left: 10,
            right: 10,
            top: 30,
            bottom: MediaQuery.of(context).viewInsets.bottom + 100),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: "Account name",
                focusColor: MyColors.purpule,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: _balanceController,
              decoration: InputDecoration(
                hintText: "Initial balance",
                focusColor: MyColors.purpule,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(child: _colorPicker()),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  await SQLHelper.insertAccount(_nameController.text,
                      double.parse(_balanceController.text), color.toString());
                  _refrechPage();
                  _nameController.clear();
                  _balanceController.clear();
                  Navigator.of(context).pop();
                },
                child: Text("Create"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(MyColors.purpule),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  shadowColor: MaterialStateProperty.all(Colors.transparent),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
                      "Accounts",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: MyColors.iconColor,
                          fontSize: 16),
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: 100,
              child: ElevatedButton(
                onPressed: () {
                  _showSheet();
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_rounded,
                      size: 40,
                    ),
                    Text(
                      "Add New Account",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(MyColors.lightGrey),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  shadowColor: MaterialStateProperty.all(Colors.transparent),
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
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
        ],
      ),
    );
  }
}
