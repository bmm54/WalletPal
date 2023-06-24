import 'package:bstable/screens/Home/contacts.dart';
import 'package:bstable/ui/styles/icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../ui/styles/colors.dart';

class ReceiveMoney extends StatefulWidget {
  const ReceiveMoney({super.key});

  @override
  State<ReceiveMoney> createState() => _ReceiveMoneyState();
}

class _ReceiveMoneyState extends State<ReceiveMoney> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ListView(
        children: [
          Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Stack(
                  alignment: AlignmentDirectional.centerStart,
                  children:[ InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      child: Icon(MyIcons.back),
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(
                            color: MyColors.borderColor, width: 3.0),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text("Receive Money",style: TextStyle(fontWeight: FontWeight.bold,color: MyColors.iconColor,fontSize: 16),)),
                          ],),
              ),
              Container(
                color: Colors.red,
                height: screenHeight*0.4,
                child: Row(
                 
                )
              ),
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
              ),
              ElevatedButton(
                        onPressed: () => {
                          print(ContactsList.contactInfo)
                        },
                        child:Text("click"),
                        ),
            ],
          )
        ],
      ),
    );
  }
}
