import 'package:bstable/screens/Home/contacts.dart';
import 'package:bstable/ui/styles/colors.dart';
import 'package:bstable/ui/styles/icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class SendMoney extends StatefulWidget {
  @override
  _SendMoneyState createState() => _SendMoneyState();
}

class _SendMoneyState extends State<SendMoney> {
  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    final PermissionStatus status = await Permission.camera.request();
    if (status != PermissionStatus.granted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Camera Permission'),
            content: Text('Camera permission is required to scan QR codes.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  if (status.isPermanentlyDenied) {
                    openAppSettings();
                  }
                },
              ),
            ],
          );
        },
      );
    }
  }

  _popUp(data) {
    return AlertDialog(
      title: Text('data'),
      content: Text(data.toString()),
      actions: [
        TextButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isScanCompleted = false;
    void _closeScanner() {
      isScanCompleted = false;
    }

    return Scaffold(
      body: Column(
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
                    child: Icon(MyIcons.back),
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                      border:
                          Border.all(color: MyColors.borderColor, width: 3.0),
                    ),
                  ),
                ),
                Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Send Money",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: MyColors.iconColor,
                          fontSize: 16),
                    )),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Scan the QR code to get the other person infos",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15),
          ),
          Expanded(
            child: Stack(
              children: [
                MobileScanner(
                  onDetect: (qrcode) {
                    if (!isScanCompleted) {
                      String code = qrcode.raw ?? '---';
                      isScanCompleted = true;
                      Get.to(() => QrPage(), arguments: code);
                    }
                  },
                ),
                Positioned.fill(
                  child: Container(
                    decoration: ShapeDecoration(
                      shape: QrScannerOverlayShape(
                        overlayColor: Colors.white,
                        borderColor: MyColors.purpule,
                        borderRadius: 20,
                        borderLength: 30,
                        borderWidth: 10,
                        cutOutSize: Get.width * 0.7,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
              onPressed: () {
                Get.to(() => QrPage(),arguments: "bamba");
                print("hello");
              },
              child: Text("click")),
          Container(
              padding: EdgeInsets.all(8),
              child: Text(
                "if you're offline or the other person doesn't have the app you can use his contact",
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ElevatedButton(
                  onPressed: () => {Get.to(() => ContactsList())},
                  child: Container(
                    height: 50,
                    width: Get.width * 0.8,
                    child: Center(
                        child: Text(
                      "Select Contact",
                      style: TextStyle(fontSize: 20),
                    )),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(MyColors.purpule),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    shadowColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class QrPage extends StatefulWidget {
  const QrPage({super.key});

  @override
  State<QrPage> createState() => _QrPageState();
}

class _QrPageState extends State<QrPage> {
  @override
  Widget build(BuildContext context) {
    String code = Get.arguments.toString();
    return Scaffold(
      body: Center(
        child: Text(code),
      ),
    );
  }
}
