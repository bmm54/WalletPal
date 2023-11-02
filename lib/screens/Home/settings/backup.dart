import 'package:bstable/ui/components/appBar.dart';
import 'package:bstable/ui/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//this page is included in the next update

class BackupPage extends StatefulWidget {
  const BackupPage({super.key});

  @override
  State<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends State<BackupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          MyAppBar(name: "Backup", back: true),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                ListTile(
                    title: Text("Backup".tr,
                        style: TextStyle(color: MyColors.iconColor,
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    trailing: Icon(Icons.arrow_forward_ios_rounded,
                        color: MyColors.iconColor)),
                ListTile(
                    title: Text("Restore".tr,
                        style: TextStyle(color: MyColors.iconColor,
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    trailing: Icon(Icons.arrow_forward_ios_rounded,
                        color: MyColors.iconColor)),
              ],
            ),
          )
        ],
      ),
    );
  }
}