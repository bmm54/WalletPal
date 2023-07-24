import 'package:bstable/screens/Home/contacts.dart';
import 'package:bstable/services/auth_data.dart';
import 'package:bstable/ui/styles/icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../ui/components/appBar.dart';
import '../../ui/styles/colors.dart';

class ReceiveMoney extends StatefulWidget {
  const ReceiveMoney({super.key});

  @override
  State<ReceiveMoney> createState() => _ReceiveMoneyState();
}

class _ReceiveMoneyState extends State<ReceiveMoney> {
  final userData= AuthData().getUserData;
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: userData==null?Column(
        children: [
          MyAppBar(name: "Receive Money",back:true),
          Expanded(child: Center(child: Text("You need to be logged in for this feature"))),
        ],
      ):Column(
        children: [
          MyAppBar(name: "Receive Money",back:true),
          SizedBox(height: 20,),
          Center(child: Text("Scan QR Code to send the money",style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).textTheme.displayMedium!.color,fontSize: 16),)),
          SizedBox(height: 20,),
          Container(
            height: screenHeight*0.4,
            child: 
              //Center(child: QrImageView(data: userData['id'], size:screenHeight*0.4)),
              Center(child: QrImageView(data: "gp9wUSarXqzxwiepv02f", size:screenHeight*0.4,
              backgroundColor: Colors.white,)),
          ),
          SizedBox(height: 10,),
          Center(child: Text("User id : ${userData['id']}",style: TextStyle(fontWeight: FontWeight.bold,color: MyColors.iconColor,fontSize: 16),)),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ElevatedButton(
                    onPressed: () => {
                      Get.to(()=>ContactsList())
                    },
                    child: Container(
                      height: 50,
                      width: screenWidth*0.8,
                      child: Center(child: Text("Select Contact",style: TextStyle(fontSize: 20),)),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(MyColors.purpule),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      shadowColor:
                          MaterialStateProperty.all(Colors.transparent),
                    ),
                    
                  ),
              ),
              
            ],
          )
        ],
      ),
    );
  }
}
