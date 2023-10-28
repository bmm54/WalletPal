import 'dart:math';

import 'package:bstable/screens/Home/home.dart';
import 'package:bstable/screens/Home/settings/notifications.dart';
import 'package:bstable/services/auth.dart';
import 'package:bstable/services/currency.dart';
import 'package:bstable/services/hot_restart.dart';
import 'package:bstable/services/language_service.dart';
import 'package:bstable/ui/components/setting_tile.dart';
import 'package:bstable/ui/styles/icons.dart';
import 'package:bstable/ui/themes/dark.dart';
import 'package:bstable/ui/themes/light.dart';
import 'package:bstable/services/theme_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../sql/sql_helper.dart';
import '../../../ui/components/appBar.dart';
import '../../../ui/components/card.dart';
import '../../../ui/styles/colors.dart';

class Settings extends StatefulWidget {
  Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final CurrencyController currencyController = Get.find();

  void changeCurrency(String newCurrency) {
    currencyController.changeCurrency(newCurrency);
  }

  var selectedCurrency = '\$';
  var selectedLanguage = LanguageService().getLanguage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Column(
            children: [
              MyAppBar(name: "Settings".tr, back: true),
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
                      child: Text("General Settings".tr,
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
                      ontap: () {
                        Get.to(() => Language());
                      },
                    ),
                    TileButton(
                      name: "Theme",
                      icon: Icons.color_lens,
                      option: InkWell(
                        onTap: () {
                          ThemeService().changeThemeMode();
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              border: Border.all(
                                  width: 3,
                                  color:
                                      Theme.of(context).secondaryHeaderColor),
                              borderRadius: BorderRadius.circular(15)),
                          child: Icon(
                            Get.isDarkMode
                                ? Icons.wb_sunny
                                : Icons.brightness_2_rounded,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ),
                      ),
                    ),
                    TileButton(
                      name: "Notifications",
                      icon: Icons.notifications,
                      ontap: () {
                        Get.to(() => NotificationsSettings());
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text("Account & Informations".tr,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .color,
                              fontSize: 16)),
                    ),
                    TileButton(
                      name: "BackUp & Restore",
                      icon: Icons.backup,
                      ontap: () {},
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text("About".tr,
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
                      ontap: () async {
                        //final prefs = await SharedPreferences.getInstance();
                        //prefs.setBool('showHome', false);
                        Get.to(() => About());
                      },
                    ),
                    TileButton(
                      name: "Rate us",
                      icon: Icons.star,
                      ontap: () {},
                    ),
                    TileButton(
                      name: "Bug report",
                      icon: Icons.bug_report,
                      ontap: () {
                        Get.to(() => ReportBug());
                      
                      },
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
          ),
        ],
      ),
    );
  }
}

class Language extends StatefulWidget {
  const Language({super.key});

  @override
  State<Language> createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  @override
  Widget build(BuildContext context) {
    String _selectedLanguage = LanguageService().getLanguage();
    Map<String, String> languages = {
      "English": "en",
      "العربية": "ar",
      "语言": "zh"
    };
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          MyAppBar(name: "Language", back: true),
          SizedBox(
            height: 40,
          ),
          Container(
            padding: EdgeInsets.all(10),
            width: Get.width * 0.9,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).primaryColor),
            child: ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: languages.length,
              itemBuilder: (context, index) {
                var values = languages.values.toList();
                var names = languages.keys.toList();
                return RadioListTile(
                  activeColor: MyColors.blue,
                  selected: _selectedLanguage == values[index],
                  value: values[index],
                  groupValue: _selectedLanguage,
                  onChanged: (value) {
                    var locale = Locale(value!);
                    Get.updateLocale(locale);
                    LanguageService().saveLanguage(value);
                    print(value);
                    setState(() {
                      _selectedLanguage = value;
                    });
                  },
                  title: Text(names[index]),
                );
              },
            ),
          ),
        ],
      ),
    ));
  }
}

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        MyAppBar(name: "About", back: true),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40,
              ),
              Text("WalletPall",
                  style: TextStyle(
                      fontSize: 30,
                      color: Theme.of(context).textTheme.displayMedium!.color,
                      fontWeight: FontWeight.bold)),
              SizedBox(
                height: 20,
              ),
              Text("Version 1.0.0", style: TextStyle(fontSize: 16)),
              SizedBox(
                height: 20,
              ),
              Text(
                  "WalletPall is a simple and easy to use app that helps you manage your money and track your expenses.\n\nFor more info visit :",
                  style: TextStyle(fontSize: 20)),
              SizedBox(
                height: 20,
              ),
              InkWell(
                  onTap: () async {
                    //open browser for the link
                    final Uri url = Uri.parse('https://dev.bembamahmouden.com');
                    if (!await launchUrl(url)) {
                      throw Exception('Could not launch $url');
                    }
                  },
                  child: Text(
                    "dev.bembamahmouden.com",
                    style: TextStyle(
                        color: MyColors.blue,
                        fontSize: 20,
                        decoration: TextDecoration.underline),
                  )),
            ],
          ),
        ),
      ]),
    );
  }
}

class ReportBug extends StatelessWidget {
  const ReportBug({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          MyAppBar(name: "Bug report", back: true),
              //align this text to center of the column
              SizedBox(height: 100,),
              Text("Just imagine it's a feature\n\nbe positive :) 🧡",textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).textTheme.displayMedium!.color,
                      fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
