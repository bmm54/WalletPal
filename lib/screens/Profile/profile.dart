import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Column(
            children: [
              CircleAvatar(
                radius: Get.width*0.2,
              ),
              Text("name"),
              Text("id"),
              
            ],
          )
        ],
      ),
    );
  }
}