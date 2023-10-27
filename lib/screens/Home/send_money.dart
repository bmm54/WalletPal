import 'package:bstable/screens/Home/add/account.dart';
import 'package:bstable/screens/Home/contacts.dart';
import 'package:bstable/services/auth_data.dart';
import 'package:bstable/services/transaction_service.dart';
import 'package:bstable/sql/sql_helper.dart';
import 'package:bstable/ui/styles/colors.dart';
import 'package:bstable/ui/styles/decoration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../ui/components/appBar.dart';

class SendMoney extends StatefulWidget {
  @override
  _SendMoneyState createState() => _SendMoneyState();
}

class _SendMoneyState extends State<SendMoney> with TickerProviderStateMixin {
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

  _showSheet(String receiverUid, context) async {
    final _controller = TabController(vsync: this, length: 2);
    final _amountController = TextEditingController();
    var accountName = accounts[0]['name'];
    var accountId = accounts[0]['id'];
    var selectedStatus = "Loan";
    String myUid = userData['id'];
    String myName = userData['name'] ?? "Unknown";
    String myPhoto = userData['image'];
    String receiverName;
    String? receiverPhoto;
    final value = await getUserData(receiverUid, context);
    receiverName = value!['name'] ?? "Unknown";
    receiverPhoto = value['image'];
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
            bottom: MediaQuery.of(context).viewInsets.bottom + 50),
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
                    image: receiverPhoto != null
                        ? NetworkImage(receiverPhoto)
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
            Center(child: Text(receiverName ?? "Unkown")),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                  controller: _amountController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: CustomDeco.inputDecoration
                      .copyWith(hintText: "Enter Amount")),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: InkWell(
                      onTap: () async {
                        final result = await Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => Account()));
                        setState(
                          () {
                            accountName = result[0];
                            accountId = result[1];
                          },
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: MyColors.darkBorder.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10)),
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              "Account".tr,
                            ),
                            Text(
                              accountName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: TabBar(
                  splashBorderRadius: BorderRadius.circular(10),
                  onTap: (index) {
                    index == 0
                        ? selectedStatus = "Loan"
                        : selectedStatus = "Paycheck";
                    print(selectedStatus);
                  },
                  indicator: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: MyColors.purpule,
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: MyColors.iconColor,
                  labelStyle: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                  controller: _controller,
                  tabs: [
                    Tab(child: Text("Loan".tr)),
                    Tab(child: Text("Paycheck".tr)),
                  ]),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Container(
                width: Get.width,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    final amount = double.parse(_amountController.text);
                    if (amount>0)
                   { try {
                      await TransactionsService().createTransaction(
                          myName,
                          myUid,
                          receiverUid,
                          receiverName,
                          amount,
                          selectedStatus,
                          myPhoto,
                          receiverPhoto);
                      await SQLHelper.updateBalance(
                          amount, "expense", accountId);
                      //resume camera
                    _scannerController.start();
                    Navigator.pop(context);
                    } catch (e) {
                      print(e);
                      Get.snackbar("Error".tr, "Something went wrong".tr,
                          colorText:
                              Theme.of(context).textTheme.displaySmall!.color,
                          icon: Icon(Icons.error));
                    }}
                    else{
                      Get.snackbar("Error".tr, "Amount must be greater than 0".tr,
                          colorText:
                              Theme.of(context).textTheme.displaySmall!.color,
                          icon: Icon(Icons.error));
                    }   
                  },
                  child: Text("Confirm".tr),
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
                    //pause the camera
                    _scannerController.stop();
                    _showSheet(receiverUid, context);
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
          TextButton(
              onPressed: () {
                _scannerController.stop();
                _showSheet("fqHcoIpuAsgb7ZOWk7eEKLkNUOG2", context);
              },
              child: Text("click")),
          Container(
              padding: EdgeInsets.all(8),
              child: Text(
                "If you're offline or the other person doesn't have the app you can use his contact"
                    .tr,
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
