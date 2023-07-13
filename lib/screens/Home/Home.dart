import 'package:bstable/screens/Home/add.dart';
import 'package:bstable/screens/Home/receiveMoney.dart';
import 'package:bstable/screens/Home/senMoney.dart';
import 'package:bstable/screens/Home/settings.dart';
import 'package:bstable/screens/Profile/profile.dart';
import 'package:bstable/sql/sql_helper.dart';
import 'package:bstable/ui/components/activity.dart';
import 'package:bstable/ui/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../ui/styles/iconlist.dart';
import '../../ui/styles/icons.dart';

import '../../ui/components/card.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> records = [];
  List<Map<String, dynamic>> accounts = [];
  bool ready = false;
  void _refreshData() async {
    final rec = await SQLHelper.getItems();
    final acc = await SQLHelper.getAccounts();
    setState(() {
      records = rec;
      accounts = acc;
      ready = true;
    });
  }

  @override
  initState() {
    super.initState();
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    final _controller = PageController(viewportFraction: 0.8);
    const double buttonRadius = 15;
    return !ready
        ? Center(
            child: CircularProgressIndicator(
            color: MyColors.purpule,
          ))
        : Scaffold(
            //////////////////////////
            body: ListView(children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.to(() => Profile());
                          },
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15.0),
                              border: Border.all(
                                  color: MyColors.borderColor, width: 3.0),
                            ),
                            child: Icon(MyIcons.profile),
                          ),
                        ),
                        Text(
                          "${DateFormat('dd MMM yyyy').format(DateTime.now())}",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                          radius: buttonRadius,
                          onTap: () {
                            Get.to(() => Settings());
                          },
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(buttonRadius),
                              border: Border.all(
                                  color: MyColors.borderColor, width: 3.0),
                            ),
                            child: Icon(
                              MyIcons.settings,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //Cards
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    child: SizedBox(
                      height: 200,
                      child: PageView.builder(
                          onPageChanged: (value) => {},
                          scrollDirection: Axis.horizontal,
                          controller: _controller,
                          itemCount: accounts.length,
                          itemBuilder: (context, index) {
                            return MyCard(
                              sold: accounts[index]['balance'],
                              title: accounts[index]['name'],
                              color: Color(int.parse(accounts[index]['color'])),
                            );
                          }),
                    ),
                  ),
                  //Scroll indicator
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        accounts.length > 1
                            ? SmoothPageIndicator(
                                controller: _controller,
                                count: accounts.length,
                                effect: ExpandingDotsEffect(
                                  activeDotColor: MyColors.darkBorder,
                                  dotColor: MyColors.lightGrey,
                                  dotHeight: 8.0,
                                  dotWidth: 8.0,
                                  expansionFactor: 4,
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),
                  ),
                  //Action Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //Recive Money
                        InkWell(
                          onTap: () {
                            Get.to(() => ReceiveMoney());
                          },
                          radius: buttonRadius,
                          child: SizedBox(
                            width: 60,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    color: MyColors.buttonGrey,
                                    borderRadius: BorderRadius.circular(15.0),
                                    border: Border.all(
                                        color: MyColors.borderColor,
                                        width: 1.0),
                                  ),
                                  child: Icon(
                                    MyIcons.cashin,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "Receive Money",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: MyColors.iconColor),
                                )
                              ],
                            ),
                          ),
                        ),
                        //Send Money
                        InkWell(
                          onTap: () {
                            Get.to(() => SendMoney());
                          },
                          radius: buttonRadius,
                          child: SizedBox(
                            width: 60,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    color: MyColors.buttonGrey,
                                    borderRadius: BorderRadius.circular(15.0),
                                    border: Border.all(
                                        color: MyColors.borderColor,
                                        width: 1.0),
                                  ),
                                  child: Icon(
                                    MyIcons.cashout,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "Send Money",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: MyColors.iconColor),
                                )
                              ],
                            ),
                          ),
                        ),
                        //ADD
                        InkWell(
                          onTap: () async {
                            final result = await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => AddTransaction()));
                            if (result) {
                              _refreshData();
                            }
                          },
                          radius: buttonRadius,
                          child: SizedBox(
                            width: 60,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    color: MyColors.buttonGrey,
                                    borderRadius: BorderRadius.circular(15.0),
                                    border: Border.all(
                                        color: MyColors.borderColor,
                                        width: 1.0),
                                  ),
                                  child: Icon(
                                    MyIcons.add,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "Add",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: MyColors.iconColor),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //Recent Activities
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Recent Acitivities",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: MyColors.iconColor),
                        ),
                        Icon(Icons.arrow_right_alt_outlined, color: Colors.blue)
                      ],
                    ),
                  ),
                  //List of Activities
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: records.length,
                      itemBuilder: (context, index) {
                        final title = records[index]['title'];
                        return Activity(
                          title: records[index]['title'],
                          amount: records[index]['amount'],
                          color: IconsList.get_color(title),
                          icon: IconsList.get_icon(title),
                          category: records[index]['category'],
                          date: DateFormat('dd.MM.yyyy | HH:mm')
                              .format(DateTime.parse(records[index]['time'])),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ]),
          );
  }
}
