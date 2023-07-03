import 'package:bstable/screens/Home/contacts.dart';
import 'package:bstable/ui/styles/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';

import '../../ui/styles/colors.dart';

class SendMoney extends StatefulWidget {
  const SendMoney({super.key});

  @override
  State<SendMoney> createState() => _SendMoneyState();
}

class _SendMoneyState extends State<SendMoney> {
  @override
  Widget build(BuildContext context) {
      String _qrInfo = 'Unknown';
  Future<void> _scanQR() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );
      if (!mounted) return;

      setState(() {
        _qrInfo = qrCode;
      });
    } on PlatformException {
      _qrInfo = 'Failed to get platform version.';
    }
  }
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
                    child: Text("Send Money",style: TextStyle(fontWeight: FontWeight.bold,color: MyColors.iconColor,fontSize: 16),)),
                          ],),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: ElevatedButton(
                        onPressed: () => {
                          _scanQR()
                        },
                        child: Container(
                          height: 50,
                          width: Get.width*0.8,
                          child: Center(child: Text("Scan QR code",style: TextStyle(fontSize: 20),)),
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
                          width: Get.width*0.8,
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
            ],
          )
        ],
      ),
    );
  }
}
