import 'package:bstable/services/currency.dart';
import 'package:bstable/ui/components/appBar.dart';
import 'package:bstable/ui/styles/decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import '../../sql/sql_helper.dart';
import '../../ui/styles/colors.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Wallet extends StatefulWidget {
  Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  Color _accountColor = MyColors.purpule;
  Color _goalColor = MyColors.purpule;
  List<Map<String, dynamic>> accounts = [];
  List<Map<String, dynamic>> goals = [];
  final _accountName = TextEditingController();
  final _accountBalance = TextEditingController();
  final _goalName = TextEditingController();
  final _goalAmount = TextEditingController();
  final _goalTarget = TextEditingController();
  final _addToGoal = TextEditingController();

  _refrechPage() async {
    final acc = await SQLHelper.getAccounts();
    final gl = await SQLHelper.getGoals();
    setState(() {
      accounts = acc;
      goals.clear();
      goals.add({});
      goals.addAll(gl);
    });
  }

  @override
  void initState() {
    super.initState();
    _refrechPage();
  }

  ///function for creating a new account
  void _createAccount(TextEditingController _accountName,
      TextEditingController _accountBalance, Color _accountColor) async {
    if (double.parse(_accountBalance.text) >= 0) {
      await SQLHelper.createAccount(_accountName.text,
          double.parse(_accountBalance.text), _accountColor.value.toString());
      _refrechPage();
      _clearAccountFeilds();
      Navigator.pop(context);
    } else {
      Get.snackbar("Error", "initial amount should be positif",
          colorText: Theme.of(context).textTheme.displaySmall!.color,
          icon: Icon(Icons.error));
    }
  }

  void _editAccount(int index, TextEditingController _accountName,
      TextEditingController _accountBalance, Color _accountColor) async {
    final id = accounts[index]['id'];
    final name = _accountName.text.isNotEmpty
        ? _accountName.text
        : accounts[index]['name'];
    final balance = _accountBalance.text.isNotEmpty
        ? double.parse(_accountBalance.text)
        : accounts[index]['balance'];
    final color = _accountColor.value.toString();
    if (balance >= 0) {
      await SQLHelper.updateAccount(id, name, balance, color);
      _clearAccountFeilds();
      _refrechPage();
      Navigator.pop(context);
    } else {
      Get.snackbar("Error", "initial amount should be positif",
          colorText: Theme.of(context).textTheme.displaySmall!.color,
          icon: Icon(Icons.error));
    }
  }

  ///function to clear all account feilds after create or edit
  void _clearAccountFeilds() {
    _accountName.clear();
    _accountBalance.clear();
  }

  ///function to clear all goal feilds after create or edit
  void _clearGoalFeilds() {
    _goalName.clear();
    _goalAmount.clear();
    _goalTarget.clear();
  }

  void _createGoal(_goalName, _goalAmount, _goalTarget, _goalColor) async {
    final name = _goalName.text;
    final amount = double.parse(_goalAmount.text);
    final goal = double.parse(_goalTarget.text);
    final color = _goalColor.value.toString();
    if (amount < goal && amount >= 0 && goal > 0) {
      await SQLHelper.createGoal(name, amount, goal, color);
      _refrechPage();
      _clearGoalFeilds();
      Navigator.pop(context);
    } else {
      Get.snackbar(
          "Error".tr, "Goal amount should be superior to initial amount".tr,
          colorText: Theme.of(context).textTheme.displaySmall!.color,
          icon: Icon(Icons.error));
    }
  }

  void _editGoal(index, _goalName, _goalAmount, _goalTarget, _goalColor) async {
    final id = goals[index]['id'];
    final name =
        _goalName.text.isNotEmpty ? _goalName.text : goals[index]['name'];
    final amount = _goalAmount.text.isNotEmpty
        ? double.parse(_goalAmount.text)
        : goals[index]['amount'];
    final goal = _goalTarget.text.isNotEmpty
        ? double.parse(_goalTarget.text)
        : goals[index]['goal'];
    final color = _goalColor.value.toString();
    if (amount < goal && amount >= 0 && goal > 0) {
      //update goal
      SQLHelper.updateGoal(id, name, amount, goal, color);
      _refrechPage();
      _clearGoalFeilds();
      Navigator.pop(context);
    } else {
      Get.snackbar("Error", "Goal amount should be superior to initial amount",
          colorText: Theme.of(context).textTheme.displaySmall!.color,
          icon: Icon(Icons.error));
    }
  }

  _popUpAccount(String title, [bool edit = false, int? index]) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(10.0), // Customize the border radius
          ),
          title: Text(
            title.tr,
            style: TextStyle(
                color: MyColors.iconColor, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(children: [
              SizedBox(height: 10),
              TextField(
                maxLength: 20,
                controller: _accountName,
                decoration: CustomDeco.inputDecoration.copyWith(
                  hintText: 'Name'.tr,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _accountBalance,
                keyboardType: TextInputType.number,
                decoration: CustomDeco.inputDecoration.copyWith(
                  hintText: 'Initial balance'.tr,
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ColorPicker(
                    pickersEnabled: {
                      ColorPickerType.primary: false,
                      ColorPickerType.custom: true,
                      ColorPickerType.accent: false,
                    },
                    customColorSwatchesAndNames: {
                      ColorTools.createPrimarySwatch(MyColors.purpule):
                          "purple",
                      ColorTools.createPrimarySwatch(MyColors.lightBlue):
                          "blue",
                      ColorTools.createPrimarySwatch(MyColors.orange): "orange",
                      ColorTools.createPrimarySwatch(MyColors.green): "green",
                    },
                    enableOpacity: false,
                    color: _accountColor,
                    onColorChanged: (Color color) {
                      setState(() {
                        _accountColor = color;
                      });
                    },
                    enableShadesSelection: false,
                  ),
                ],
              ),
            ]),
          ),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                elevation: MaterialStateProperty.all(0.0),
              ),
              onPressed: () {
                _clearAccountFeilds();
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel'.tr,
                style: TextStyle(color: MyColors.purpule),
              ),
            ),
            Container(
              width: 120,
              height: 40,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(MyColors.purpule),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                onPressed: () async {
                  edit
                      ? _editAccount(
                          index!, _accountName, _accountBalance, _accountColor)
                      : _createAccount(
                          _accountName, _accountBalance, _accountColor);
                  
                },
                child: Text(edit ? 'Save' : 'Create'.tr),
              ),
            ),
          ],
        );
      },
    );
  }

  _addToGoalPopUp(int id) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(10.0), // Customize the border radius
            ),
            title: Text(
              'Add to Goal'.tr,
              style: TextStyle(color: MyColors.iconColor),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  TextField(
                      keyboardType: TextInputType.number,
                      controller: _addToGoal,
                      decoration: CustomDeco.inputDecoration.copyWith(
                        hintText: 'Amount'.tr,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent),
                  elevation: MaterialStateProperty.all(0.0),
                ),
                onPressed: () {
                  _addToGoal.clear();
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel'.tr,
                  style: TextStyle(color: MyColors.purpule),
                ),
              ),
              Container(
                width: 120,
                height: 40,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(MyColors.purpule),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    if (double.parse(_addToGoal.text) > 0) {
                      await SQLHelper.addToGoal(
                          double.parse(_addToGoal.text), id);
                      _refrechPage();
                      _addToGoal.clear();
                      Navigator.pop(context);
                    } else {
                      Get.snackbar("Error", "Added amount should be positif",
                          colorText:
                              Theme.of(context).textTheme.displaySmall!.color,
                          icon: Icon(Icons.error));
                    }
                  },
                  child: Text('Save'.tr),
                ),
              ),
            ],
          );
        });
  }

  _popUpGoals(String title, [bool edit = false, int? index]) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(10.0), // Customize the border radius
          ),
          title: Text(
            title.tr,
            style: TextStyle(color: MyColors.iconColor),
          ),
          content: SingleChildScrollView(
            child: Column(children: [
              SizedBox(height: 10),
              TextField(
                  maxLength: 15,
                  controller: _goalName,
                  decoration: CustomDeco.inputDecoration.copyWith(
                    hintText: 'Name'.tr,
                  )),
              SizedBox(
                height: 10,
              ),
              TextField(
                  keyboardType: TextInputType.number,
                  controller: _goalAmount,
                  decoration: CustomDeco.inputDecoration.copyWith(
                    hintText: 'Initial amount'.tr,
                  )),
              SizedBox(height: 10),
              TextField(
                  keyboardType: TextInputType.number,
                  controller: _goalTarget,
                  decoration: CustomDeco.inputDecoration.copyWith(
                    hintText: 'Goal amount'.tr,
                  )),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ColorPicker(
                    pickersEnabled: {
                      ColorPickerType.primary: false,
                      ColorPickerType.custom: true,
                      ColorPickerType.accent: false,
                    },
                    customColorSwatchesAndNames: {
                      ColorTools.createPrimarySwatch(MyColors.purpule):
                          "purple",
                      ColorTools.createPrimarySwatch(MyColors.lightBlue):
                          "blue",
                      ColorTools.createPrimarySwatch(MyColors.orange): "orange",
                      ColorTools.createPrimarySwatch(MyColors.green): "green",
                    },
                    enableOpacity: false,
                    color: _goalColor,
                    onColorChanged: (Color color) {
                      setState(() {
                        _goalColor = color;
                      });
                    },
                    enableShadesSelection: false,
                  ),
                ],
              ),
            ]),
          ),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                elevation: MaterialStateProperty.all(0.0),
              ),
              onPressed: () {
                _clearGoalFeilds();
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel'.tr,
                style: TextStyle(color: MyColors.purpule),
              ),
            ),
            Container(
              width: 120,
              height: 40,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(MyColors.purpule),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                onPressed: () async {
                  edit
                      ? _editGoal(index, _goalName, _goalAmount, _goalTarget,
                          _goalColor)
                      : _createGoal(
                          _goalName, _goalAmount, _goalTarget, _goalColor);
                },
                child: Text(edit ? 'Save'.tr : 'Create'.tr),
              ),
            ),
          ],
        );
      },
    );
  }

  _goalInfo(int index) {
    return showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(20.0), // Customize the border radius
        ),
        builder: (BuildContext context) {
          return Container(
            height: 260,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(children: [
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(10),
                  //border
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  height: 60,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Goal",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .color,
                          ),
                        ),
                        Text(
                          "${goals[index]['goal']}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    _popUpGoals("Edit goal", true, index);
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    //border
                    decoration: BoxDecoration(
                      color: MyColors.blue,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    height: 60,
                    child: Center(
                      child: Stack(
                        alignment: AlignmentDirectional.centerStart,
                        children: [
                          Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 30,
                          ),
                          Align(
                            child: Text(
                              "Edit",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    await SQLHelper.deleteGoal(goals[index]['id']);
                    _refrechPage();
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    //border
                    decoration: BoxDecoration(
                      color: MyColors.red,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    height: 60,
                    child: Center(
                      child: Stack(
                        alignment: AlignmentDirectional.centerStart,
                        children: [
                          Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 30,
                          ),
                          Align(
                            child: Text(
                              "Delete",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    CurrencyController currencyController = Get.find();
    final currency = currencyController.getSelectedCurrency;
    return Scaffold(
      body: ListView(
        children: [
          MyAppBar(name: "Wallet", back: false),
          //add refresh indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Text(
              "Accounts".tr,
              style: TextStyle(
                color: Theme.of(context).textTheme.displayMedium!.color,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 20, bottom: 10),
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () {
                _popUpAccount('Create New Account');
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(color: MyColors.iconColor, width: 3.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_rounded,
                      size: 40,
                      color: MyColors.iconColor,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Create New Account".tr,
                      style: TextStyle(
                        fontSize: 20,
                        color: MyColors.iconColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ListView.builder(
              shrinkWrap: true,
              primary: false,
              scrollDirection: Axis.vertical,
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: Slidable(
                    endActionPane:
                        ActionPane(motion: StretchMotion(), children: [
                      SizedBox(
                        width: 5,
                      ),
                      SlidableAction(
                          borderRadius: BorderRadius.circular(15),
                          backgroundColor: MyColors.blue,
                          icon: Icons.edit,
                          label: "Edit".tr,
                          onPressed: (context) {
                            _popUpAccount("Edit account", true, index);
                          }),
                      SizedBox(
                        width: 5,
                      ),
                      SlidableAction(
                          borderRadius: BorderRadius.circular(15),
                          backgroundColor: Colors.red,
                          icon: Icons.delete,
                          label: "Delete".tr,
                          onPressed: (context) async {
                            await SQLHelper.deleteAccount(
                                accounts[index]['id']);
                            _refrechPage();
                          })
                    ]),
                    child: Container(
                      height: 80,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Color(int.parse(accounts[index]['color'])),
                        borderRadius: BorderRadius.circular(
                            15.0), // Specify the border radius
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              accounts[index]['name'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.grey[300]),
                            ),
                          ),
                          Text(
                              '$currency  ${accounts[index]['balance'].toString()}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.grey[300])),
                        ],
                      ),
                    ),
                  ),
                );
              }),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Text(
              "Goals".tr,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.displayMedium!.color,
                  fontSize: 25),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.builder(
              primary: false,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 5 / 6,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
              shrinkWrap: true,
              itemCount: goals.length,
              itemBuilder: (context, index) {
                double pourcentage = index != 0
                    ? ((goals[index]['amount'] * 100) / goals[index]['goal'])
                    : 0.0;
                return index == 0
                    ? InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () {
                          _popUpGoals("Create goal");
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border.all(
                                color: MyColors.iconColor, width: 3.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_rounded,
                                size: 50,
                                color: MyColors.iconColor,
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Create Goal".tr,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: MyColors.iconColor),
                              )
                            ],
                          ),
                        ),
                      )
                    : InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onLongPress: () {
                          _goalInfo(index);
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          decoration: BoxDecoration(
                            color: Color(int.parse(goals[index]['color']))
                                .withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CircularPercentIndicator(
                                        radius: 25,
                                        lineWidth: 5,
                                        percent: pourcentage >= 100
                                            ? 1
                                            : pourcentage / 100,
                                        center: Icon(
                                          //goals[index]['icon'],
                                          Icons.savings_rounded,
                                          size: 25,
                                          color: MyColors.iconColor,
                                        ),
                                        circularStrokeCap:
                                            CircularStrokeCap.round,
                                        progressColor: Colors.green,
                                        backgroundColor:
                                            MyColors.lightGrey.withOpacity(0.5),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                        child: Text(
                                          "${goals[index]['name']}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .displayMedium!
                                                  .color),
                                        ),
                                      ),
                                    ]),
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "$currency ${goals[index]['amount']}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .textTheme
                                            .displayMedium!
                                            .color,
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              pourcentage >= 100
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Completed".tr,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .displayMedium!
                                                  .color!
                                                  .withOpacity(0.5),
                                              fontSize: 20),
                                        ),
                                        Icon(
                                          Icons.check_circle,
                                          size: 40,
                                          color: Colors.green,
                                        ),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            _addToGoalPopUp(goals[index]['id']);
                                          },
                                          child: CircleAvatar(
                                            backgroundColor: MyColors.lightGrey,
                                            foregroundColor:
                                                Theme.of(context).primaryColor,
                                            radius: 30,
                                            child: Icon(Icons.add),
                                          ),
                                        ),
                                        Text(
                                          "${pourcentage.round()} %",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .displayMedium!
                                                  .color,
                                              fontSize: 30),
                                        ),
                                      ],
                                    ),
                            ],
                          ),
                        ),
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}
