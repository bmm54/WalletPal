import 'package:bstable/services/auth_data.dart';
import 'package:bstable/ui/components/image.dart';
import 'package:bstable/ui/styles/colors.dart';
import 'package:bstable/ui/styles/icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../ui/components/appBar.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final userData = AuthData().getUserData;
    return Scaffold(
      body: ListView(
        children: [
          Column(
            children: [
              MyAppBar(name: "Profile",back:true),
              CustomCachedImage(imageUrl: userData['image'],size: 100,),
              SizedBox(
                height: 20.0,
              ),
              Text(
                userData['name'] ?? "",
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: MyColors.iconColor),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                userData['email'] ?? "",
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: MyColors.iconColor),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                userData['id'] ?? "",
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    );
  }
}
