import 'package:bstable/screens/Home/contacts.dart';
import 'package:bstable/services/transaction.dart';
import 'package:bstable/ui/styles/colors.dart';
import 'package:bstable/ui/styles/icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../ui/components/appBar.dart';

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

  getUserData(String userId) async {
    String userName = '';
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get()
              .then((value) {
        return value;
      });

      if (snapshot.exists) {
        return snapshot.data()!;
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                actions: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent),
                      elevation: MaterialStateProperty.all(0.0),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Ok',
                      style: TextStyle(color: MyColors.purpule),
                    ),
                  ),
                ],
                content: Text("Use doesnt exist"),
              );
            });
        return null;
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Somthing went wrong!"),
              content: Text("Please check your internet connection"),
              actions: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent),
                    elevation: MaterialStateProperty.all(0.0),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Ok',
                    style: TextStyle(color: MyColors.purpule),
                  ),
                ),
              ],
            );
          });
    }
  }

  _showSheet(String uid) async {
    final _amountController = TextEditingController();
    String? name;
    String? photo;
    final value = await getUserData(uid);
    name = value['name'];
    photo = value['photo_url'];
    return showModalBottomSheet(
      backgroundColor: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(20.0), // Customize the border radius
      ),
      isScrollControlled: true,
      context: context,
      builder: (_) => Container(
        padding: EdgeInsets.only(
            left: 10,
            right: 10,
            top: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 150),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: photo != null
                        ? NetworkImage(photo)
                        : Image.asset("lib/assets/images/profile.png").image,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(color: MyColors.borderColor, width: 3.0),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(child: Text(name ?? "User")),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: _amountController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(
                      color: MyColors.purpule,
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(
                      color: MyColors.lightGrey,
                      width: 2.0,
                    ),
                  ),
                  hintText: 'Enter Amount',
                  hintStyle: TextStyle(
                    color: MyColors.lightGrey,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: Get.width * 0.6,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Transactions.createTransaction(
                      uid, uid, double.parse(_amountController.text));
                  Navigator.pop(context);
                },
                child: Text("Confirm"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(MyColors.purpule),
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
      ),
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
          MyAppBar(name: "Send Money", back: true),
          SizedBox(
            height: 20,
          ),
          Text(
            "Scan the QR code to get the other person infos",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Theme.of(context).textTheme.displayMedium!.color,
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                MobileScanner(
                  onDetect: (qrcode) async {
                    String code = qrcode.barcodes.first.rawValue.toString();
                    _showSheet(code);
                  },
                ),
                Positioned.fill(
                  child: Container(
                    decoration: ShapeDecoration(
                      shape: QrScannerOverlayShape(
                        overlayColor: Theme.of(context).scaffoldBackgroundColor,
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
              onPressed: () async {
                _showSheet("NGlwic1z5qYTCQVqnZJWwbQeilj2");
              },
              child: Text("click")),
          Container(
              padding: EdgeInsets.all(8),
              child: Text(
                "if you're offline or the other person doesn't have the app you can use his contact",
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.displayMedium!.color,
                ),
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
