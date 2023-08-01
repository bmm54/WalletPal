import 'package:bstable/screens/Home/contacts.dart';
import 'package:bstable/services/auth_data.dart';
import 'package:bstable/services/transaction.dart';
import 'package:bstable/sql/sql_helper.dart';
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
  final MobileScannerController _scannerController = MobileScannerController();

  List<DropdownMenuItem<String>> accountsNames = [];
  List accounts = [];
  _refresh() async {
    await SQLHelper.getAccounts().then((rows) {
      accounts = rows;
    });
    accountsNames.clear();
    for (var i = 0; i < accounts.length; i++) {
      print(accounts[i]['name']);
      accountsNames.add(DropdownMenuItem<String>(
        value: accounts[i]['id'].toString(),
        child: Text(accounts[i]['name']),
      ));
    }
  }

  final userData = AuthData().getUserData;
  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
    _refresh();
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

  Future<Map<String, dynamic>?> getUserData(
      String userId, BuildContext context) async {
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
            title: Text("Something went wrong!"),
            content: Text(
                "This could be due to your internet connection scanning the wrong QR code"),
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
        },
      );
      return null;
    }
  }

  _showSheet(String myUid, String receiverUid, context) async {
    final _amountController = TextEditingController();
    var selectedAccount = accounts[0]['name'];
    String? name;
    String? photo;
    final value = await getUserData(receiverUid, context);
    name = value!['name'];
    photo = value['photo_url'];
    return showModalBottomSheet(
      enableDrag: false,
      isDismissible: false,
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
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    _scannerController.start();
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.close,
                    size: 40,
                  ),
                ),
              ),
            ),
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
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: DropdownButton<String>(
                    dropdownColor: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10),
                    underline: Container(
                      height: 0,
                    ),
                    value: "Loan",
                    style: TextStyle(
                        color: Theme.of(context).textTheme.displayMedium!.color,
                        fontWeight: FontWeight.bold),
                    alignment: Alignment.center,
                    onChanged: (String? newValue) {
                      setState(() {
                        //selectedCurrency = newValue!;
                      });
                    },
                    items: <String>['Loan', 'Paycheck'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                      color: Theme.of(context)
                          .primaryColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: DropdownButton<String>(
                    dropdownColor: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10),
                    underline: Container(
                      height: 0,
                    ),
                    value: selectedAccount,
                    hint: Text("Sect account"),
                    style: TextStyle(
                        color: Theme.of(context).textTheme.displayMedium!.color,
                        fontWeight: FontWeight.bold),
                    alignment: Alignment.center,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedAccount = newValue!;
                      });
                    },
                    items: accountsNames,
                  ),
                )
              ],
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
            //add two drop downs one for status ['loan','paycheck']
            //one for accounts
            SizedBox(
              height: 30,
            ),
            Container(
              width: Get.width * 0.6,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Transactions.createTransaction(
                      myUid, receiverUid, double.parse(_amountController.text));
                  //resume camera
                  _scannerController.start();
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
    return Scaffold(
      body: Column(
        children: [
          MyAppBar(name: "Send Money", back: true),
          SizedBox(
            height: 20,
          ),
          Text(
            "Scan the QR code to get the other person infos".tr,
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
                  controller: _scannerController,
                  onDetect: (qrcode) async {
                    String receiverUid =
                        qrcode.barcodes.first.rawValue.toString();
                    String myUid = userData['id'];
                    //pause the camera
                    _scannerController.stop();
                    _showSheet(myUid, receiverUid, context);
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
                String myUid = userData['id'];
                _showSheet(myUid, "SOwyUaG8WZXmMCHtAuM3I0qpYX73", context);
                _scannerController.stop();
              },
              child: Text("click")),
          Container(
              padding: EdgeInsets.all(8),
              child: Text(
                "if you're offline or the other person doesn't have the app you can use his contact".tr,
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
                      "Select Contact".tr,
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
